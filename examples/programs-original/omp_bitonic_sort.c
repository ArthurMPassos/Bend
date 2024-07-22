#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define ASCENDING 1
#define DESCENDING 0

void printArray(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

void bitonicMerge(int *arr, int low, int cnt, int dir) {
    if (cnt > 1) {
        int k = cnt / 2;
        for (int i = low; i < low + k; i++) {
            if (dir == (arr[i] > arr[i + k])) {
                int temp = arr[i];
                arr[i] = arr[i + k];
                arr[i + k] = temp;
            }
        }
        #pragma omp parallel sections
        {
            #pragma omp section
            bitonicMerge(arr, low, k, dir);
            #pragma omp section
            bitonicMerge(arr, low + k, k, dir);
        }
    }
}

void bitonicSort(int *arr, int low, int cnt, int dir) {
    if (cnt > 1) {
        int k = cnt / 2;
        #pragma omp parallel sections
        {
            #pragma omp section
            bitonicSort(arr, low, k, ASCENDING);
            #pragma omp section
            bitonicSort(arr, low + k, k, DESCENDING);
        }
        bitonicMerge(arr, low, cnt, dir);
    }
}

int main() {
    int n = 524288; // Must be a power of 2
    int arr[] = <<REPLACE_ARRAY>>;

    //printf("Original array: \n");
    //printArray(arr, n);

    bitonicSort(arr, 0, n, ASCENDING);

    //printf("Sorted array: \n");
    //printArray(arr, n);

    return 0;
}
