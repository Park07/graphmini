#!/usr/bin/env python3
import pandas as pd
import numpy as np
import glob
import os
import re
import matplotlib.pyplot as plt
import seaborn as sns

def find_all_csv_files(base_paths):
    """Recursively finds all CSV files in a list of base directories."""
    all_files = []
    for path in base_paths:
        # Expands the ~ to the user's home directory
        expanded_path = os.path.expanduser(path)
        files = glob.glob(f"{expanded_path}/**/*.csv", recursive=True)
        all_files.extend(files)
    return all_files

def analyze_and_visualize(results_dirs):
    """
    Reads all experiment CSVs from multiple algorithm directories, merges them,
    and produces a comprehensive, publication-quality summary.
    """
    print(f"📈 Analyzing all results from specified directories...")

    all_csv_files = find_all_csv_files(results_dirs)
    if not all_csv_files:
        print("❌ ERROR: No CSV files found. Please check the paths in the 'results_base_paths' variable.")
        return

    # --- 1. Load, Merge, and Clean Data ---
    df_list = []
    for f in all_csv_files:
        algo = 'Unknown'
        if 'graphmini-o' in f:
            algo = 'GraphMini-O'
        elif 'graphmini' in f:
            algo = 'GraphMini-OMP'
        elif 'slf' in f:
            algo = 'SLF'

        try:
            temp_df = pd.read_csv(f)

            # Skip files that seem malformed
            if len(temp_df) < 1:
                print(f"⚠️  Skipping empty file: {f}")
                continue

            # Check if this looks like a valid results file
            expected_cols = ['Dataset', 'Threads', 'ExecutionTime_s', 'Status']
            if not any(col in temp_df.columns for col in expected_cols):
                print(f"⚠️  Skipping file that doesn't look like results data: {os.path.basename(f)}")
                continue

            # Standardize column names BEFORE concatenating to avoid duplicates
            temp_df.rename(columns={
                'Pattern_Type': 'PatternCategory',
                'Pattern_Name': 'QueryFile'
            }, inplace=True)

            temp_df['Algorithm'] = algo
            df_list.append(temp_df)
        except Exception as e:
            print(f"⚠️  Could not read or process {os.path.basename(f)}: {e}")

    if not df_list:
        print("❌ ERROR: No data could be loaded. Exiting.")
        return

    df = pd.concat(df_list, ignore_index=True)
    print(f"   Found {len(df)} total test records for {df['Algorithm'].nunique()} algorithms.")

    # Debug: Check what algorithms we actually have
    print(f"   Algorithms found: {df['Algorithm'].value_counts().to_dict()}")

    # --- 2. Standardize Column Names and Data Types ---
    # First, remove duplicate columns
    df = df.loc[:, ~df.columns.duplicated()]

    # Debug: Check columns
    print(f"   Available columns: {df.columns.tolist()}")

    if 'PatternCategory' not in df.columns and 'QueryFile' in df.columns:
         df['PatternCategory'] = df['QueryFile'].str.extract(r'([a-zA-Z_]+(?:[48]v)?)')[0]

    # Standardize PatternCategory names
    if 'PatternCategory' in df.columns:
        df['PatternCategory'] = df['PatternCategory'].replace('Your_Patterns', 'random_walk')
        print(f"   PatternCategory sample values after standardization: {df['PatternCategory'].head().tolist()}")
        print(f"   All unique PatternCategories: {sorted(df['PatternCategory'].dropna().unique())}")

    required_cols = ['Algorithm', 'Dataset', 'PatternCategory', 'QueryFile', 'Threads', 'ExecutionTime_s', 'Status']
    missing_cols = [col for col in required_cols if col not in df.columns]
    if missing_cols:
        print(f"❌ ERROR: Missing required columns: {missing_cols}")
        print(f"   Available columns: {df.columns.tolist()}")
        return

    # Check for duplicate columns in required columns
    for col in required_cols:
        if col in df.columns:
            col_series = df[col]
            if hasattr(col_series, 'shape') and len(col_series.shape) > 1:
                print(f"⚠️ WARNING: Column '{col}' appears to be multi-dimensional")
                print(f"   Shape: {col_series.shape}")

    df['ExecutionTime_s'] = pd.to_numeric(df['ExecutionTime_s'], errors='coerce')
    df_success = df[df['Status'] == 'SUCCESS'].copy()

    if df_success.empty:
        print("⚠️ WARNING: No successful runs found to analyze. Exiting.")
        return

    # Debug: Check algorithm distribution in successful runs
    print(f"   Successful runs by algorithm: {df_success['Algorithm'].value_counts().to_dict()}")
    print(f"   Successful runs by dataset: {df_success['Dataset'].value_counts().to_dict()}")

    # --- 3. Calculate Speedup & Efficiency ---
    baselines = df_success[df_success['Threads'] == 1].groupby(['Dataset', 'Algorithm', 'QueryFile'])['ExecutionTime_s'].mean().rename('BaselineTime_s')
    df_success = pd.merge(df_success, baselines, on=['Dataset', 'Algorithm', 'QueryFile'], how='left')
    df_success['Speedup'] = df_success['BaselineTime_s'] / df_success['ExecutionTime_s']

    # --- 4. Generate Reports and Charts ---
    CHART_OUTPUT_DIR = "final_charts"
    os.makedirs(CHART_OUTPUT_DIR, exist_ok=True)
    print(f"\n🎨 Generating charts and reports in: {CHART_OUTPUT_DIR}")

    # Find patterns that exist across multiple algorithms for fair comparison
    pattern_algo_matrix = df_success.groupby(['PatternCategory', 'Algorithm']).size().unstack(fill_value=0)
    pattern_algo_counts = (pattern_algo_matrix > 0).sum(axis=1)
    shared_patterns = pattern_algo_counts[pattern_algo_counts > 1].index.tolist()

    print(f"\n📊 Pattern availability across algorithms:")
    for pattern in pattern_algo_matrix.index:
        algos = pattern_algo_matrix.columns[(pattern_algo_matrix.loc[pattern] > 0)].tolist()
        count = pattern_algo_matrix.loc[pattern].sum()
        print(f"   {pattern}: {algos} ({count} total runs)")

    print(f"\n🔍 Shared patterns for algorithm comparison: {shared_patterns}")

    if shared_patterns:
        print(f"\n🔥 Creating algorithm comparisons for shared patterns...")
        for pattern in shared_patterns:
            pattern_data = df_success[df_success['PatternCategory'] == pattern]
            if len(pattern_data['Algorithm'].unique()) >= 2:  # At least 2 algorithms
                create_algorithm_comparison_chart(pattern_data, pattern, CHART_OUTPUT_DIR)
                create_algorithm_boxplot_comparison(pattern_data, pattern, CHART_OUTPUT_DIR)

    # Also create per-dataset analysis
    for dataset in df['Dataset'].unique():
        print(f"\n--- Analysis for Dataset: {dataset} ---")
        df_dataset = df[df['Dataset'] == dataset]
        df_success_dataset = df_success[df_success['Dataset'] == dataset]

        if df_success_dataset.empty:
            print("   No successful runs for this dataset.")
            continue

        # Only show shared patterns in summary tables
        df_shared = df_success_dataset[df_success_dataset['PatternCategory'].isin(shared_patterns)]
        if not df_shared.empty:
            generate_algorithm_comparison_table(df_shared, dataset)

        # Still create individual charts for all patterns
        generate_summary_tables(df_success_dataset, dataset)
        create_speedup_barchart(df_success_dataset, dataset, CHART_OUTPUT_DIR)

        # Create scalability chart for any shared pattern that exists in this dataset
        dataset_shared = [p for p in shared_patterns if p in df_success_dataset['PatternCategory'].values]
        if dataset_shared:
            create_scalability_linechart(df_success, dataset_shared[0], dataset, CHART_OUTPUT_DIR)

    print("\n✅ Analysis and visualization complete.")

