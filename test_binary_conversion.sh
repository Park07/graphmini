#!/bin/bash

# Copy your exact function from unified_framework.sh
function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi
    local n; n=$(head -n 1 "$file_path")
    if ! [[ "$n" =~ ^[0-9]+$ ]] || [[ "$n" -eq 0 ]]; then echo "ERROR_INVALID_VERTICES"; return; fi
    local matrix; matrix=$(printf '0%.0s' $(seq 1 $((n * n))))
    tail -n +2 "$file_path" | while read -r u v; do
        if [[ -n "$u" && -n "$v" ]]; then
            local index1=$((u * n + v)); local index2=$((v * n + u))
            matrix=$(echo "${matrix:0:index1}1${matrix:index1+1}")
            matrix=$(echo "${matrix:0:index2}1${matrix:index2+1}")
        fi
    done
    echo "$matrix"
}

echo "=== Binary Conversion Test ==="
echo ""

# Test small sparse patterns
echo "Small Sparse Patterns:"
for i in {0..2}; do
    file="queries/dblp/small_sparse/query_v8_id${i}.graph"
    echo "File: $(basename "$file")"
    echo "Edges: $(tail -n +2 "$file" | head -3 | tr '\n' ' ')"
    binary=$(file_to_binary_string "$file")
    echo "Binary: ${binary:0:30}...${binary:34:30}"
    echo "Length: ${#binary}"
    echo ""
done

echo "Small Dense Patterns:"
for i in {0..1}; do
    file="queries/dblp/small_dense/query_v8_id${i}.graph"
    echo "File: $(basename "$file")"
    echo "Edges: $(tail -n +2 "$file" | head -3 | tr '\n' ' ')"
    binary=$(file_to_binary_string "$file")
    echo "Binary: ${binary:0:30}...${binary:34:30}"
    echo "Length: ${#binary}"
    echo ""
done
