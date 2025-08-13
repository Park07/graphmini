#!/bin/bash

function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi
    
    local n
    n=$(head -n 1 "$file_path")
    if ! [[ "$n" =~ ^[0-9]+$ ]] || [[ "$n" -eq 0 ]]; then echo "ERROR_INVALID_VERTICES"; return; fi
    
    local matrix=$(printf '0%.0s' $(seq 1 $((n * n))))
    
    while IFS=' ' read -r u v; do
        if [[ -n "$u" && -n "$v" ]] && [[ "$u" =~ ^[0-9]+$ ]] && [[ "$v" =~ ^[0-9]+$ ]]; then
            if [[ $u -lt $n && $v -lt $n ]]; then
                local index1=$((u * n + v))
                local index2=$((v * n + u))
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < <(tail -n +2 "$file_path")
    
    echo "$matrix"
}

echo "=== FIXED Binary Conversion Test ==="
echo "Triangle test:"
file_to_binary_string test_patterns/triangle.graph

echo ""
echo "Different query patterns:"
file_to_binary_string queries/dblp/small_sparse/query_v8_id0.graph
echo ""
file_to_binary_string queries/dblp/small_sparse/query_v8_id1.graph
