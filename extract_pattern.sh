#!/bin/bash
function file_to_binary_string() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then echo "ERROR_FILE_NOT_FOUND"; return; fi

    local n
    n=$(head -n 1 "$file_path")
    if ! [[ "$n" =~ ^[0-9]+$ ]] || [[ "$n" -eq 0 ]]; then echo "ERROR_INVALID_VERTICES"; return; fi

    # Initialize matrix with zeros
    local matrix=$(printf '0%.0s' $(seq 1 $((n * n))))

    # Use process substitution instead of pipe to avoid subshell
    while IFS=' ' read -r u v; do
        if [[ -n "$u" && -n "$v" ]] && [[ "$u" =~ ^[0-9]+$ ]] && [[ "$v" =~ ^[0-9]+$ ]]; then
            if [[ $u -lt $n && $v -lt $n ]]; then
                local index1=$((u * n + v))
                local index2=$((v * n + u))
                # Fix the string manipulation
                matrix="${matrix:0:$index1}1${matrix:$((index1+1))}"
                matrix="${matrix:0:$index2}1${matrix:$((index2+1))}"
            fi
        fi
    done < <(tail -n +2 "$file_path")

    echo "$matrix"
}

# Call the function with the argument
file_to_binary_string "$1"