def generate_algorithm_comparison_table(df, dataset_name):
    """Creates a table comparing algorithms on the same pattern categories."""

    print(f"\n🔥 ALGORITHM COMPARISON for {dataset_name.upper()}")
    print("="*80)

    # Create a comparison table showing algorithms side by side for each pattern
    for pattern in df['PatternCategory'].unique():
        pattern_data = df[df['PatternCategory'] == pattern]

        print(f"\n📋 Pattern: {pattern}")
        print("-" * 60)

        # Show baseline times (1 thread) for each algorithm
        baseline_data = pattern_data[pattern_data['Threads'] == 1]
        if not baseline_data.empty:
            print("Baseline (1T):")
            for _, row in baseline_data.iterrows():
                print(f"  {row['Algorithm']:15}: {row['ExecutionTime_s']:.3f}s")

        # Show speedup at max threads for each algorithm
        max_threads = pattern_data['Threads'].max()
        max_thread_data = pattern_data[pattern_data['Threads'] == max_threads]
        if not max_thread_data.empty:
            print(f"\nSpeedup at {max_threads}T:")
            for _, row in max_thread_data.iterrows():
                speedup = row.get('Speedup', 0)
                print(f"  {row['Algorithm']:15}: {speedup:.2f}x")

def create_algorithm_comparison_chart(pattern_data, pattern_category, output_dir):
    """Creates publication-quality IEEE-style charts comparing algorithms."""

    if pattern_data.empty:
        return

    # Calculate statistics for error bars
    stats = pattern_data.groupby(['Algorithm', 'Threads']).agg({
        'ExecutionTime_s': ['mean', 'std', 'count'],
        'Speedup': ['mean', 'std', 'count']
    }).reset_index()

    # Flatten column names
    stats.columns = ['Algorithm', 'Threads', 'time_mean', 'time_std', 'time_count',
                     'speedup_mean', 'speedup_std', 'speedup_count']

    # IEEE style settings
    plt.rcParams.update({
        'font.size': 12,
        'font.family': 'serif',
        'axes.linewidth': 1.0,
        'axes.grid': True,
        'grid.alpha': 0.3,
        'lines.linewidth': 2.0,
        'lines.markersize': 8,
        'figure.dpi': 300
    })

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 4))

    # Define colors and markers for consistency
    colors = {'GraphMini-OMP': '#1f77b4', 'GraphMini-O': '#ff7f0e', 'SLF': '#2ca02c'}
    markers = {'GraphMini-OMP': 'o', 'GraphMini-O': 's', 'SLF': '^'}

    # Left plot: Speedup with error bars
    for algo in stats['Algorithm'].unique():
        algo_data = stats[stats['Algorithm'] == algo]
        ax1.errorbar(algo_data['Threads'], algo_data['speedup_mean'],
                    yerr=algo_data['speedup_std'],
                    label=algo, marker=markers.get(algo, 'o'),
                    color=colors.get(algo, 'black'),
                    capsize=4, capthick=1.5, linewidth=2.0, markersize=8)

    ax1.set_xlabel('Number of Threads')
    ax1.set_ylabel('Speedup')
    ax1.set_xscale('log', base=2)
    ax1.set_xticks([1, 2, 4, 8, 16, 32, 64])
    ax1.set_xticklabels(['1', '2', '4', '8', '16', '32', '64'])
    ax1.grid(True, alpha=0.3)
    ax1.legend(frameon=True, fancybox=False, shadow=False)
    ax1.set_title(f'Speedup - {pattern_category}')

    # Add ideal speedup line
    max_threads = stats['Threads'].max()
    ideal_threads = [1, 2, 4, 8, 16, 32, 64]
    ideal_threads = [t for t in ideal_threads if t <= max_threads]
    ax1.plot(ideal_threads, ideal_threads, '--', color='gray', alpha=0.7, label='Ideal')

    # Right plot: Execution time with error bars
    for algo in stats['Algorithm'].unique():
        algo_data = stats[stats['Algorithm'] == algo]
        ax2.errorbar(algo_data['Threads'], algo_data['time_mean'],
                    yerr=algo_data['time_std'],
                    label=algo, marker=markers.get(algo, 'o'),
                    color=colors.get(algo, 'black'),
                    capsize=4, capthick=1.5, linewidth=2.0, markersize=8)

    ax2.set_xlabel('Number of Threads')
    ax2.set_ylabel('Execution Time (s)')
    ax2.set_xscale('log', base=2)
    ax2.set_yscale('log')
    ax2.set_xticks([1, 2, 4, 8, 16, 32, 64])
    ax2.set_xticklabels(['1', '2', '4', '8', '16', '32', '64'])
    ax2.grid(True, alpha=0.3)
    ax2.legend(frameon=True, fancybox=False, shadow=False)
    ax2.set_title(f'Execution Time - {pattern_category}')

    plt.tight_layout()

    # Save both PDF and PNG for different uses
    pdf_path = os.path.join(output_dir, f"algorithm_comparison_{pattern_category}.pdf")
    png_path = os.path.join(output_dir, f"algorithm_comparison_{pattern_category}.png")

    plt.savefig(pdf_path, bbox_inches='tight', dpi=300)
    plt.savefig(png_path, bbox_inches='tight', dpi=300)

    print(f"   -> Saved Algorithm Comparison Chart to {pdf_path}")
    plt.close()

    # Reset matplotlib settings
    plt.rcParams.update(plt.rcParamsDefault)

