#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 16

__global__ void mandelKernel(float lowerX, float lowerY, float stepX, float stepY, int resX, int maxIterations, int* imgDevice){
    // To avoid error caused by the floating number, use the following pseudo code
    //
    // float x = lowerX + thisX * stepX;
    // float y = lowerY + thisY * stepY;

    int thisX = blockIdx.x * blockDim.x + threadIdx.x;
    int thisY = blockIdx.y * blockDim.y + threadIdx.y;

    float c_re = lowerX + thisX * stepX;
    float c_im = lowerY + thisY * stepY;

    float z_re = c_re, z_im = c_im;

    int i;

    for(i = 0; i < maxIterations; i+=1){
        if(z_re * z_re + z_im * z_im > 4.f){
            break;
        }

        float new_re = z_re * z_re - z_im * z_im;
        float new_im = 2.f * z_re * z_im;
        z_re = c_re + new_re;
        z_im = c_im + new_im;
    }

    imgDevice[thisY * resX + thisX] = i;

}

// Host front-end function that allocates the memory and launches the GPU kernel
void hostFE (float upperX, float upperY, float lowerX, float lowerY, int* img, int resX, int resY, int maxIterations)
{
    float stepX = (upperX - lowerX) / resX;
    float stepY = (upperY - lowerY) / resY;

    int size = resX * resY * sizeof(int);

    // Use malloc to allocate the host memory
    int *imgHost = (int*)malloc(size);

    // and use cudaMalloc to allocate GPU memory
    int *imgDevice;
    cudaMalloc(&imgDevice, size);

    // assign the number of blocks and threads
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(resX / dimBlock.x, resY / dimBlock.y);
    mandelKernel<<<dimGrid, dimBlock>>>(lowerX, lowerY, stepX, stepY, resX, maxIterations, imgDevice);

    // copy the result back to the host
    cudaMemcpy(imgHost, imgDevice, size, cudaMemcpyDeviceToHost);
    cudaFree(imgDevice);
    memcpy(img, imgHost, size);
    free(imgHost);

}
