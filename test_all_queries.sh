#!/bin/bash
cd ~/graphmini/build

echo "Testing which queries work with GraphMini..."

for dataset in dblp; do  # Test with just dblp first
    echo "Dataset: $dataset"
    
    for category in small_dense_4v small_sparse_4v; do
        query_dir="/home/williamp/thesis_data/query_sets/$dataset/$category"
        if [ ! -d "$query_dir" ]; then
            continue
        fi
        
        echo "  Category: $category"
        
        for query_file in $(ls $query_dir/*.graph | head -5); do
            query_name=$(basename $query_file .graph)
            
            # Generate pattern
            pattern=$(bash -c '
                file="'$query_file'"
                header=$(head -n 1 "$file")
                num_vertices=$(echo "$header" | awk "{print \$2}")
                matrix=$(printf "0%.0s" $(seq 1 $((num_vertices * num_vertices))))
                while IFS=" " read -r type u v _; do
                    if [[ "$type" == "e" ]]; then
                        if [[ "$u" -lt "$num_vertices" && "$v" -lt "$num_vertices" ]]; then
                            index1=$((u * num_vertices + v))
                            index2=$((v * num_vertices + u))
                            matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                            matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
                        fi
                    fi
                done < "$file"
                echo "$matrix"
            ')
            
            echo -n "    $query_name: "
            
            # Test the query
            timeout 1 ./bin/run "$dataset" "/home/williamp/thesis_data/snap_format/$dataset/" "$query_name" "$pattern" 0 0 0 > /tmp/test.log 2>&1
            
            if grep -q "PATTERN_SIZE" /tmp/test.log; then
                echo "WORKS"
            elif grep -q "Exception" /tmp/test.log; then
                echo "FAILS (Exception)"
            else
                echo "UNKNOWN"
            fi
        done
    done
done
