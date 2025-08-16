#!/bin/bash

echo "=== COMPREHENSIVE GraphMini Test (TODS) ==="
echo "Starting at: $(date)"

# --- CONFIGURATION ---
PROJECT_ROOT="/home/williamp/graphmini"
DATA_ROOT="/home/williamp/thesis_data/snap_format"
QUERY_ROOT="/home/williamp/thesis_data/query_sets"

cd "$PROJECT_ROOT/build" || exit 1

# All datasets
DATASETS=("dblp" "youtube" "roadNet-CA" "enron" "lj" "wiki")

# Results directory
RESULTS_DIR="${PROJECT_ROOT}/results/comprehensive_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

# Log everything
exec > >(tee -a "$RESULTS_DIR/full_log.txt")
exec 2>&1

echo "=== Test Configuration ==="
echo "Datasets: ${DATASETS[@]}"
echo "Results directory: $RESULTS_DIR"
echo ""

# CSV header
echo "Dataset,Pattern_Type,Pattern_Name,Vertices,Edges,Threads,LoadTime_s,ExecutionTime_s,Result_Count,Memory_MB,Speedup,Efficiency,Status,Notes" > "$RESULTS_DIR/comprehensive_results.csv"

# Original GraphMini patterns (P1-P8)
declare -A GRAPHMINI_PATTERNS=(
    ["P1"]="0111101111011110"  # 4-clique
    ["P2"]="0110010111110110110001100"  # 5-vertex pattern
    ["P3"]="0110010111110110110101110"  # 5-vertex pattern
    ["P4"]="0111110111110111110111110"  # 5-clique
    ["P5"]="011111101111110110111000111000110000"  # 6-vertex pattern
    ["P6"]="011110101101110011110000101000011000"  # 6-vertex pattern
    ["P7"]="011110101011110010100001111000010100"  # 6-vertex pattern
    ["P8"]="0111111101111111011111110111111101111111001111100"  # 7-vertex pattern
)

# Function to get pattern size
get_pattern_size() {
    local binary=$1
    echo "sqrt(${#binary})" | bc -l | cut -d'.' -f1
}

# Function to determine thread counts based on pattern size
get_thread_counts() {
    local pattern_size=$1
    local pattern_name=$2

    # For P8 and patterns >6 vertices, limit threads
    if [[ "$pattern_name" == "P8" ]] || [[ $pattern_size -gt 6 ]]; then
        echo "1 4 16"  # Stop at 16 threads for large patterns
    else
        echo "1 4 16 32 64"  # Full thread test for smaller patterns
    fi
}

# Function to get timeout based on pattern size
get_execution_timeout() {
    local pattern_size=$1
    local pattern_name=$2

    if [[ "$pattern_name" == "P8" ]] || [[ $pattern_size -gt 6 ]]; then
        echo "210"  # 3.5 minutes for large patterns
    else
        echo "300"  # 5 minutes for normal patterns
    fi
}

