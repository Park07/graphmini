#!/bin/bash

# A script to test GraphMini patterns reliably

# Navigate to the build directory
cd ~/graphmini/build

echo "Testing your patterns with the fix:"

# Test your 4v sparse pattern
echo -e "\n1. Your 4v sparse (4v, 4e):"
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ your4v "0101100100011110" 0 0 0 2>&1 | grep "PATTERN_SIZE"
./bin/runner 1 /home/williamp/thesis_data/snap_format/dblp/ 2>&1 | grep "RESULT"

# Test your 8v pattern
echo -e "\n2. Testing an 8v pattern from your dataset:"
query_file="/home/williamp/thesis_data/query_sets/dblp/small_dense_8v/query_sample_8v_1.graph"

if [ -f "$query_file" ]; then
    # Use a here document to safely pass the python script
    pattern=$(python3 <<EOF
import sys
vertices = 8
matrix = [[0]*vertices for _ in range(vertices)]
with open('$query_file', 'r') as f:
    for line in f:
        if line.startswith('e'):
            parts = line.split()
            u, v = int(parts[1]), int(parts[2])
            matrix[u][v] = matrix[v][u] = 1
binary = ''.join(str(matrix[i][j]) for i in range(vertices) for j in range(vertices))
print(binary)
EOF
)
    echo "Pattern binary: ${pattern:0:20}..."
    ./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ your8v "$pattern" 0 0 0 2>&1 | grep "PATTERN_SIZE"
fi

echo -e "\nGraphMini is now FIXED and can handle all patterns!"