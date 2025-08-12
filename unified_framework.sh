#!/bin/bash

echo "=== GraphMini Unified Performance Framework (Standalone Edition) ==="

# --- 1. CONFIGURATION ---
# Use absolute paths to make the script runnable from anywhere.
HKU_QUERY_ROOT="/Users/williampark/desktop/dataset/dblp/query_graph"
PROJECT_ROOT="/Users/williampark/graphmini"

# Define the dataset and thread counts for this test run.
DATASETS=("dblp")
THREAD_COUNTS=(1 2 4)

# Define the pattern categories to test, matching your slf script's methodology.
# Format: "category_name;filename_pattern"
PATTERN_CATEGORIES=(
    "small_dense_4;query_dense_4_*.graph"
    "small_sparse_4;query_sparse_4_*.graph"
)

# --- 2. SETUP ---
cd "$PROJECT_ROOT" || { echo "ERROR: Could not cd to project root '$PROJECT_ROOT'. Exiting."; exit 1; }

BRANCH_NAME=$(git branch --show-current | sed 's/[^a-zA-Z0-9]/-/g')
RESULTS_DIR="${PROJECT_ROOT}/results/graphmini_run_${BRANCH_NAME}_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

RESULTS_CSV="$RESULTS_DIR/graphmini_results.csv"
echo " Setup complete. Results will be saved in: $RESULTS_CSV"
echo "Dataset,PatternCategory,QueryFile,QueryVertices,QueryEdges,Threads,LoadTime_s,ExecutionTime_s,Result_Count,Memory_Peak_MB,Status,Notes" > "$RESULTS_CSV"

# --- 3. HELPER FUNCTION ---
# Converts an HKU-format .graph file to the binary string GraphMini needs.
function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi

    local header
    header=$(head -n 1 "$file_path")
    local num_vertices
    num_vertices=$(echo "$header" | awk '{print $2}')

    if ! [[ "$num_vertices" =~ ^[0-9]+$ ]] || [[ "$num_vertices" -eq 0 ]]; then
        echo "ERROR_INVALID_VERTICES"; return
    fi

    local matrix
    matrix=$(printf '0%.0s' $(seq 1 $((num_vertices * num_vertices))))

    while IFS=' ' read -r type u v _; do
        if [[ "$type" == "e" ]]; then
            if [[ "$u" -lt "$num_vertices" && "$v" -lt "$num_vertices" ]]; then
                local index1=$((u * num_vertices + v))
                local index2=$((v * num_vertices + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < "$file_path"
    echo "$matrix"
}

# --- 4. MAIN EXECUTION LOOP ---
cd "${PROJECT_ROOT}/build" || { echo "ERROR: Could not cd to build directory. Exiting."; exit 1; }

# Loop through the defined pattern categories.
for category_info in "${PATTERN_CATEGORIES[@]}"; do
    IFS=';' read -r category_name filename_pattern <<< "$category_info"

    echo ""
    echo "======================================================"
    echo "Processing Category: $category_name"
    echo "======================================================"

    # Find, sort, and limit to the first 50 queries for THIS category.
    # The 'while' loop reads from a process substitution <(...) to avoid subshell issues.
    while IFS= read -r query_file; do
        test_name=$(basename "$query_file" .graph)
        header=$(head -n 1 "$query_file")
        query_vertices=$(echo "$header" | awk '{print $2}')
        query_edges=$(echo "$header" | awk '{print $3}')

        echo ""
        echo "--- Testing: ${test_name} (${query_vertices}v, ${query_edges}e) ---"

        pattern_binary=$(file_to_binary_string "$query_file")
        if [[ "$pattern_binary" == "ERROR"* ]]; then
            echo "  ->  ERROR: Could not convert query file. Skipping. ($pattern_binary)"
            continue
        fi

        for threads in "${THREAD_COUNTS[@]}"; do
            echo "  -> Running with $threads threads..."
            export OMP_NUM_THREADS=$threads

            # Generate code using the correct 0 4 0 parameters for OpenMP mode.
            ./bin/run "dblp" "../dataset/GraphMini/dblp" "$test_name" "$pattern_binary" 0 4 0 > /dev/null 2>&1

            # Execute the generated runner and log performance.
            log_file="$RESULTS_DIR/log_${test_name}_${threads}t.log"
            /usr/bin/time -l ./bin/runner 1 "../dataset/GraphMini/dblp" > "$log_file" 2>&1
            exit_code=$?

            status="SUCCESS"; notes=""
            if [ $exit_code -ne 0 ]; then status="FAILED"; notes="Exit code ${exit_code}"; fi

            # Parse results from the log file.
            load_time=$(grep "LoadTime" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
            exec_time=$(grep "CODE_EXECUTION_TIME" "$log_file" | grep -o '[0-9]*\.[0-9]*' | head -1)
            result_count=$(grep "RESULT=" "$log_file" | grep -o '[0-9]*' | head -1)
            peak_mem_kb=$(grep "maximum resident set size" "$log_file" | grep -o '[0-9]*' | tail -1)
            peak_mem_mb=$(echo "scale=1; ${peak_mem_kb:-0} / 1024" | bc -l)

            if [ "$status" != "SUCCESS" ]; then
                exec_time="N/A"; result_count="N/A"
            fi

            echo "     -> Status: ${status}, Time: ${exec_time:-N/A}s, Results: ${result_count:-N/A}"
            echo "dblp,$category_name,${test_name}.graph,$query_vertices,$query_edges,$threads,$load_time,$exec_time,$result_count,$peak_mem_mb,$status,$notes" >> "$RESULTS_CSV"
        done
    done < <(find "$HKU_QUERY_ROOT" -name "$filename_pattern" | sort -V | head -n 50)
done

echo ""
echo "========================================="
echo " UNIFIED ANALYSIS COMPLETE"
echo "Results are in: $RESULTS_CSV"
echo "========================================="