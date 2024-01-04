__kernel void convolution(
    __global float *input, 
    __global float *output, 
    __constant float *filter, 
    int image_width, 
    int image_height, 
    int filter_size
    )
{
    int index = get_global_id(0);
    
    int filter_half = filter_size >> 1;
    
    int2 coord = (int2)(index % image_width, index / image_width);
    int2 filter_half_2 = (int2)(filter_half, filter_half);
    
    float sum = 0.0f;
    
    for (int i = 0 ; i < filter_size ; i+=1)
    {
        for (int j = 0 ; j < filter_size ; j+=1)
        {
            float filter_value = filter[i * filter_size + j];
            if (filter_value == 0.0f)
                continue;

            int2 x_y_index;
            x_y_index = coord + (int2)(j, i) - filter_half_2;
            
            if (  x_y_index.y < 0 || x_y_index.y >= image_height ||
                  x_y_index.x < 0 || x_y_index.x >= image_width)
                continue;

            sum += input[x_y_index.y * image_width + x_y_index.x] * filter_value;
        }
    }
    output[index] = sum;
}
