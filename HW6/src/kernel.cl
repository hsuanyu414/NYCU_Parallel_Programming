__kernel void convolution(
    __global float *input, 
    __global float *output, 
    __global float *filter, 
    int image_width, 
    int image_height, 
    int filter_size,
    int filter_half
    )
{
    int index = get_global_id(0);
    // index = y * image_width + x
    
    int2 coord = (int2)(index % image_width, index / image_width);
    // coord.y = index / image_width;
    // coord.x = index - coord.y * image_width;
    int2 filter_half_2 = (int2)(filter_half, filter_half);
    
    // int y = index / image_width;
    // int x = index - y * image_width;
    
    float sum = 0.0f;
    
    int start_i = coord.y  >= filter_half ? coord.y - filter_half : 0;
    int end_i = coord.y + filter_half < image_height ? coord.y + filter_half : image_height - 1;
    int start_j = coord.x  >= filter_half ? coord.x - filter_half : 0;
    int end_j = coord.x + filter_half < image_width ? coord.x + filter_half : image_width - 1;
    for(int i = start_i ; i <= end_i ; i++)
    {
        for(int j = start_j ; j <= end_j ; j++)
        {
            sum += input[i * image_width + j] * filter[(i - coord.y + filter_half) * filter_size + (j - coord.x + filter_half)];
        }
    }

    // for(int i = 0 ; i < filter_size*filter_size ; i++)
    // {
    //     // int rem, quo;
    //     int2 rem_quo = (int2)(i % filter_size, i / filter_size);
    //     // rem_quo.y = i / filter_size;
    //     // rem_quo.x = i - rem_quo.y * filter_size;

    //     int2 x_y_index;
    //     x_y_index = coord + rem_quo - filter_half_2;

    //     if ( x_y_index.x < 0 || x_y_index.x >= image_width || x_y_index.y < 0 || x_y_index.y >= image_height)
    //     {
    //         continue;
    //     }
    //     sum += input[x_y_index.y * image_width + x_y_index.x] * filter[i];

    //     // int x_index = coord.x + rem_quo.x - filter_half;
    //     // int y_index = coord.y + rem_quo.y - filter_half;
    //     // if ( x_index < 0 || x_index >= image_width || y_index < 0 || y_index >= image_height)
    //     // {
    //     //     continue;
    //     // }
    //     // sum += input[y_index * image_width + x_index] * filter[i];
    // }
    output[index] = sum;
}
