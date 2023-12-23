#include <stdio.h>
#include <stdlib.h>
#include "hostFE.h"
#include "helper.h"

void hostFE(int filterWidth, float *filter, int imageHeight, int imageWidth,
            float *inputImage, float *outputImage, cl_device_id *device,
            cl_context *context, cl_program *program)
{
    
    cl_int status;
    int filterSize = filterWidth * filterWidth;
    int imageSize = imageHeight * imageWidth;
    
    // Create command queue
    cl_command_queue commandQueue = clCreateCommandQueue(*context, *device, 0, &status);
    
    // Create memory buffers on the device for input, output, and filter
    cl_mem inputImageBuffer = clCreateBuffer(*context, CL_MEM_USE_HOST_PTR,
                                             imageSize * sizeof(float), inputImage, &status);
    cl_mem outputImageBuffer = clCreateBuffer(*context, CL_MEM_WRITE_ONLY,
                                              imageSize * sizeof(float), NULL, &status);
    cl_mem filterBuffer = clCreateBuffer(*context, CL_MEM_USE_HOST_PTR,
                                            filterSize * sizeof(float), filter, &status);

    // create kernel
    cl_kernel kernel = clCreateKernel(*program, "convolution", &status);

    // set kernel arguments
    clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&inputImageBuffer);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&outputImageBuffer);
    clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&filterBuffer);
    clSetKernelArg(kernel, 3, sizeof(cl_int), (void *)&imageWidth);
    clSetKernelArg(kernel, 4, sizeof(cl_int), (void *)&imageHeight);
    clSetKernelArg(kernel, 5, sizeof(cl_int), (void *)&filterWidth);
    int filterHalfWidth = filterWidth >> 1;
    clSetKernelArg(kernel, 6, sizeof(cl_int), (void *)&filterHalfWidth);

    size_t globalWorkSize = imageSize;
    size_t localWorkSize = 32;

    clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, &globalWorkSize,
                           &localWorkSize, 0, NULL, NULL);

    clEnqueueReadBuffer(commandQueue, outputImageBuffer, CL_TRUE, 0,
                        imageSize * sizeof(float), outputImage, 0, NULL, NULL);
    
}