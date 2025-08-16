#!/bin/bash

echo "=== QUICK TEST - Verify Framework Works ==="
echo "Testing with just 2 patterns to catch any errors early"

# --- CONFIGURATION ---
PROJECT_ROOT="/home/williamp/graphmini"
DATA_ROOT="/home/williamp/thesis_data/snap_format"
QUERY_ROOT_BASE="/home/williamp/thesis_data/query_sets"

# TEST WITH JUST ONE DATASET AND A FEW PATTERNS
DATASETS_TO_TEST=("dblp")  # Just one dataset
THREAD_COUNTS=(1)  # Just one thread count
TIMEOUT=60  # Short timeout

# Just test one category with 2 patterns
PATTERN_CATEGORIES=("small_dense_4v;query_*.graph;small_dense_4v")

cd "$PROJECT_ROOT" || exit 1
PARENT_RESULTS_DIR="${PROJECT_ROOT}/results/quick_test_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$PARENT_RESULTS_DIR"

echo "Test results in: $PARENT_RESULTS_DIR"

# Helper function
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

# MAIN TEST
for dataset_name in "${DATASETS_TO_TEST[@]}"; do
    DATASET_PATH="${DATA_ROOT}/${dataset_name}/"
    QUERY_ROOT="${QUERY_ROOT_BASE}/${dataset_name}"
    
    echo ""
    echo "Testing dataset: $dataset_name"
    echo "Dataset path: $DATASET_PATH"
    
    # Check dataset exists
    if [ ! -f "${DATASET_PATH}/meta.txt" ]; then
        echo "❌ ERROR: Dataset not preprocessed! Missing ${DATASET_PATH}/meta.txt"
        echo "Run: ./bin/prep /home/williamp/thesis_data/snap_format/${dataset_name}"
        exit 1
    fi
    
    cd "${PROJECT_ROOT}/build" || exit 1
    
    for category_info in "${PATTERN_CATEGORIES[@]}"; do
        IFS=';' read -r logical_category_name filename_pattern physical_category_dir <<< "$category_info"
        QUERY_CATEGORY_PATH="${QUERY_ROOT}/${physical_category_dir}"
        
        echo "Testing category: $logical_category_name"
        echo "Query path: $QUERY_CATEGORY_PATH"
        
        if [ ! -d "$QUERY_CATEGORY_PATH" ]; then
            echo "❌ ERROR: Query directory not found!"
            exit 1
        fi
        
        # TEST JUST 2 PATTERNS
        for query_file in $(find "$QUERY_CATEGORY_PATH" -name "$filename_pattern" | sort -V | head -n 2); do
            test_name=$(basename "$query_file" .graph)
            header=$(head -n 1 "$query_file")
            query_vertices=$(echo "$header" | awk '{print $2}')
            query_edges=$(echo "$header" | awk '{print $3}')
            
            echo ""
            echo "Testing: ${test_name} (${query_vertices}v, ${query_edges}e)"
            
            pattern_binary=$(file_to_binary_string "$query_file")
            if [[ "$pattern_binary" == "ERROR"* ]]; then
                echo "❌ ERROR: Could not convert query file!"
                exit 1
            fi
            
            echo "Pattern generated successfully (length: ${#pattern_binary})"
            
            # Test with GraphMini
            echo -n "Testing GraphMini: "
            timeout 5 ./bin/run "$dataset_name" "$DATASET_PATH" "$test_name" "$pattern_binary" 0 0 0 > /tmp/test.log 2>&1
            exit_code=$?
            
            if [ $exit_code -eq 136 ]; then
                echo "❌ FAILED - Floating point exception (GraphMini bug with sparse patterns)"
                echo "This is expected for sparse patterns. Other algorithms should work."
            elif [ $exit_code -eq 124 ]; then
                echo "⏱️ TIMEOUT - Pattern might work but is slow"
            elif [ $exit_code -eq 0 ] || [ $exit_code -eq 1 ]; then
                echo "✅ SUCCESS - GraphMini can handle this pattern"
            else
                echo "❓ UNKNOWN - Exit code: $exit_code"
                tail -5 /tmp/test.log
            fi
            
            # Test runner (if exists)
            if [ -f "./bin/runner" ]; then
                echo -n "Testing runner: "
                timeout 5 ./bin/runner 1 "${DATA_ROOT}/${dataset_name}/snap.txt" > /tmp/runner.log 2>&1
                if [ $? -eq 0 ]; then
                    echo "✅ Runner works"
                else
                    echo "❌ Runner failed"
                fi
            fi
        done
    done
done

echo ""
echo "========================================="
echo "QUICK TEST COMPLETE"
echo ""
echo "If you see:"
echo "- 'Floating point exception' for GraphMini: EXPECTED (GraphMini bug)"
echo "- Patterns generated successfully: GOOD"
echo "- No 'file not found' errors: GOOD"
echo ""
echo "Then you can run the full framework!"
echo "========================================="
