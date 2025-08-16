#!/bin/bash

echo "=== GraphMini Framework - Testing Only Working Patterns ==="

PROJECT_ROOT="/home/williamp/graphmini"
DATA_ROOT="/home/williamp/thesis_data/snap_format"
QUERY_ROOT_BASE="/home/williamp/thesis_data/query_sets"

DATASETS_TO_TEST=("dblp")  # Start with one dataset
THREAD_COUNTS=(1 4)  # Start with fewer threads for testing

# Only test categories that might work (skip 4v patterns)
PATTERN_CATEGORIES=(
    "small_dense_8v;query_*.graph;small_dense_8v"
    "small_sparse_8v;query_*.graph;small_sparse_8v"
)

cd "$PROJECT_ROOT" || exit 1
PARENT_RESULTS_DIR="${PROJECT_ROOT}/results/graphmini_8v_test_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$PARENT_RESULTS_DIR"

echo "Results will be saved in: $PARENT_RESULTS_DIR"

# Binary pattern generator for any size
function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi
    local header; header=$(head -n 1 "$file_path")
    local num_vertices; num_vertices=$(echo "$header" | awk '{print $2}')
    
    # Limit to 12 vertices max (144 bit pattern) to avoid memory issues
    if [ "$num_vertices" -gt 12 ]; then
        echo "ERROR_TOO_LARGE"
        return
    fi
    
    if ! [[ "$num_vertices" =~ ^[0-9]+$ ]] || [[ "$num_vertices" -eq 0 ]]; then 
        echo "ERROR_INVALID_VERTICES"
        return
    fi
    
    local matrix; matrix=$(printf '0%.0s' $(seq 1 $((num_vertices * num_vertices))))
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

for dataset_name in "${DATASETS_TO_TEST[@]}"; do
    DATASET_PATH="${DATA_ROOT}/${dataset_name}/"
    QUERY_ROOT="${QUERY_ROOT_BASE}/${dataset_name}"
    DATASET_RESULTS_DIR="${PARENT_RESULTS_DIR}/${dataset_name}"
    mkdir -p "$DATASET_RESULTS_DIR"
    RESULTS_CSV="$DATASET_RESULTS_DIR/graphmini_results_${dataset_name}.csv"
    
    echo ""
    echo "Testing dataset: $dataset_name"
    echo "Dataset,PatternCategory,QueryFile,QueryVertices,QueryEdges,Threads,Status,Notes" > "$RESULTS_CSV"
    
    cd "${PROJECT_ROOT}/build" || continue
    
    for category_info in "${PATTERN_CATEGORIES[@]}"; do
        IFS=';' read -r logical_category_name filename_pattern physical_category_dir <<< "$category_info"
        QUERY_CATEGORY_PATH="${QUERY_ROOT}/${physical_category_dir}"
        
        echo "  Category: $logical_category_name"
        
        if [ ! -d "$QUERY_CATEGORY_PATH" ]; then
            echo "    NOT FOUND: $QUERY_CATEGORY_PATH"
            continue
        fi
        
        for query_file in $(find "$QUERY_CATEGORY_PATH" -name "$filename_pattern" | sort -V | head -n 3); do
            test_name=$(basename "$query_file" .graph)
            header=$(head -n 1 "$query_file")
            query_vertices=$(echo "$header" | awk '{print $2}')
            query_edges=$(echo "$header" | awk '{print $3}')
            
            echo -n "    $test_name (${query_vertices}v, ${query_edges}e): "
            
            pattern_binary=$(file_to_binary_string "$query_file")
            if [[ "$pattern_binary" == "ERROR"* ]]; then
                echo "SKIPPED ($pattern_binary)"
                echo "$dataset_name,$logical_category_name,${test_name}.graph,$query_vertices,$query_edges,ALL,SKIPPED,$pattern_binary" >> "$RESULTS_CSV"
                continue
            fi
            
            # Quick test first
            timeout 1 ./bin/run "$dataset_name" "$DATASET_PATH" "$test_name" "$pattern_binary" 0 0 0 >/dev/null 2>&1
            exit_code=$?
            
            if [ $exit_code -eq 136 ]; then
                echo "INCOMPATIBLE (FP exception)"
                for threads in "${THREAD_COUNTS[@]}"; do
                    echo "$dataset_name,$logical_category_name,${test_name}.graph,$query_vertices,$query_edges,$threads,INCOMPATIBLE,Floating point exception" >> "$RESULTS_CSV"
                done
            else
                echo "Testing..."
                for threads in "${THREAD_COUNTS[@]}"; do
                    export OMP_NUM_THREADS=$threads
                    timeout 60 ./bin/run "$dataset_name" "$DATASET_PATH" "$test_name" "$pattern_binary" 0 0 0 >/dev/null 2>&1
                    exit_code=$?
                    
                    if [ $exit_code -eq 0 ]; then
                        status="SUCCESS"
                    elif [ $exit_code -eq 124 ]; then
                        status="TIMEOUT"
                    else
                        status="FAILED_$exit_code"
                    fi
                    
                    echo "      ${threads}t: $status"
                    echo "$dataset_name,$logical_category_name,${test_name}.graph,$query_vertices,$query_edges,$threads,$status," >> "$RESULTS_CSV"
                done
            fi
        done
    done
done

echo ""
echo "Testing complete. Results in: $PARENT_RESULTS_DIR"
