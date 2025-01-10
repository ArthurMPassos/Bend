import pandas as pd
import numpy as np
import glob

def process_csv_files(file_paths):
    for file_path in file_paths:
        # Read the CSV file into a DataFrame
        df = pd.read_csv(file_path)
        
        # Calculate mean, median, and standard deviation for each column with 3 floating-point precision
        stats = df.describe().loc[['mean', '50%', 'std']].rename(index={'50%': 'median'}).map(lambda x: round(x, 3))

        # Print or save the statistics
        print(f'Statistics for {file_path}:')
        print(stats)
        print('\n')

# List of CSV file paths
# csv_files = [
#     'file1.csv',
#     'file2.csv',
#     'file3.csv'
#     # Add more file paths as needed
# ]
csv_files = glob.glob('*.csv')  # Adjust the path as needed

# Process the CSV files
process_csv_files(csv_files)
