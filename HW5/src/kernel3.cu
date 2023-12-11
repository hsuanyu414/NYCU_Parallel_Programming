#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 16
#define GROUP_SIZE 4

__global__ void mandelKernel(float lowerX, float lowerY, float stepX, float stepY, int resX, int maxIterations, int* imgDevice, size_t pitch){
    // To avoid error caused by the floating number, use the following pseudo code
    //
    // float x = lowerX + thisX * stepX;
    // float y = lowerY + thisY * stepY;

    int thisX = blockIdx.x * blockDim.x + threadIdx.x;
    thisX *= GROUP_SIZE;
    int thisY = blockIdx.y * blockDim.y + threadIdx.y;

    // float c_re = lowerX + thisX * stepX;
    float c_im = lowerY + thisY * stepY;
    for ( int offset = 0 ; offset < GROUP_SIZE ; offset+=1){
        int thisXoffset = thisX + offset;
        float c_re = lowerX + thisXoffset * stepX;
        float z_re = c_re, z_im = c_im;

        int i;
        for (i = 0; i < maxIterations; i += 1) {
            if (z_re * z_re + z_im * z_im > 4.f){
                break;
            }
                
            float new_re = z_re * z_re - z_im * z_im;
            float new_im = 2.f * z_re * z_im;
            z_re = c_re + new_re;
            z_im = c_im + new_im;
        }
        *((int *)((char *)imgDevice + thisY * pitch) + thisXoffset) = i;
    }



}

// Host front-end function that allocates the memory and launches the GPU kernel
void hostFE (float upperX, float upperY, float lowerX, float lowerY, int* img, int resX, int resY, int maxIterations)
{
    float stepX = (upperX - lowerX) / resX;
    float stepY = (upperY - lowerY) / resY;

    int size = resX * resY * sizeof(int);

    // Use cudaHostAlloc to allocate the host memory
    int *imgHost;
    cudaHostAlloc(&imgHost, size, cudaHostAllocDefault);

    // and use cudaMallocPitch to allocate GPU memory
    int *imgDevice;
    size_t pitch;
    cudaMallocPitch(&imgDevice, &pitch, resX * sizeof(int), resY);

    // assign the number of blocks and threads
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(resX / (dimBlock.x*GROUP_SIZE), resY / dimBlock.y);
    mandelKernel<<<dimGrid, dimBlock>>>(lowerX, lowerY, stepX, stepY, resX, maxIterations, imgDevice, pitch);

    // copy the result back to the host
    cudaMemcpy2D(imgHost, resX * sizeof(int), imgDevice, pitch, resX * sizeof(int), resY, cudaMemcpyDeviceToHost);
    memcpy(img, imgHost, size);
    cudaFreeHost(imgHost);
    cudaFree(imgDevice);

}
