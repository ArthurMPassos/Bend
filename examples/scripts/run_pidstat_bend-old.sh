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

# Monitor CPU usage
pidstat -u -p $HVM_PID 1 > hvm_cpu_usage.log &
# Monitor memory usage
pidstat -r -p $HVM_PID 1 > hvm_memory_usage.log &
# Monitor I/O statistics
pidstat -d -p $HVM_PID 1 > hvm_io_stats.log &
# Monitor context switches
pidstat -w -p $HVM_PID 1 > hvm_context_switches.log &
# Monitor thread count
# pidstat -t -p $HVM_PID 1 > hvm_thread_count.log &

# Wait for the Bend program to finish
wait $BEND_PID

# Kill the pidstat processes
pkill -f "pidstat -u -p $HVM_PID"
pkill -f "pidstat -r -p $HVM_PID"
pkill -f "pidstat -d -p $HVM_PID"
pkill -f "pidstat -w -p $HVM_PID"
# pkill -f "pidstat -t -p $HVM_PID"
echo "CPU usage of hvm has been logged to hvm_cpu_usage.log"
