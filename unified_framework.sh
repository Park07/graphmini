#!/bin/bash

echo "=== GraphMini Unified Performance Framework (TODS Server Edition) ==="

# --- 1. CONFIGURATION ---
PROJECT_ROOT="/home/williamp/graphmini"
DATA_ROOT="/home/williamp/thesis_data/snap_format"  # Use preprocessed data
QUERY_ROOT_BASE="/home/williamp/thesis_data/query_sets"

# Define datasets to test (all except the still-downloading friendster)
DATASETS_TO_TEST=("dblp" "youtube" "roadNet-CA" "enron" "lj" "wiki")

THREAD_COUNTS=(1 4 16 32 64)
TIMEOUT=1200 # 20 minutes

PATTERN_CATEGORIES=(
    "small_dense_4v;query_*.graph;small_dense_4v"
    "small_sparse_4v;query_*.graph;small_sparse_4v"
    "small_dense_8v;query_*.graph;small_dense_8v"
    "small_sparse_8v;query_*.graph;small_sparse_8v"
    "medium_dense;query_*.graph;medium_dense"
    "medium_sparse;query_*.graph;medium_sparse"
    "large_dense;query_*.graph;large_dense"
    "large_sparse;query_*.graph;large_sparse"
)

# --- 2. SETUP ---
cd "$PROJECT_ROOT" || { echo "ERROR: Could not cd to project root '$PROJECT_ROOT'. Exiting."; exit 1; }
PARENT_RESULTS_DIR="${PROJECT_ROOT}/results/graphmini_unified_run_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$PARENT_RESULTS_DIR"
echo "✅ Framework initialized. All results will be saved in: $PARENT_RESULTS_DIR"

# --- 3. HELPER FUNCTION ---
function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi
    local header; header=$(head -n 1 "$file_path")
    local num_vertices; num_vertices=$(echo "$header" | awk '{print $2}')
    if ! [[ "$num_vertices" =~ ^[0-9]+$ ]] || [[ "$num_vertices" -eq 0 ]]; then echo "ERROR_INVALID_VERTICES"; return; fi
    local matrix; matrix=$(printf '0%.0s' $(seq 1 $((num_vertices * num_vertices))))
    while IFS=' ' read -r type u v _; do
        if [[ "$type" == "e" ]]; then
            if [[ "$u" -lt "$num_vertices" && "$v" -lt "$num_vertices" ]]; then
                local index1=$((u * num_vertices + v)); local index2=$((v * num_vertices + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"; matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < "$file_path"; echo "$matrix"
}

# --- 4. MAIN EXECUTION LOOP ---
for dataset_name in "${DATASETS_TO_TEST[@]}"; do

    DATASET_PATH="${DATA_ROOT}/${dataset_name}/"  # Directory path, not file
    QUERY_ROOT="${QUERY_ROOT_BASE}/${dataset_name}"
    DATASET_RESULTS_DIR="${PARENT_RESULTS_DIR}/${dataset_name}"
    mkdir -p "$DATASET_RESULTS_DIR"
    RESULTS_CSV="$DATASET_RESULTS_DIR/graphmini_results_${dataset_name}.csv"

    echo ""
    echo "🚀 Starting test run for DATASET: '$dataset_name'"
    echo "   Results will be saved in: $RESULTS_CSV"
    echo "Dataset,PatternCategory,QueryFile,QueryVertices,QueryEdges,Threads,LoadTime_s,ExecutionTime_s,Result_Count,Memory_Peak_MB,Status,Notes" > "$RESULTS_CSV"

    # REMOVED: Special case for dblp/youtube
    # All datasets now use the same query structure from query_sets

    cd "${PROJECT_ROOT}/build" || { echo "ERROR: Could not cd to build directory. Exiting."; continue; }

    for category_info in "${PATTERN_CATEGORIES[@]}"; do
        IFS=';' read -r logical_category_name filename_pattern physical_category_dir <<< "$category_info"

        QUERY_CATEGORY_PATH="${QUERY_ROOT}/${physical_category_dir}"
        echo ""
        echo "====================== Processing Category: $logical_category_name ======================"

        if [ ! -d "$QUERY_CATEGORY_PATH" ]; then
            echo "⚠️  WARNING: Query directory not found, skipping: $QUERY_CATEGORY_PATH"
            continue
        fi

        while IFS= read -r query_file; do
            test_name=$(basename "$query_file" .graph)
            header=$(head -n 1 "$query_file")
            query_vertices=$(echo "$header" | awk '{print $2}'); query_edges=$(echo "$header" | awk '{print $3}')
            echo ""
            echo "--- Testing: ${test_name} (${query_vertices}v, ${query_edges}e) ---"

            pattern_binary=$(file_to_binary_string "$query_file")
            if [[ "$pattern_binary" == "ERROR"* ]]; then
                echo "  -> ❌ ERROR: Could not convert query file. Skipping. ($pattern_binary)"
                continue
            fi

            for threads in "${THREAD_COUNTS[@]}"; do
                echo "  -> Running with $threads threads..."
                export OMP_NUM_THREADS=$threads

                # Use pruning type 1 (static) to avoid floating point errors
                ./bin/run "$dataset_name" "$DATASET_PATH" "$test_name" "$pattern_binary" 0 0 0 > /dev/null 2>&1

                log_file="$DATASET_RESULTS_DIR/log_${test_name}_${threads}t.log"
                # Note: runner expects the data file path, not directory
                timeout "$TIMEOUT" /usr/bin/time -l ./bin/runner 1 "${DATA_ROOT}/${dataset_name}/snap.txt" > "$log_file" 2>&1
                exit_code=$?

                status="SUCCESS"; notes=""
                if [ $exit_code -eq 124 ]; then status="TIMEOUT"; notes="Exceeded ${TIMEOUT}s limit"; fi
                if [ $exit_code -ne 0 ] && [ $exit_code -ne 124 ]; then status="FAILED"; notes="Exit code ${exit_code}"; fi

                load_time=$(grep "LoadTime" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
                exec_time=$(grep "CODE_EXECUTION_TIME" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
                result_count=$(grep "RESULT=" "$log_file" | grep -o '[0-9]*' | head -1)
                peak_mem_kb=$(grep "maximum resident set size" "$log_file" | grep -o '[0-9]*' | tail -1)
                peak_mem_mb=$(echo "scale=1; ${peak_mem_kb:-0} / 1024" | bc -l)

                if [ "$status" != "SUCCESS" ]; then
                    exec_time="N/A"; result_count="N/A"
                fi

                echo "     -> Status: ${status}, Time: ${exec_time:-N/A}s, Results: ${result_count:-N/A}"
                echo "$dataset_name,$logical_category_name,${test_name}.graph,$query_vertices,$query_edges,$threads,$load_time,$exec_time,$result_count,$peak_mem_mb,$status,$notes" >> "$RESULTS_CSV"
            done
        done < <(find "$QUERY_CATEGORY_PATH" -name "$filename_pattern" | sort -V | head -n 20)
    done
done

echo ""
echo "========================================="
echo "✅ UNIFIED ANALYSIS COMPLETE"
echo "All results are in: $PARENT_RESULTS_DIR"
echo "========================================="