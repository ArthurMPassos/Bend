#!/bin/bash

# Start the bitonic sort program in the background
bend run-c ../programs/bitonic_sort.bend &
# Get the PID of the Bend program
BEND_PID=$!

# Function to wait for the hvm process to start
wait_for_hvm() {
  while : ; do
    HVM_PID=$(pgrep hvm)
    if [ -n "$HVM_PID" ]; then
      echo "hvm process started with PID: $HVM_PID"
      break
    fi
    sleep 1
  done
}

# Wait for the hvm process to start
wait_for_hvm

# Use perf to monitor the hvm process
sudo ~/perf-build/WSL2-Linux-Kernel/tools/perf/perf stat -p $HVM_PID -o hvm_perf_stats.txt &

# Wait for the Bend program to finish
wait $BEND_PID

# Kill the perf process
pkill perf

echo "CPU usage of hvm has been logged to hvm_perf_stats.txt"
