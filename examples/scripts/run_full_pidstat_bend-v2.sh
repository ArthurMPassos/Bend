#!/bin/bash

# Define Bend and OpenMP programs with their corresponding files
bend_programs=(
  "bitonic_sort_random.bend"
  "bitonic_sort_reverse.bend"
  "bitonic_sort_skewed.bend"
  "bitonic_sort_sorted.bend"
)

openmp_programs=(
  "omp_bitonic_sort_random.c"
  "omp_bitonic_sort_reverse.c"
  "omp_bitonic_sort_skewed.c"
  "omp_bitonic_sort_sorted.c"
)

iterations=`echo {1..10}`

# Create a directory to store all results
mkdir -p benchmark_results

# Function to monitor and log metrics for a given PID
monitor_metrics() {
  local pid=$1
  local results_dir=$2
  local iteration=$3
  local prefix=$4

  # Monitor CPU usage
  pidstat -u -p $pid 1 > "$results_dir/${prefix}_cpu_usage_$iteration.log" &
  # Monitor memory usage
  pidstat -r -p $pid 1 > "$results_dir/${prefix}_memory_usage_$iteration.log" &
  # Monitor I/O statistics
  pidstat -d -p $pid 1 > "$results_dir/${prefix}_io_stats_$iteration.log" &
  # Monitor context switches
  pidstat -w -p $pid 1 > "$results_dir/${prefix}_context_switches_$iteration.log" &
}

# Function to run and monitor a Bend program
run_bend_program() {
  local program=$1
  local results_dir=$2

  for iteration in $iterations; do
    echo "Running $program iteration $iteration..."

    # Start the Bend program in the background
    bend run-c "../programs-gen/$program" >/dev/null 2>&1 &
    local bend_pid=$!

    # Wait for the hvm process to start
    local hvm_pid=""
    while [ -z "$hvm_pid" ]; do
      hvm_pid=$(pgrep -x hvm)
      sleep 1
    done
    echo "hvm process started with PID: $hvm_pid"

    # Monitor the hvm process
    monitor_metrics $hvm_pid $results_dir $iteration "hvm"

    # Wait for the Bend program to finish
    wait $bend_pid

    # Kill all pidstat processes monitoring the hvm PID
    pkill -P $$ pidstat

    echo "Metrics for $program iteration $iteration logged to $results_dir"
  done
}

# Function to run and monitor an OpenMP program
run_openmp_program() {
  local program=$1
  local results_dir=$2

  for iteration in $iterations; do
    echo "Running ${program%.c} iteration $iteration..."

    # Start the OpenMP program in the background
    "../programs-gen/${program%.c}" > $program.txt & #>/dev/null 2>&1 &
    local openmp_pid=$!

    # Monitor the OpenMP process
    monitor_metrics $openmp_pid $results_dir $iteration "openmp"

    # Wait for the OpenMP program to finish
    wait $openmp_pid

    # Kill all pidstat processes monitoring the OpenMP PID
    pkill -P $$ pidstat

    echo "Metrics for ${program%.c} iteration $iteration logged to $results_dir"
  done
}

# Compile OpenMP programs
compile_openmp_programs() {
  for program in "${openmp_programs[@]}"; do
    gcc -fopenmp "../programs-gen/$program" -o "../programs-gen/${program%.c}"
    if [ $? -ne 0 ]; then
      echo "Failed to compile $program"
      exit 1
    fi
    # Ensure the compiled binary has execute permissions
    chmod +x "../programs-gen/${program%.c}"
  done
}

# Compile all OpenMP programs before running
compile_openmp_programs

# Run Bend programs
for program in "${bend_programs[@]}"; do
  program_name=$(basename "$program" .bend)
  results_dir="benchmark_results/bend/$program_name"
  mkdir -p "$results_dir"
  run_bend_program "$program" "$results_dir"
done

# Run OpenMP programs
for program in "${openmp_programs[@]}"; do
  program_name=$(basename "$program" .c)
  results_dir="benchmark_results/openmp/$program_name"
  mkdir -p "$results_dir"
  run_openmp_program "$program" "$results_dir"
done
