#!/bin/bash
source unified_framework.sh
pattern_binary=$(file_to_binary_string "queries/wiki/small_sparse/query_v8_id0.graph")
echo "Pattern binary: ${pattern_binary:0:50}..."
echo "Length: ${#pattern_binary}"