def create_algorithm_boxplot_comparison(pattern_data, pattern_category, output_dir):
    """Creates IEEE-style boxplot comparison of algorithms on same pattern."""

    if pattern_data.empty:
        return

    # IEEE style settings
    plt.rcParams.update({
        'font.size': 12,
        'font.family': 'serif',
        'axes.linewidth': 1.0,
        'figure.dpi': 300
    })

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

    # Define colors
    colors = {'GraphMini-OMP': '#1f77b4', 'GraphMini-O': '#ff7f0e', 'SLF': '#2ca02c'}

    # Left plot: Speedup boxplots by algorithm and thread count
    speedup_data = pattern_data[pattern_data['Threads'] > 1]  # Exclude 1 thread (speedup = 1)

    if not speedup_data.empty:
        # Create combined labels for better grouping
        speedup_data = speedup_data.copy()
        speedup_data['AlgoThread'] = speedup_data['Algorithm'] + '\n(' + speedup_data['Threads'].astype(str) + 'T)'

        box_plot1 = ax1.boxplot([speedup_data[speedup_data['AlgoThread'] == combo]['Speedup'].values
                                for combo in speedup_data['AlgoThread'].unique()],
                               labels=speedup_data['AlgoThread'].unique(),
                               patch_artist=True, showmeans=True, meanline=True)

        # Color the boxes
        for patch, label in zip(box_plot1['boxes'], speedup_data['AlgoThread'].unique()):
            algo = label.split('\n')[0]
            patch.set_facecolor(colors.get(algo, 'gray'))
            patch.set_alpha(0.7)

    ax1.set_ylabel('Speedup')
    ax1.set_title(f'Speedup Distribution - {pattern_category}')
    ax1.grid(True, alpha=0.3)
    plt.setp(ax1.get_xticklabels(), rotation=45, ha='right')

    # Right plot: Execution time boxplots by algorithm (1 thread only for fair comparison)
    baseline_data = pattern_data[pattern_data['Threads'] == 1]

    if not baseline_data.empty:
        algorithms = baseline_data['Algorithm'].unique()
        exec_time_by_algo = [baseline_data[baseline_data['Algorithm'] == algo]['ExecutionTime_s'].values
                            for algo in algorithms]

        box_plot2 = ax2.boxplot(exec_time_by_algo, labels=algorithms,
                               patch_artist=True, showmeans=True, meanline=True)

        # Color the boxes
        for patch, algo in zip(box_plot2['boxes'], algorithms):
            patch.set_facecolor(colors.get(algo, 'gray'))
            patch.set_alpha(0.7)

    ax2.set_ylabel('Execution Time (s)')
    ax2.set_title(f'Baseline Performance - {pattern_category}')
    ax2.set_yscale('log')
    ax2.grid(True, alpha=0.3)
    plt.setp(ax2.get_xticklabels(), rotation=45, ha='right')

    plt.tight_layout()

    # Save both formats
    pdf_path = os.path.join(output_dir, f"boxplot_comparison_{pattern_category}.pdf")
    png_path = os.path.join(output_dir, f"boxplot_comparison_{pattern_category}.png")

    plt.savefig(pdf_path, bbox_inches='tight', dpi=300)
    plt.savefig(png_path, bbox_inches='tight', dpi=300)

    print(f"   -> Saved Boxplot Comparison to {pdf_path}")
    plt.close()

    # Reset matplotlib settings
    plt.rcParams.update(plt.rcParamsDefault)

