#!/bin/bash

# Define Bend, OpenMP, and Python programs with their corresponding files
bend_programs=(
  "n_body_sim.bend"
)

openmp_programs=(
  "n_body_sim.c"
)

python_programs=(
  "n_body_sim_parallel.py"
)

iterations=$(seq 1 12)

# Create a directory to store all results
mkdir -p benchmark_results

# Function to monitor and log detailed metrics using perf stat
monitor_metrics() {
  local program_cmd=$1
  local results_dir=$2
  local iteration=$3
  local prefix=$4

  # Run the program with perf stat to capture various metrics
  mkdir -p "$results_dir"
  /usr/bin/time -v -o "$results_dir/${prefix}_perf_$iteration.txt" $program_cmd >/dev/null 2>&1
}

# Function to run and monitor a Bend program
run_bend_program() {
  local program=$1
  local results_dir=$2

  for iteration in $iterations; do
    echo "Running $program iteration $iteration..."

    # Monitor the Bend program
    monitor_metrics "bend run-c ../programs-original/$program" $results_dir $iteration "bend"

    echo "Metrics for $program iteration $iteration logged to $results_dir"
  done
}

# Function to run and monitor an OpenMP program
run_openmp_program() {
  local program=$1
  local results_dir=$2

  for iteration in $iterations; do
    echo "Running ${program%.c} iteration $iteration..."

    # Monitor the OpenMP program
    monitor_metrics "../programs-original/${program%.c}" $results_dir $iteration "openmp"

    echo "Metrics for ${program%.c} iteration $iteration logged to $results_dir"
  done
}

# Function to run and monitor a Python program
run_python_program() {
  local program=$1
  local results_dir=$2

  for iteration in $iterations; do
    echo "Running $program iteration $iteration..."

    # Monitor the Python program
    monitor_metrics "python3 ../programs-original/$program" $results_dir $iteration "python"

    echo "Metrics for $program iteration $iteration logged to $results_dir"
  done
}

# Compile OpenMP programs
compile_openmp_programs() {
  for program in "${openmp_programs[@]}"; do
    gcc -fopenmp "../programs-original/$program" -o "../programs-original/${program%.c}" -lm
    if [ $? -ne 0 ]; then
      echo "Failed to compile $program"
      exit 1
    fi
    # Ensure the compiled binary has execute permissions
    chmod +x "../programs-original/${program%.c}"
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

# Run Python programs
for program in "${python_programs[@]}"; do
  program_name=$(basename "$program" .py)
  results_dir="benchmark_results/python/$program_name"
  mkdir -p "$results_dir"
  run_python_program "$program" "$results_dir"
done
