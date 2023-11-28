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

    // TODO: binary tree redunction
    // calculate local_number_in_circle first
    local_number_in_circle = MonteCarlo(tosses_per_process, world_rank);
    
    // 0 1 2 3 4 5 6 7 >>
    //  0   2   4   6  >> 0 2 4 6 wait 1 3 5 7 (k wait k+1)
    //    0       4    >>     0 4 wait 2 6     (k wait k+2)
    //        0        >>       0 wait 4       (k wait k+4)...

    // do the reduction
    int64_t recv_number_in_circle;
    for(int i = 1 ; i < world_size ; i*=2){ // i = 1, 2, 4, 8, ...
        if(world_rank % (i*2) == 0){ // if this node is the receiver at this round
            MPI_Recv(&recv_number_in_circle, 1, MPI_INT64_T, world_rank + i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            local_number_in_circle += recv_number_in_circle;
        }
        else if(world_rank % i == 0){ // if this node is the sender at this round
            MPI_Send(&local_number_in_circle, 1, MPI_INT64_T, world_rank - i, 0, MPI_COMM_WORLD);
            break;
        }
    }
    

    if (world_rank == 0)
    {
        // TODO: PI result
        pi_result = 4 * (double)local_number_in_circle / tosses;
        // --- DON'T TOUCH ---
        double end_time = MPI_Wtime();
        printf("%lf\n", pi_result);
        printf("MPI running time: %lf Seconds\n", end_time - start_time);
        // ---
    }

    MPI_Finalize();
    return 0;
}