def generate_summary_tables(df, dataset_name):
    """Creates and prints the final summary tables for a given dataset."""

    # Debug: Show what we're working with
    print(f"   Summary table data for {dataset_name}:")
    print(f"   - Algorithms: {df['Algorithm'].unique()}")
    print(f"   - Pattern categories: {df['PatternCategory'].unique()}")
    print(f"   - Thread counts: {sorted(df['Threads'].unique())}")

    baseline_summary = df[df['Threads'] == 1].groupby('PatternCategory')['ExecutionTime_s'].agg(['mean', 'std']).fillna(0)
    baseline_summary['Baseline Time (s)'] = baseline_summary.apply(lambda r: f"{r['mean']:.2f} ± {r['std']:.2f}", axis=1)

    speedup_summary = df[df['Threads'] > 1].groupby(['PatternCategory', 'Threads'])['Speedup'].agg(['mean', 'std']).unstack().fillna(0)

    for threads in speedup_summary.columns.get_level_values(1):
        speedup_summary[(f'Speedup @ {threads}T', '')] = speedup_summary.apply(lambda r: f"{r[('mean', threads)]:.2f}x ± {r[('std', threads)]:.2f}x", axis=1)

    final_perf_table = pd.concat([baseline_summary['Baseline Time (s)'], speedup_summary.xs('', axis=1, level=1)], axis=1)

    all_categories = sorted(df['PatternCategory'].dropna().unique())
    final_perf_table = final_perf_table.reindex(all_categories).fillna("DNF")

    print("\n" + "="*95)
    print(f"✅ Final Performance Summary for {dataset_name.upper()} (Execution Time & Speedup)")
    print("="*95)
    print(final_perf_table.to_string())
    print("="*95)

