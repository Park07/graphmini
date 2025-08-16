#!/bin/bash

cd ~/graphmini/build

echo "Testing GraphMini two-step process..."

# Step 1: Generate code (using 4-clique which should work)
echo "Step 1: Generating code for 4-clique pattern..."
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ test "0111101111011110" 0 0 0

# Check if code was generated
if [ -f /home/williamp/graphmini/src/codegen_output/plan.cpp ]; then
    echo "✅ Code generated successfully"
else
    echo "❌ Code generation failed"
    exit 1
fi

# Step 2: Run with correct path (directory, not file)
echo -e "\nStep 2: Running with runner..."
timeout 10 ./bin/runner 1 /home/williamp/thesis_data/snap_format/dblp/ 2>&1 | head -20

echo -e "\nNow testing with your sparse pattern (expected to fail)..."
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ sparse "0010001111000100" 0 0 0 2>&1 | grep -E "Exception|ERROR"
