import multiprocessing
import math

def compare_and_swap(arr, i, j, dir):
    if dir == (arr[i] > arr[j]):
        arr[i], arr[j] = arr[j], arr[i]

def bitonic_merge(arr, low, cnt, dir):
    if cnt > 1:
        k = cnt // 2
        for i in range(low, low + k):
            compare_and_swap(arr, i, i + k, dir)
        bitonic_merge(arr, low, k, dir)
        bitonic_merge(arr, low + k, k, dir)

def bitonic_sort(arr, low, cnt, dir):
    if cnt > 1:
        k = cnt // 2
        bitonic_sort(arr, low, k, 1)  # Sort in ascending order
        bitonic_sort(arr, low + k, k, 0)  # Sort in descending order
        bitonic_merge(arr, low, cnt, dir)

def parallel_bitonic_sort(arr, n, num_processes):
    size = len(arr)
    pool = multiprocessing.Pool(processes=num_processes)
    
    chunk_size = math.ceil(size / num_processes)
    chunks = [(arr, i * chunk_size, min(chunk_size, size - i * chunk_size), 1) for i in range(num_processes)]
    
    for chunk in chunks:
        pool.apply_async(bitonic_sort, args=chunk)
    
    pool.close()
    pool.join()
    
    step = chunk_size
    while step < size:
        for i in range(0, size, 2 * step):
            bitonic_merge(arr, i, 2 * step, 1)
        step *= 2

if __name__ == '__main__':
    arr = <<REPLACE_ARRAY>>
    n = len(arr)
    num_processes = 4  # Number of parallel processes
    
    parallel_bitonic_sort(arr, n, num_processes)
    print("Sorted array is:", arr)