def create_speedup_barchart(df_dataset, dataset_name, output_dir):
    """Creates publication-quality IEEE-style speedup bar chart."""
    if df_dataset.empty:
        return

    max_threads = df_dataset['Threads'].max()
    df_max = df_dataset[df_dataset['Threads'] == max_threads]

    # Calculate statistics for error bars
    stats = df_max.groupby(['PatternCategory', 'Algorithm']).agg({
        'Speedup': ['mean', 'std', 'count']
    }).reset_index()
    stats.columns = ['PatternCategory', 'Algorithm', 'speedup_mean', 'speedup_std', 'speedup_count']

    # IEEE style settings
    plt.rcParams.update({
        'font.size': 12,
        'font.family': 'serif',
        'axes.linewidth': 1.0,
        'figure.dpi': 300
    })

    fig, ax = plt.subplots(figsize=(10, 6))

    # Define colors
    colors = {'GraphMini-OMP': '#1f77b4', 'GraphMini-O': '#ff7f0e', 'SLF': '#2ca02c'}

    # Create grouped bar chart with error bars
    patterns = stats['PatternCategory'].unique()
    algorithms = stats['Algorithm'].unique()

    bar_width = 0.25
    x = np.arange(len(patterns))

    for i, algo in enumerate(algorithms):
        algo_data = stats[stats['Algorithm'] == algo]
        means = []
        stds = []

        for pattern in patterns:
            pattern_data = algo_data[algo_data['PatternCategory'] == pattern]
            if not pattern_data.empty:
                means.append(pattern_data['speedup_mean'].iloc[0])
                stds.append(pattern_data['speedup_std'].iloc[0])
            else:
                means.append(0)
                stds.append(0)

        ax.bar(x + i * bar_width, means, bar_width,
               yerr=stds, capsize=4, capthick=1.5,
               label=algo, color=colors.get(algo, 'gray'),
               alpha=0.8, edgecolor='black', linewidth=0.5)

    ax.set_xlabel('Query Pattern Category')
    ax.set_ylabel(f'Speedup at {max_threads} Threads')
    ax.set_xticks(x + bar_width)
    ax.set_xticklabels(patterns, rotation=45, ha='right')
    ax.legend(frameon=True, fancybox=False, shadow=False)
    ax.grid(axis='y', alpha=0.3)

    plt.tight_layout()

    # Save both formats
    pdf_path = os.path.join(output_dir, f"speedup_comparison_{dataset_name}.pdf")
    png_path = os.path.join(output_dir, f"speedup_comparison_{dataset_name}.png")

    plt.savefig(pdf_path, bbox_inches='tight', dpi=300)
    plt.savefig(png_path, bbox_inches='tight', dpi=300)

    print(f"   -> Saved Speedup Bar Chart to {pdf_path}")
    plt.close()

    # Reset matplotlib settings
    plt.rcParams.update(plt.rcParamsDefault)

