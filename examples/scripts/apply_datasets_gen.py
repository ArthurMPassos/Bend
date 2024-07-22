import os
import shutil

# Define the directories and paths
datasets_dir = '../datasets'
programs_original_dir = '../programs-original'
programs_gen_dir = '../programs-gen'
bitonic_sort_bend = 'bitonic_sort.bend'
omp_bitonic_sort_c = 'omp_bitonic_sort.c'

# Create the generated programs directory if it doesn't exist
os.makedirs(programs_gen_dir, exist_ok=True)

def process_files(file_keyword, original_program, replace_tag=None, replace_dict=None):
    for filename in os.listdir(datasets_dir):
        if file_keyword in filename:
            dataset_path = os.path.join(datasets_dir, filename)
            
            # Extract the postfix from the filename, ignoring the extension
            postfix = os.path.splitext(filename)[0].split('_')[1]
            
            # Define the new file name and path
            new_program_name = f"{original_program.split('.')[0]}_{postfix}.{original_program.split('.')[1]}"
            new_program_path = os.path.join(programs_gen_dir, new_program_name)
            
            # Copy the original program to the new file
            shutil.copy(os.path.join(programs_original_dir, original_program), new_program_path)
            
            # Read the content from the dataset file
            with open(dataset_path, 'r') as dataset_file:
                dataset_content = dataset_file.read()
                
            # Read the new program file
            with open(new_program_path, 'r') as new_program_file:
                new_program_content = new_program_file.read()

            # Replace the specified characters, if applicable
            if replace_dict:
                for old_char, new_char in replace_dict.items():
                    dataset_content = dataset_content.replace(old_char, new_char)
                
            # Replace the tag with the dataset content, if applicable
            if replace_tag:
                new_program_content = new_program_content.replace(replace_tag, dataset_content)
                
            
            # Write the modified content back to the new program file
            with open(new_program_path, 'w') as new_program_file:
                new_program_file.write(new_program_content)

if __name__ == "__main__":
    # Process files containing "tree" for bitonic_sort.bend
    process_files(file_keyword='tree', original_program=bitonic_sort_bend, replace_tag='<<REPLACE_ARRAY>>')
    
    # Process files containing "list" for omp_bitonic_sort.c
    process_files(file_keyword='list', original_program=omp_bitonic_sort_c, replace_tag='<<REPLACE_ARRAY>>', replace_dict={'[': '{', ']': '}'})
