import os
import re
import statistics

# Define paths
result_dirs = {
    'bend': 'benchmark_results/bend',
    'openmp': 'benchmark_results/openmp',
    'python': 'benchmark_results/python'
}

# Define the metrics to extract
metrics_to_extract = [
    "User time (seconds)",
    "System time (seconds)",
    "Percent of CPU this job got",
    "Elapsed (wall clock) time",
    "Maximum resident set size (kbytes)",
    "Major (requiring I/O) page faults",
    "Minor (reclaiming a frame) page faults",
    "Voluntary context switches",
    "Involuntary context switches"
]

def parse_time(time_str):
    """Parses elapsed time from 'h:mm:ss' or 'm:ss' format to seconds."""
    parts = time_str.split(':')
    if len(parts) == 3:
        return int(parts[0]) * 3600 + int(parts[1]) * 60 + float(parts[2])
    elif len(parts) == 2:
        return int(parts[0]) * 60 + float(parts[1])
    return float(time_str)

def extract_metrics(file_path):
    """Extracts relevant metrics from a given file."""
    metrics = {}
    with open(file_path, 'r') as file:
        for line in file:
            for metric in metrics_to_extract:
                if metric in line:
                    value = line.split(':')[-1].strip()
                    if metric == "Elapsed (wall clock) time":
                        value = parse_time(value)
                    else:
                        if value[-1] == '%':
                            value = value[:-1]
                        value = float(value)
                    metrics[metric] = value
    return metrics

def aggregate_metrics(program_dir):
    """Aggregates metrics for all iterations of a program, discarding best and worst elapsed times."""
    all_metrics = []
    for root, _, files in os.walk(program_dir):
        for file in files:
            if file.endswith('.txt'):
                metrics = extract_metrics(os.path.join(root, file))
                all_metrics.append(metrics)
    
    # Sort by elapsed time to find the best and worst
    all_metrics.sort(key=lambda x: x["Elapsed (wall clock) time"])
    
    # Remove best and worst
    all_metrics = all_metrics[1:-1]
    
    aggregated_metrics = {metric: [] for metric in metrics_to_extract}
    
    for metrics in all_metrics:
        for metric in metrics_to_extract:
            aggregated_metrics[metric].append(metrics[metric])
    
    final_metrics = {metric: statistics.mean(values) for metric, values in aggregated_metrics.items()}
    
    return final_metrics

def main():
    final_results = {}
    
    for prog_type, prog_dir in result_dirs.items():
        final_results[prog_type] = {}
        for program_name in os.listdir(prog_dir):
            program_path = os.path.join(prog_dir, program_name)
            if os.path.isdir(program_path):
                aggregated = aggregate_metrics(program_path)
                final_results[prog_type][program_name] = aggregated
    
    for prog_type, programs in final_results.items():
        print(f"\nProgram Type: {prog_type}")
        for program_name, metrics in programs.items():
            print(f"\nProgram: {program_name}")
            for metric, value in metrics.items():
                print(f"{metric}: {value:.2f}")

if __name__ == "__main__":
    main()