def create_scalability_linechart(df, category, dataset_name, output_dir):
    """Creates a professional line chart showing raw time scalability."""
    df_cat = df[(df['PatternCategory'] == category) & (df['Dataset'] == dataset_name)]
    if df_cat.empty: return

    plt.style.use('seaborn-v0_8-paper')
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.lineplot(data=df_cat, x='Threads', y='ExecutionTime_s', hue='Algorithm', style='Algorithm',
                 markers=True, dashes=False, ax=ax, linewidth=2.5, markersize=8, errorbar='sd')
    ax.set_title(f'Scalability on "{category}" Queries on {dataset_name}', fontsize=16, fontweight='bold')
    ax.set_xlabel('Number of Threads (Log Scale)', fontsize=12)
    ax.set_ylabel('Average Execution Time (s) (Log Scale)', fontsize=12)
    ax.set_xscale('log', base=2)
    ax.set_yscale('log')
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xticks(sorted(df['Threads'].unique()))
    ax.legend(title='Algorithm', fontsize=10)
    ax.grid(which='both', linestyle='--', alpha=0.7)
    plt.tight_layout()
    output_path = os.path.join(output_dir, f"scalability_{dataset_name}_{category}.pdf")
    plt.savefig(output_path)
    print(f"   -> Saved Scalability Line Chart to {output_path}")
    plt.close()

if __name__ == "__main__":
    # --- FOCUS ON GRAPHMINI FIRST ---
    results_base_paths = [
        "~/graphmini/results/comprehensive_20250814_093318",
        "~/graphmini-o/results/comprehensive_o_20250816_091436",
        "~/graphmini/results/comprehensive_o_20250816_101427",
        # "~/slf/results/slf_unified_run_20250817_051557"  # Add this back later
    ]
    analyze_and_visualize(results_base_paths)