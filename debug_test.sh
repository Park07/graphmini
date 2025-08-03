#!/bin/bash

echo "--- C++ Bug Finder ---"

# --- CONFIGURATION ---
# We will debug the first smoke test case that failed.
DATASET="wiki"
PATTERN_CATEGORY="smoke_test_patterns"
QUERY_FILE_NAME="query_v5_id0.graph"

# --- SETUP ---
PROJECT_ROOT="/Users/williampark/graphmini"
cd "$PROJECT_ROOT" || exit 1

QUERY_FILE_PATH="${PROJECT_ROOT}/queries/${DATASET}/${PATTERN_CATEGORY}/${QUERY_FILE_NAME}"
DATASET_RUNNER_PATH="${PROJECT_ROOT}/dataset/graphmini/${DATASET}"

if [ ! -f "$QUERY_FILE_PATH" ]; then
    echo "Error: Query file not found. Please run the smoke test script once to generate it."
    exit 1
fi

echo "Test case to debug:"
echo "  - Dataset: $DATASET"
echo "  - Query: $QUERY_FILE_PATH"
echo ""

# --- RECOMPILE WITH DEBUG SYMBOLS ---
echo "1. Recompiling with debug symbols..."
cd "${PROJECT_ROOT}/build" || exit 1
# This next line might ask for your password if it needs to clean up old files
make clean > /dev/null 2>&1
cmake -DCMAKE_BUILD_TYPE=Debug .. > /dev/null 2>&1
make runner > /dev/null 2>&1
echo "   ...Done."
echo ""

# --- PRINT THE DEBUG COMMAND ---
echo "2. To find the bug, run the following command:"
echo "----------------------------------------------------"
echo "lldb ./bin/runner 1 \"$DATASET_RUNNER_PATH\""
echo "----------------------------------------------------"