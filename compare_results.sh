#!/bin/bash

# Script to compare RESULT values between GraphMini original and OpenMP implementation
# Usage: ./compare_results.sh <openmp_dir> <graphmini_dir>
#
# Save this file as compare_results.sh and run: chmod +x compare_results.sh

OPENMP_DIR="$1"
GRAPHMINI_DIR="$2"

if [[ -z "$OPENMP_DIR" || -z "$GRAPHMINI_DIR" ]]; then
    echo "Usage: $0 <openmp_results_dir> <graphmini_results_dir>"
    echo "Example: $0 unified_results_corrected_20250709_210700 unified_results_graphmini_20250709_212303"
    exit 1
fi

if [[ ! -d "$OPENMP_DIR" || ! -d "$GRAPHMINI_DIR" ]]; then
    echo "Error: One or both directories don't exist"
    echo "OpenMP dir: $OPENMP_DIR"
    echo "GraphMini dir: $GRAPHMINI_DIR"
    exit 1
fi

echo "=== RESULT Comparison: OpenMP vs GraphMini ==="
echo "OpenMP implementation: $OPENMP_DIR"
echo "GraphMini original:    $GRAPHMINI_DIR"
echo ""

# Arrays to track results
total_tests=0
matching_tests=0
mismatched_tests=0
missing_tests=0

# Create comparison report
REPORT_FILE="comparison_report_$(date +%Y%m%d_%H%M%S).txt"
echo "=== RESULT Comparison Report ===" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "OpenMP dir: $OPENMP_DIR" >> "$REPORT_FILE"
echo "GraphMini dir: $GRAPHMINI_DIR" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Comparing RESULT values..."
echo ""

# Find all .log files in OpenMP directory
for openmp_file in "$OPENMP_DIR"/*.log; do
    if [[ ! -f "$openmp_file" ]]; then
        continue
    fi

    filename=$(basename "$openmp_file")
    graphmini_file="$GRAPHMINI_DIR/$filename"

    total_tests=$((total_tests + 1))

    # Check if corresponding file exists in GraphMini directory
    if [[ ! -f "$graphmini_file" ]]; then
        echo "❌ MISSING: $filename (no GraphMini result)"
        echo "MISSING: $filename (no GraphMini result)" >> "$REPORT_FILE"
        missing_tests=$((missing_tests + 1))
        continue
    fi

    # Extract RESULT values
    openmp_result=$(grep "RESULT=" "$openmp_file" | grep -o '[0-9]*' | head -1)
    graphmini_result=$(grep "RESULT=" "$graphmini_file" | grep -o '[0-9]*' | head -1)

    # Compare results
    if [[ -z "$openmp_result" || -z "$graphmini_result" ]]; then
        echo "⚠️  ERROR: $filename (missing RESULT in one or both files)"
        echo "   OpenMP: '$openmp_result', GraphMini: '$graphmini_result'"
        echo "ERROR: $filename - OpenMP: '$openmp_result', GraphMini: '$graphmini_result'" >> "$REPORT_FILE"
        missing_tests=$((missing_tests + 1))
    elif [[ "$openmp_result" == "$graphmini_result" ]]; then
        echo "✅ MATCH: $filename (RESULT=$openmp_result)"
        echo "MATCH: $filename - RESULT=$openmp_result" >> "$REPORT_FILE"
        matching_tests=$((matching_tests + 1))
    else
        echo "❌ MISMATCH: $filename"
        echo "   OpenMP:   $openmp_result"
        echo "   GraphMini: $graphmini_result"
        echo "MISMATCH: $filename - OpenMP: $openmp_result, GraphMini: $graphmini_result" >> "$REPORT_FILE"
        mismatched_tests=$((mismatched_tests + 1))
    fi
done

echo ""
echo "=== SUMMARY ==="
echo "Total tests compared: $total_tests"
echo "✅ Matching results:  $matching_tests"
echo "❌ Mismatched results: $mismatched_tests"
echo "⚠️  Missing/Error:     $missing_tests"
echo ""

# Write summary to report
echo "" >> "$REPORT_FILE"
echo "=== SUMMARY ===" >> "$REPORT_FILE"
echo "Total tests compared: $total_tests" >> "$REPORT_FILE"
echo "Matching results: $matching_tests" >> "$REPORT_FILE"
echo "Mismatched results: $mismatched_tests" >> "$REPORT_FILE"
echo "Missing/Error: $missing_tests" >> "$REPORT_FILE"

if [[ $mismatched_tests -eq 0 && $missing_tests -eq 0 ]]; then
    echo "🎉 SUCCESS: All RESULT values match! Your OpenMP implementation is correct!"
    echo "SUCCESS: All RESULT values match!" >> "$REPORT_FILE"
elif [[ $mismatched_tests -eq 0 ]]; then
    echo "⚠️  PARTIAL SUCCESS: No mismatches, but some tests had missing results"
    echo "PARTIAL SUCCESS: No mismatches, but some tests had missing results" >> "$REPORT_FILE"
else
    echo "❌ FAILURE: Found $mismatched_tests mismatched results - check your implementation"
    echo "FAILURE: Found $mismatched_tests mismatched results" >> "$REPORT_FILE"
fi

echo ""
echo "Detailed report saved to: $REPORT_FILE"

# Create a quick summary for easy reading
if [[ $matching_tests -gt 0 ]]; then
    echo ""
    echo "=== Sample Matching Results ==="
    grep "MATCH:" "$REPORT_FILE" | head -5
    if [[ $matching_tests -gt 5 ]]; then
        echo "... and $((matching_tests - 5)) more matches"
    fi
fi

if [[ $mismatched_tests -gt 0 ]]; then
    echo ""
    echo "=== All Mismatched Results ==="
    grep "MISMATCH:" "$REPORT_FILE"
fi