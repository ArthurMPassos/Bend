import numpy as np

path = "../datasets/"

def generate_uniform_dataset(size, low, high):
    """
    Generate a uniformly distributed dataset.

    Parameters:
    size (int): Number of elements in the dataset.
    low (int): Lower bound of the uniform distribution.
    high (int): Upper bound of the uniform distribution.

    Returns:
    np.ndarray: Uniformly distributed dataset.
    """
    return np.random.uniform(low, high, size).astype(int)

def generate_random_dataset(size, low, high):
    """
    Generate a randomly distributed dataset.

    Parameters:
    size (int): Number of elements in the dataset.
    low (int): Lower bound of the random distribution.
    high (int): Upper bound of the random distribution.

    Returns:
    np.ndarray: Randomly distributed dataset.
    """
    return np.random.randint(low, high, size)

def generate_skewed_dataset(size, low1, high1, low2, high2, skew_ratio=0.8):
    """
    Generate a skewed dataset with the specified ratio.

    Parameters:
    size (int): Number of elements in the dataset.
    low1 (int): Lower bound for the majority of the distribution.
    high1 (int): Upper bound for the majority of the distribution.
    low2 (int): Lower bound for the minority of the distribution.
    high2 (int): Upper bound for the minority of the distribution.
    skew_ratio (float): Ratio of the majority elements to the total size.

    Returns:
    np.ndarray: Skewed dataset.
    """
    size_majority = int(size * skew_ratio)
    size_minority = size - size_majority

    majority_part = np.random.randint(low1, high1, size_majority)
    minority_part = np.random.randint(low2, high2, size_minority)

    return np.concatenate([majority_part, minority_part])

def save_dataset(filename, dataset):
    """
    Save dataset to a file in the format [1, 2, 3, 4].

    Parameters:
    dataset (np.ndarray): Dataset to save.
    filename (str): File name to save the dataset.
    """
    with open(filename, 'w') as f:
        f.write(str(len(dataset)) +'\n' + '\n'.join(map(str, dataset)))

if __name__ == "__main__":
    # # Small uniform dataset
    # small_uniform_dataset = generate_uniform_dataset(2**15, 0, 2**15) # 32768
    # save_dataset(path + "list_small_uniform_dataset.txt", small_uniform_dataset)

    # Large random dataset
    large_random_dataset = generate_random_dataset(2**16, 0, 2**19) # 524288
    save_dataset(path + "lines_random.txt", large_random_dataset)

    # Large skewed dataset
    large_skewed_dataset = generate_skewed_dataset(2**16, 0, 1000, 1001, 1000000)
    save_dataset(path + "lines_skewed.txt", large_skewed_dataset)

    # Generate and save sorted datasets
    sorted_dataset = np.sort(large_random_dataset)
    save_dataset(path + "lines_sorted.txt", sorted_dataset)

    # Generate and save reverse sorted datasets
    reverse_sorted_dataset = sorted_dataset[::-1]
    save_dataset(path + "lines_reverse.txt", reverse_sorted_dataset)

    print("Datasets generated and saved to files.")
