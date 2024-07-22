import json
import glob
import os


def pair_binary_tree(lst):
    if len(lst) == 1:
        return lst[0]
    elif len(lst) == 2:
        return (lst[0], lst[1])
    mid = len(lst) // 2
    left = pair_binary_tree(lst[:mid])
    right = pair_binary_tree(lst[mid:])
    return (left, right)

def read_input_file(file_path):
    with open(file_path, 'r') as file:
        data = file.read().strip()
        lst = json.loads(data)
        return lst

def write_output_file(result, file_path):
    with open(file_path, 'w') as file:
        file.write(str(result))

def process_files(input_directory):
    input_files = glob.glob(os.path.join(input_directory, 'list*.txt'))
    for input_file in input_files:
        # Generate the corresponding output file path
        file_number = input_file.split('list')[1].split('.txt')[0]
        output_file = os.path.join(input_directory, f'tree{file_number}.txt')
        
        # Read the input list from the file
        input_list = read_input_file(input_file)
        
        # Process the input list to create the pair binary tree
        result = pair_binary_tree(input_list)
        
        # Write the output to the corresponding output file
        write_output_file(result, output_file)
        
        print(f"Pair binary tree written to {output_file}")

# Main execution
input_directory = "../datasets/"  # Directory containing input files

# Process all input files in the directory
process_files(input_directory)
