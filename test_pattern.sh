function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi
    local header; header=$(head -n 1 "$file_path")
    local num_vertices; num_vertices=$(echo "$header" | awk '{print $2}')
    echo "Vertices: $num_vertices"
    if ! [[ "$num_vertices" =~ ^[0-9]+$ ]] || [[ "$num_vertices" -eq 0 ]]; then echo "ERROR_INVALID_VERTICES"; return; fi
    local matrix; matrix=$(printf '0%.0s' $(seq 1 $((num_vertices * num_vertices))))
    while IFS=' ' read -r type u v _; do
        if [[ "$type" == "e" ]]; then
            echo "Edge: $u -> $v"
            if [[ "$u" -lt "$num_vertices" && "$v" -lt "$num_vertices" ]]; then
                local index1=$((u * num_vertices + v)); local index2=$((v * num_vertices + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"; matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < "$file_path"
    echo "$matrix"
}

pattern=$(file_to_binary_string "/home/williamp/thesis_data/query_sets/dblp/small_dense_4v/query_sample_4v_1.graph")
echo "Pattern: $pattern"
echo "Length: ${#pattern}"
