#!/bin/bash
cd ~/graphmini/build

echo "Testing 8-vertex patterns..."

# Helper function to generate binary pattern for 8 vertices
generate_8v_pattern() {
    local file=$1
    local num_vertices=8
    local matrix=$(printf '0%.0s' $(seq 1 64))  # 8x8 = 64
    
    while IFS=' ' read -r type u v _; do
        if [[ "$type" == "e" ]]; then
            if [[ "$u" -lt "$num_vertices" && "$v" -lt "$num_vertices" ]]; then
                local index1=$((u * num_vertices + v))
                local index2=$((v * num_vertices + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < "$file"
    echo "$matrix"
}

for dataset in dblp; do
    for category in small_dense_8v small_sparse_8v; do
        query_dir="/home/williamp/thesis_data/query_sets/$dataset/$category"
        if [ ! -d "$query_dir" ]; then
            continue
        fi
        
        echo "Category: $category"
        
        # Test first 3 queries
        for query_file in $(ls $query_dir/*.graph | head -3); do
            query_name=$(basename $query_file .graph)
            header=$(head -n 1 "$query_file")
            vertices=$(echo "$header" | awk '{print $2}')
            edges=$(echo "$header" | awk '{print $3}')
            
            echo -n "  $query_name ($vertices v, $edges e): "
            
            pattern=$(generate_8v_pattern "$query_file")
            
            timeout 2 ./bin/run "$dataset" "/home/williamp/thesis_data/snap_format/$dataset/" "$query_name" "$pattern" 0 0 0 > /tmp/test.log 2>&1
            exit_code=$?
            
            if [ $exit_code -eq 124 ]; then
                echo "TIMEOUT (probably working but slow)"
            elif grep -q "PATTERN_SIZE=8" /tmp/test.log; then
                echo "WORKS"
            elif [ $exit_code -eq 136 ]; then
                echo "FAILS (Floating point exception)"
            else
                echo "Exit code: $exit_code"
            fi
        done
    done
done