# Function to load a real pattern from your generated files
load_real_pattern() {
    local dataset=$1
    local category=$2
    local index=$3

    local pattern_file="${QUERY_ROOT}/${dataset}/${category}/query_sample_*v_${index}.graph"
    pattern_file=$(ls $pattern_file 2>/dev/null | head -1)

    if [ ! -f "$pattern_file" ]; then
        echo "ERROR_NOT_FOUND"
        return
    fi

    # Parse the pattern file
    local header=$(head -1 "$pattern_file")
    local vertices=$(echo "$header" | awk '{print $2}')
    local edges=$(echo "$header" | awk '{print $3}')

    # Generate binary matrix
    local matrix=$(printf '0%.0s' $(seq 1 $((vertices * vertices))))
    while IFS=' ' read -r type u v _; do
        if [[ "$type" == "e" ]]; then
            if [[ "$u" -lt "$vertices" && "$v" -lt "$vertices" ]]; then
                local index1=$((u * vertices + v))
                local index2=$((v * vertices + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < "$pattern_file"

    echo "${vertices}:${edges}:${matrix}"
}

# Store baselines for speedup calculation
declare -A baselines

echo "========================================="
echo "STARTING COMPREHENSIVE TEST"
echo "========================================="

for dataset in "${DATASETS[@]}"; do
    echo ""
    echo "========================================="
    echo "DATASET: $dataset"
    echo "========================================="

    # Check if dataset is preprocessed
    if [ ! -f "${DATA_ROOT}/${dataset}/meta.txt" ]; then
        echo "⚠️  WARNING: Dataset not preprocessed, skipping"
        continue
    fi

    echo ""
    echo "--- Testing Original GraphMini Patterns (P1-P8) ---"

    for pattern_name in P1 P2 P3 P4 P5 P6 P7 P8; do
        pattern_binary="${GRAPHMINI_PATTERNS[$pattern_name]}"
        pattern_size=$(get_pattern_size "$pattern_binary")

        echo ""
        echo "Pattern: $pattern_name (${pattern_size}x${pattern_size})"

        # Get appropriate thread counts and timeout
        thread_counts=$(get_thread_counts $pattern_size "$pattern_name")
        exec_timeout=$(get_execution_timeout $pattern_size "$pattern_name")

        baseline_key="${dataset}_${pattern_name}"

        for threads in $thread_counts; do
            echo -n "  ${threads}t: "

            export OMP_NUM_THREADS=$threads

            # Generate code (30s timeout for code generation)
            timeout 30 ./bin/run "$dataset" "${DATA_ROOT}/${dataset}/" "$pattern_name" "$pattern_binary" 0 0 0 > /tmp/run.log 2>&1
            run_exit=$?

            if [ $run_exit -eq 124 ]; then
                echo "❌ TIMEOUT_CODEGEN"
                echo "$dataset,GraphMini_Original,$pattern_name,$pattern_size,N/A,$threads,N/A,N/A,N/A,N/A,N/A,N/A,TIMEOUT_CODEGEN,Code generation timeout (30s)" >> "$RESULTS_DIR/comprehensive_results.csv"
                continue
            fi

            # Execute with appropriate timeout
            log_file="$RESULTS_DIR/${dataset}_${pattern_name}_${threads}t.log"
            timeout $exec_timeout /usr/bin/time -v ./bin/runner $threads "${DATA_ROOT}/${dataset}/" > "$log_file" 2>&1
            exit_code=$?

            if [ $exit_code -eq 124 ]; then
                echo "❌ TIMEOUT_EXEC (${exec_timeout}s)"
                echo "$dataset,GraphMini_Original,$pattern_name,$pattern_size,N/A,$threads,N/A,N/A,N/A,N/A,N/A,N/A,TIMEOUT_EXEC,Execution timeout (${exec_timeout}s)" >> "$RESULTS_DIR/comprehensive_results.csv"
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

                echo "✅ ${exec_time}s, ${result_count} matches, ${speedup}x"
                echo "$dataset,GraphMini_Original,$pattern_name,$pattern_size,N/A,$threads,$load_time,$exec_time,$result_count,$peak_mem_mb,$speedup,$efficiency,SUCCESS,Original pattern" >> "$RESULTS_DIR/comprehensive_results.csv"
            else
                echo "❌ FAILED"
                echo "$dataset,GraphMini_Original,$pattern_name,$pattern_size,N/A,$threads,N/A,N/A,N/A,$peak_mem_mb,N/A,N/A,FAILED,Unknown error" >> "$RESULTS_DIR/comprehensive_results.csv"
            fi
        done
    done

    echo ""
    echo "--- Testing Your Generated Patterns ---"

    # Test selection of your patterns - SKIP large patterns
    for test_case in "small_dense_4v:1" "small_sparse_4v:1" "small_dense_8v:1" "small_sparse_8v:1"; do
        IFS=':' read -r category index <<< "$test_case"

        echo ""
        echo "Testing: $category (pattern #$index)"

        # Load the pattern
        pattern_info=$(load_real_pattern "$dataset" "$category" "$index")

        if [ "$pattern_info" == "ERROR_NOT_FOUND" ]; then
            echo "  Pattern file not found, skipping"
            continue
        fi

        IFS=':' read -r vertices edges pattern_binary <<< "$pattern_info"
        pattern_name="${category}_${index}"

        echo "  Pattern: ${vertices}v, ${edges}e"

        # Determine thread counts based on vertices
        if [ $vertices -ge 8 ]; then
            thread_counts="1 4 16"  # Stop at 16 for 8v patterns
            exec_timeout="210"  # 3.5 minutes
            codegen_timeout="60"  # 1 minute for code generation
        else
            thread_counts="1 4 16 32 64"
            exec_timeout="300"  # 5 minutes
            codegen_timeout="30"  # 30 seconds
        fi

        baseline_key="${dataset}_${pattern_name}"

        for threads in $thread_counts; do
            echo -n "  ${threads}t: "

            export OMP_NUM_THREADS=$threads

            # Generate code
            timeout $codegen_timeout ./bin/run "$dataset" "${DATA_ROOT}/${dataset}/" "$pattern_name" "$pattern_binary" 0 0 0 > /tmp/run.log 2>&1
            run_exit=$?

            if [ $run_exit -eq 124 ]; then
                echo "❌ TIMEOUT_CODEGEN (${codegen_timeout}s)"
                echo "$dataset,Your_Patterns,$pattern_name,$vertices,$edges,$threads,N/A,N/A,N/A,N/A,N/A,N/A,TIMEOUT_CODEGEN,Code generation timeout (${codegen_timeout}s)" >> "$RESULTS_DIR/comprehensive_results.csv"
                # Skip remaining threads if code generation fails
                break
            fi

            # Execute
            log_file="$RESULTS_DIR/${dataset}_${pattern_name}_${threads}t.log"
            timeout $exec_timeout /usr/bin/time -v ./bin/runner $threads "${DATA_ROOT}/${dataset}/" > "$log_file" 2>&1
            exit_code=$?

            if [ $exit_code -eq 124 ]; then
                echo "❌ TIMEOUT_EXEC (${exec_timeout}s)"
                echo "$dataset,Your_Patterns,$pattern_name,$vertices,$edges,$threads,N/A,N/A,N/A,N/A,N/A,N/A,TIMEOUT_EXEC,Execution timeout (${exec_timeout}s)" >> "$RESULTS_DIR/comprehensive_results.csv"
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

                echo "✅ ${exec_time}s, ${result_count} matches, ${speedup}x"
                echo "$dataset,Your_Patterns,$pattern_name,$vertices,$edges,$threads,$load_time,$exec_time,$result_count,$peak_mem_mb,$speedup,$efficiency,SUCCESS,Your pattern worked!" >> "$RESULTS_DIR/comprehensive_results.csv"
            else
                echo "❌ FAILED"
                echo "$dataset,Your_Patterns,$pattern_name,$vertices,$edges,$threads,N/A,N/A,N/A,$peak_mem_mb,N/A,N/A,FAILED,Execution failed" >> "$RESULTS_DIR/comprehensive_results.csv"
            fi
        done
    done
done

echo ""
echo "========================================="
echo "COMPREHENSIVE TEST COMPLETE"
echo "========================================="
echo "Ended at: $(date)"
echo ""
echo "=== SUMMARY ==="
echo "Results CSV: $RESULTS_DIR/comprehensive_results.csv"
echo "Full log: $RESULTS_DIR/full_log.txt"
echo ""

# Quick summary
echo "Test outcomes:"
grep -c "SUCCESS" "$RESULTS_DIR/comprehensive_results.csv" | xargs echo "  Successful:"
grep -c "TIMEOUT" "$RESULTS_DIR/comprehensive_results.csv" | xargs echo "  Timeouts:"
grep -c "FAILED" "$RESULTS_DIR/comprehensive_results.csv" | xargs echo "  Failures:"

echo ""
echo "Full results saved to: $RESULTS_DIR/"
EOF

