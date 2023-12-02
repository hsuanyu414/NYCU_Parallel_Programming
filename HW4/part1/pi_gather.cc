#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/types.h>
#include <unistd.h>

#pragma GCC optimize ("O3")
#pragma GCC target("tune=native")

int64_t MonteCarlo(int tosses, int rank)
{
    double x, y, distance_squared;
    int64_t local_number_in_circle = 0;
    uint32_t seed1 = rank;
    uint32_t seed2 = time(0) + rank;
    for (int64_t i = 0; i < tosses; i+=1)
    {
        x = ((double)rand_r(&seed1)/RAND_MAX)*2-1;
        y = ((double)rand_r(&seed2)/RAND_MAX)*2-1;
        distance_squared = x * x + y * y;
        if (distance_squared <= 1)
        {
            local_number_in_circle+=1;
        }
    }
    return local_number_in_circle;
}

int main(int argc, char **argv)
{
    // --- DON'T TOUCH ---
    MPI_Init(&argc, &argv);
    double start_time = MPI_Wtime();
    double pi_result;
    long long int tosses = atoi(argv[1]);
    int world_rank, world_size;
    // ---

    // TODO: MPI init
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int64_t tosses_per_process = tosses / world_size;
    int64_t local_number_in_circle;
    int64_t local_number_in_circle_array[world_size] ;

    if (world_rank == 0)
    {
        tosses_per_process += tosses % world_size;
    }// for remaining tosses

    local_number_in_circle = MonteCarlo(tosses_per_process, world_rank);
    // TODO: use MPI_Gather
    MPI_Gather(&local_number_in_circle, 1, MPI_INT64_T, local_number_in_circle_array, 1, MPI_INT64_T, 0, MPI_COMM_WORLD);

    if (world_rank == 0)
    {
        // TODO: PI result
        for(int i = 1 ; i < world_size ; i+=1){ //except master
            local_number_in_circle += local_number_in_circle_array[i];
        }
        pi_result = ((double)4 * local_number_in_circle / tosses);

        // --- DON'T TOUCH ---
        double end_time = MPI_Wtime();
        printf("%lf\n", pi_result);
        printf("MPI running time: %lf Seconds\n", end_time - start_time);
        // ---
    }
    
    MPI_Finalize();
    return 0;
}
