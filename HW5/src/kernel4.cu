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

    // float z_re = c_re, z_im = c_im;
    float2 z_re_im = make_float2(c_re, c_im);
    float2 z_re_im_sq;

    int i;

    for(i = 0; i < maxIterations; i+=1){
        z_re_im_sq.x = z_re_im.x * z_re_im.x;
        z_re_im_sq.y = z_re_im.y * z_re_im.y;
        if(z_re_im_sq.x + z_re_im_sq.y > 4.f){
            break;
        }

        z_re_im.y = 2.f * z_re_im.x * z_re_im.y + c_im;
        z_re_im.x = z_re_im_sq.x - z_re_im_sq.y + c_re;
    }

    imgDevice[thisY * resX + thisX] = i;

}

// Host front-end function that allocates the memory and launches the GPU kernel
void hostFE (float upperX, float upperY, float lowerX, float lowerY, int* img, int resX, int resY, int maxIterations)
{
    float stepX = (upperX - lowerX) / resX;
    float stepY = (upperY - lowerY) / resY;

    int size = resX * resY * sizeof(int);

    // allocate the memory on the host and mapping it to the device
    cudaHostRegister(img, size, cudaHostRegisterMapped);
    int *imgDevice;
    cudaHostGetDevicePointer(&imgDevice, img, 0);

    // assign the number of blocks and threads
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(resX / dimBlock.x, resY / dimBlock.y);
    mandelKernel<<<dimGrid, dimBlock>>>(lowerX, lowerY, stepX, stepY, resX, maxIterations, imgDevice);

    // guarantee that the kernel is finished before the host tries to access its results
    cudaDeviceSynchronize();
    
    // unregister the memory
    cudaHostUnregister(img);

}
