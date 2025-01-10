import os
import re
import csv
from statistics import mean

# Define the directories where metrics are stored
directories = {
    "bend": "benchmark_results/bend",
    "openmp": "benchmark_results/openmp",
    "python": "benchmark_results/python"
}

# Function to extract metrics from a performance log file
def extract_metrics(file_path):
    with open(file_path, 'r') as file:
        data = file.read()
    
    metrics = {}
    metrics["command"] = re.search(r'Command being timed: "(.+)"', data).group(1)
    metrics["user_time"] = float(re.search(r'User time \(seconds\): (\d+\.\d+)', data).group(1))
    metrics["system_time"] = float(re.search(r'System time \(seconds\): (\d+\.\d+)', data).group(1))
    metrics["cpu_percent"] = float(re.search(r'Percent of CPU this job got: (\d+)%', data).group(1))
    elapsed_time = re.search(r'Elapsed \(wall clock\) time \(h:mm:ss or m:ss\): ([\d:\.]+)', data).group(1)
    print("string:", elapsed_time)
    # Convert elapsed time to seconds
    if ':' in elapsed_time:
        parts = elapsed_time.split(':')
        if len(parts) == 2:  # m:ss
            metrics["elapsed_time"] = int(parts[0]) * 60 + float(parts[1])
        elif len(parts) == 3:  # h:mm:ss
            metrics["elapsed_time"] = int(parts[0]) * 3600 + int(parts[1]) * 60 + float(parts[2])
    else:
        metrics["elapsed_time"] = float(elapsed_time)
    
    print("float:", metrics["elapsed_time"])
    
    metrics["max_resident_set_size"] = int(re.search(r'Maximum resident set size \(kbytes\): (\d+)', data).group(1))
    metrics["minor_page_faults"] = int(re.search(r'Minor \(reclaiming a frame\) page faults: (\d+)', data).group(1))
    metrics["involuntary_context_switches"] = int(re.search(r'Involuntary context switches: (\d+)', data).group(1))
    metrics["exit_status"] = int(re.search(r'Exit status: (\d+)', data).group(1))
    
    return metrics

# Function to process metrics for a specific program type and program name
def process_program_metrics(program_type, program_name):
    metrics_list = []
    results_dir = os.path.join(directories[program_type], program_name)
    
    for file_name in os.listdir(results_dir):
        if file_name.endswith(".txt"):
            file_path = os.path.join(results_dir, file_name)
            metrics = extract_metrics(file_path)
            metrics["iteration"] = int(re.search(r'_(\d+)\.txt', file_name).group(1))
            metrics_list.append(metrics)
    
    # Sort by elapsed time to find and discard the best and worst times
    metrics_list.sort(key=lambda x: x["elapsed_time"])
    if len(metrics_list) > 2:
        metrics_list = metrics_list[1:-1]  # Remove the best and worst times
    
    return metrics_list

# Function to write metrics to a CSV file
def write_metrics_to_csv(metrics_list, csv_file):
    fieldnames = [
        "command", "iteration", "user_time", "system_time", "cpu_percent",
        "elapsed_time", "max_resident_set_size", "minor_page_faults",
        "involuntary_context_switches", "exit_status"
    ]
    
    with open(csv_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        for metrics in metrics_list:
            writer.writerow(metrics)

# Process all programs and write results to CSV files
for program_type, dir_path in directories.items():
    for program_name in os.listdir(dir_path):
        metrics_list = process_program_metrics(program_type, program_name)
        csv_file = f"{program_type}_{program_name}_metrics.csv"
        write_metrics_to_csv(metrics_list, csv_file)
        print(f"Metrics for {program_type} {program_name} written to {csv_file}")
