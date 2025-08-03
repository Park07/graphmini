#!/bin/bash

# This script correctly prepares any given dataset by copying it from the TXT
# directory and then processing it into the binary format.

# Check if a dataset name was provided
if [ -z "$1" ]; then
    echo "Usage: ./prep_macos.sh <dataset_name>"
    echo "Example: ./prep_macos.sh dblp"
    exit 1
fi

DATASET_NAME=$1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TXT_DIR=${SCRIPT_DIR}/TXT
TARGET_DIR=${SCRIPT_DIR}/graphmini
PREP_BINARY=${SCRIPT_DIR}/../build/bin/prep

# 1. Check if prep binary exists
if [ ! -f "$PREP_BINARY" ]; then
    echo "Error: prep binary not found at $PREP_BINARY"
    echo "Please compile the project first."
    exit 1
fi

# 2. Check if the source dataset directory exists in TXT
if [ -d "${TXT_DIR}/${DATASET_NAME}" ]; then
    echo "--- Preparing dataset: ${DATASET_NAME} ---"

    # 3. Create the target directory and copy the snap.txt file
    mkdir -p "${TARGET_DIR}/${DATASET_NAME}"
    echo "Copying snap.txt..."
    cp "${TXT_DIR}/${DATASET_NAME}/snap.txt" "${TARGET_DIR}/${DATASET_NAME}/"

    # 4. Run the preprocessing binary on the copied data
    echo "Running preprocessing command..."
    "$PREP_BINARY" "${TARGET_DIR}/${DATASET_NAME}"

    echo "Successfully pre-processed '${DATASET_NAME}'."
    echo ""
else
    echo "Warning: Source dataset '${DATASET_NAME}' not found in '${TXT_DIR}'. Skipping."
fi