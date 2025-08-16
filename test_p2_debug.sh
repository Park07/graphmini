#!/bin/bash

cd /home/williamp/graphmini/build

echo "Testing P2 in different ways:"

echo -e "\n1. Direct run (no timeout, no redirection):"
./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ P2 "0110010111110110110001100" 0 0 0
echo "Exit code: $?"

echo -e "\n2. With timeout but no redirection:"
timeout 10 ./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ P2 "0110010111110110110001100" 0 0 0
echo "Exit code: $?"

echo -e "\n3. With timeout and redirection (like in script):"
timeout 10 ./bin/run dblp /home/williamp/thesis_data/snap_format/dblp/ P2 "0110010111110110110001100" 0 0 0 > /tmp/run.log 2>&1
exit_code=$?
echo "Exit code: $exit_code"
if [ $exit_code -eq 136 ]; then
    echo "This is being detected as FP_EXCEPTION!"
fi

echo -e "\n4. Check what's in the log:"
tail -20 /tmp/run.log
