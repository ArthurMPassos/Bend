#!/bin/bash

# Define programs and their corresponding Bend files
programs=(
  "bitonic_sort_random.bend"
  "bitonic_sort_skewed.bend"
  "bitonic_sort_small_uniform.bend"
  "quick_sort_random.bend"
  "quick_sort_skewed.bend"
  "quick_sort_small_uniform.bend"
)

# Create a directory to store results
mkdir -p benchmark_results

# Loop through each program
for program in "${programs[@]}"; do
  program_name=$(basename "$program" .bend)
  results_dir="benchmark_results/$program_name"
  mkdir -p "$results_dir"

  # Run the program 10 times
  for i in {1..10}; do
    echo "Running $program_name iteration $i..."

    # Start the Bend program in the background
    bend run-c "../programs/$program" &
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
    pidstat -u -p $HVM_PID 1 > "$results_dir/hvm_cpu_usage_$i.log" &
    # Monitor memory usage
    pidstat -r -p $HVM_PID 1 > "$results_dir/hvm_memory_usage_$i.log" &
    # Monitor I/O statistics
    pidstat -d -p $HVM_PID 1 > "$results_dir/hvm_io_stats_$i.log" &
    # Monitor context switches
    pidstat -w -p $HVM_PID 1 > "$results_dir/hvm_context_switches_$i.log" &
    # Monitor thread count
    # pidstat -t -p $HVM_PID 1 > "$results_dir/hvm_thread_count_$i.log" &

    # Wait for the Bend program to finish
    wait $BEND_PID

    # Kill the pidstat processes
    pkill -f "pidstat -u -p $HVM_PID"
    pkill -f "pidstat -r -p $HVM_PID"
    pkill -f "pidstat -d -p $HVM_PID"
    pkill -f "pidstat -w -p $HVM_PID"
    # pkill -f "pidstat -t -p $HVM_PID"

    echo "CPU usage of hvm for $program_name iteration $i has been logged to $results_dir"
  done
done
