#!/bin/bash

echo "=== GraphMini Side-by-Side Correctness Testing ==="
echo "This will build and compare TBB vs OpenMP implementations"
echo ""

# Check we're in the right place
if [ ! -d "../src" ]; then
    echo "❌ Run this from the side_by_side_tests directory"
    exit 1
fi

# Check both branches exist
cd ..
branches_ok=true

if ! git show-ref --verify --quiet refs/heads/graphmini; then
    echo "❌ graphmini branch not found"
    branches_ok=false
fi

if ! git show-ref --verify --quiet refs/heads/openmp-conversion; then
    echo "❌ openmp-conversion branch not found"
    branches_ok=false
fi

if [ "$branches_ok" = false ]; then
    echo "Missing required branches"
    exit 1
fi

cd side_by_side_tests

echo "✅ Both branches found"
echo "Starting side-by-side correctness testing..."
echo ""

python3 side_by_side_correctness.py
