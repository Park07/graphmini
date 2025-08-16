#!/bin/bash

echo "=== GraphMini Unified Performance Framework (TODS) ==="

# --- CONFIGURATION ---
PROJECT_ROOT="/home/williamp/graphmini"
DATA_ROOT="/home/williamp/thesis_data/snap_format"

cd "$PROJECT_ROOT/build" || exit 1

# Test with smaller set first
DATASETS=("dblp")  # Start with just dblp

# Use patterns that we KNOW work with GraphMini
PATTERNS=(
    # Patterns that work
    "4clique 0111101111011110 clique-4nodes"
    "4cycle 0101101001011010 cycle-4nodes"
    "5clique 0111110111101111011110111110111110 clique-5nodes"
    "triangle 011101110 triangle-3nodes"
    
    # Test one of your patterns (will likely fail)
    "your_4v 0101100100011110 your-4v-4e"
)

THREAD_COUNTS=(1 4 16 32)
RESULTS_DIR="${PROJECT_ROOT}/results/unified_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "=== Test Configuration ==="
echo "Datasets: ${DATASETS[@]}"
echo "Patterns: ${#PATTERNS[@]} patterns"
echo "Threads: ${THREAD_COUNTS[@]}"
echo "Results: $RESULTS_DIR"

# CSV header
echo "Dataset,Pattern,Pattern_Size,Threads,LoadTime_s,ExecutionTime_s,Result_Count,Memory_MB,Speedup,Efficiency,Status" > "$RESULTS_DIR/results.csv"

declare -A baselines

for dataset in "${DATASETS[@]}"; do
    echo ""
    echo "========================================="
    echo "TESTING DATASET: $dataset"
    echo "========================================="
    
    # Check if dataset is preprocessed
    if [ ! -f "${DATA_ROOT}/${dataset}/meta.txt" ]; then
        echo "ERROR: Dataset not preprocessed: ${DATA_ROOT}/${dataset}"
        continue
    fi
    
    for pattern_info in "${PATTERNS[@]}"; do
        read pattern_name pattern_binary pattern_desc <<< "$pattern_info"
        pattern_size=$(echo "sqrt(${#pattern_binary})" | bc -l | cut -d'.' -f1)
        
        echo ""
        echo "--- Pattern: $pattern_name ($pattern_desc) ---"
        
        baseline_key="${dataset}_${pattern_name}"
        
        for threads in "${THREAD_COUNTS[@]}"; do
            echo -n "  Testing $threads threads: "
            
            export OMP_NUM_THREADS=$threads
            
            # Step 1: Generate code (might fail for sparse patterns)
            ./bin/run "$dataset" "${DATA_ROOT}/${dataset}/" "$pattern_name" "$pattern_binary" 0 0 0 > /tmp/run.log 2>&1
            run_exit=$?
            
            if [ $run_exit -eq 136 ]; then
                echo "❌ FAILED (Floating point exception)"
                echo "$dataset,$pattern_name,$pattern_size,$threads,N/A,N/A,N/A,N/A,N/A,N/A,FP_EXCEPTION" >> "$RESULTS_DIR/results.csv"
                continue
            fi
            
            # Step 2: Execute
            log_file="$RESULTS_DIR/${dataset}_${pattern_name}_${threads}t.log"
            timeout 60 /usr/bin/time -v ./bin/runner $threads "${DATA_ROOT}/${dataset}/" > "$log_file" 2>&1
            exit_code=$?
            
            if [ $exit_code -eq 124 ]; then
                echo "❌ TIMEOUT"
                echo "$dataset,$pattern_name,$pattern_size,$threads,N/A,N/A,N/A,N/A,N/A,N/A,TIMEOUT" >> "$RESULTS_DIR/results.csv"
                continue
            fi
            
            # Parse results
            load_time=$(grep "LoadTime" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
            exec_time=$(grep "CODE_EXECUTION_TIME" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
            result_count=$(grep "RESULT=" "$log_file" | grep -o '[0-9]*' | head -1)
            peak_mem_kb=$(grep "Maximum resident set size" "$log_file" | grep -o '[0-9]*' | head -1)
            peak_mem_mb=$(echo "scale=1; ${peak_mem_kb:-0} / 1024" | bc -l)
            
            if [ -n "$exec_time" ] && [ -n "$result_count" ]; then
                # Calculate speedup
                if [ $threads -eq 1 ]; then
                    baselines["$baseline_key"]="$exec_time"
                    speedup="1.00"
                    efficiency="100.0"
                else
                    baseline="${baselines[$baseline_key]}"
                    if [ -n "$baseline" ]; then
                        speedup=$(echo "scale=2; $baseline / $exec_time" | bc -l)
                        efficiency=$(echo "scale=1; $speedup * 100 / $threads" | bc -l)
                    else
                        speedup="N/A"
                        efficiency="N/A"
                    fi
                fi
                
                echo "✅ ${exec_time}s, $result_count matches, ${speedup}x speedup"
                echo "$dataset,$pattern_name,$pattern_size,$threads,$load_time,$exec_time,$result_count,$peak_mem_mb,$speedup,$efficiency,SUCCESS" >> "$RESULTS_DIR/results.csv"
            else
                echo "❌ FAILED"
                echo "$dataset,$pattern_name,$pattern_size,$threads,N/A,N/A,N/A,N/A,N/A,N/A,FAILED" >> "$RESULTS_DIR/results.csv"
            fi
        done
    done
done

echo ""
echo "========================================="
echo "ANALYSIS COMPLETE"
echo "========================================="
echo "Results saved to: $RESULTS_DIR/results.csv"

# Quick summary
echo ""
echo "=== SUMMARY ==="
grep "SUCCESS" "$RESULTS_DIR/results.csv" | wc -l | xargs echo "Successful tests:"
grep "FP_EXCEPTION" "$RESULTS_DIR/results.csv" | wc -l | xargs echo "Floating point exceptions:"
grep "TIMEOUT" "$RESULTS_DIR/results.csv" | wc -l | xargs echo "Timeouts:"
grep "FAILED" "$RESULTS_DIR/results.csv" | wc -l | xargs echo "Other failures:"
