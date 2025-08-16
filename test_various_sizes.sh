#!/bin/bash
cd ~/graphmini/build

echo "Testing queries of different sizes..."

for dataset in dblp; do
    for category in small_dense_8v medium_dense large_dense; do
        query_dir="/home/williamp/thesis_data/query_sets/$dataset/$category"
        if [ ! -d "$query_dir" ]; then
            echo "  $category: NOT FOUND"
            continue
        fi
        
        # Get first query file
        query_file=$(ls $query_dir/*.graph 2>/dev/null | head -1)
        if [ -z "$query_file" ]; then
            echo "  $category: NO QUERIES"
            continue
        fi
        
        # Get info
        header=$(head -n 1 "$query_file")
        vertices=$(echo "$header" | awk '{print $2}')
        edges=$(echo "$header" | awk '{print $3}')
        
        echo "  $category ($vertices vertices, $edges edges): Testing..."
        
        # For larger patterns, we can't easily generate the binary string
        # Just report the pattern size
        echo "    Pattern from: $(basename $query_file)"
    done
done

# Test with author's known working patterns
echo ""
echo "Testing author's patterns that should work:"
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ P1 "0111101111011110" 0 0 0 2>&1 | grep -E "PATTERN_SIZE|ERROR" | head -1
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ P2 "0110010111110110110001100" 0 0 0 2>&1 | grep -E "PATTERN_SIZE|ERROR" | head -1
