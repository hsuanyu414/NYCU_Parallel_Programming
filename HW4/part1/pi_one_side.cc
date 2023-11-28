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

    MPI_Win win;

    // TODO: MPI init
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int64_t tosses_per_process = tosses / world_size;
    int64_t local_number_in_circle = 0;
    int64_t *recv_number_in_circle;
    if (world_rank == 0)
    {
        int64_t toss_remaining = tosses - tosses_per_process * (world_size-1);
        local_number_in_circle = MonteCarlo(toss_remaining, world_rank);
    }
    else
    {
        local_number_in_circle = MonteCarlo(tosses_per_process, world_rank);
    }

    if (world_rank == 0)
    {
        // Master
        MPI_Alloc_mem(sizeof(int64_t), MPI_INFO_NULL, &recv_number_in_circle);
        *recv_number_in_circle = 0;
        MPI_Win_create(recv_number_in_circle, 
            sizeof(int64_t), sizeof(int64_t), MPI_INFO_NULL, MPI_COMM_WORLD, &win);
    }   
    else
    {
        // Workers
        MPI_Win_create(NULL, 0, 1, MPI_INFO_NULL, MPI_COMM_WORLD, &win);
    }

    MPI_Win_lock(MPI_LOCK_EXCLUSIVE, 0, 0, win);
    MPI_Accumulate(&local_number_in_circle, 1, MPI_INT64_T, 0, 0, 1, MPI_INT64_T, MPI_SUM, win);
    MPI_Win_unlock(0, win);

    MPI_Win_fence(0, win);
    MPI_Win_free(&win);

    if (world_rank == 0)
    {
        // TODO: handle PI result    
        pi_result = ((double)*recv_number_in_circle / (double)tosses) * 4.0;
        
        // --- DON'T TOUCH ---
        double end_time = MPI_Wtime();
        printf("%lf\n", pi_result);
        printf("MPI running time: %lf Seconds\n", end_time - start_time);
        // ---
        MPI_Free_mem(recv_number_in_circle);
    }
    
    MPI_Finalize();
    return 0;
}