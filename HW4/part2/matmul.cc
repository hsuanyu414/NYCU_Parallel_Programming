#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define MASTER 0
#define FROM_MASTER 1
#define FROM_WORKER 2

#define DEBUG 0

// Read size of matrix_a and matrix_b (n, m, l) and whole data of matrixes from stdin
//
// n_ptr:     pointer to n
// m_ptr:     pointer to m
// l_ptr:     pointer to l
// a_mat_ptr: pointer to matrix a (a should be a continuous memory space for placing n * m elements of int)
// b_mat_ptr: pointer to matrix b (b should be a continuous memory space for placing m * l elements of int)
void construct_matrices(int *n_ptr, int *m_ptr, int *l_ptr,
                        int **a_mat_ptr, int **b_mat_ptr)
{
    int rank, size, useless;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank == MASTER){
        setvbuf(stdin, (char*)calloc(1 << 30, sizeof(char)), _IOFBF, 1 << 30);
        scanf("%d %d %d", n_ptr, m_ptr, l_ptr);
        *a_mat_ptr = (int *)malloc((*n_ptr) * (*m_ptr) * sizeof(int));
        *b_mat_ptr = (int *)malloc((*m_ptr) * (*l_ptr) * sizeof(int));
        for (int i = 0; i < (*n_ptr) * (*m_ptr); i+=1)
            scanf("%d", *a_mat_ptr+i);
        // scan b matrix in transpose order
        for (int i = 0; i < (*m_ptr); i+=1)
            for (int j = 0; j < (*l_ptr); j+=1)
                scanf("%d", *b_mat_ptr + j * (*m_ptr) + i);
        fflush(stdin);
    }// singel node io
    return;
}

// Just matrix multiplication (your should output the result in this function)
// 
// n:     row number of matrix a
// m:     col number of matrix a / row number of matrix b
// l:     col number of matrix b
// a_mat: a continuous memory placing n * m elements of int
// b_mat: a continuous memory placing m * l elements of int
void matrix_multiply(const int n, const int m, const int l,
                     const int *a_mat, const int *b_mat)
{
    int rank, size, mtype ;
    int n_, m_, l_ ;
    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int rows, avg_row, extra_row, offset;
    if ( rank == MASTER ){
        int *result_c_mat_master;
        avg_row = n / size;
        extra_row = n % size;
        offset = 0;
        int offset_master = 0;
        mtype = FROM_MASTER;
        int offset_and_rows[2][size];

        MPI_Request master_request_1[size][7];
        int my_offect;
        for (int i = 1; i < size; i+=1){
            rows = avg_row;
            offset = (i-1) * avg_row;
            offset_and_rows[0][i] = offset;
            offset_and_rows[1][i] = rows;
            
            MPI_Isend(&n, 1, MPI_INT, i, mtype+1, MPI_COMM_WORLD, &master_request_1[i][0]);
            MPI_Isend(&m, 1, MPI_INT, i, mtype+2, MPI_COMM_WORLD, &master_request_1[i][1]);
            MPI_Isend(&l, 1, MPI_INT, i, mtype+3, MPI_COMM_WORLD, &master_request_1[i][2]);
            MPI_Isend(&offset, 1, MPI_INT, i, mtype+4, MPI_COMM_WORLD, &master_request_1[i][3]);
            MPI_Isend(&rows, 1, MPI_INT, i, mtype+5, MPI_COMM_WORLD, &master_request_1[i][4]);
            MPI_Isend(&b_mat[0], m * l, MPI_INT, i, mtype+7, MPI_COMM_WORLD, &master_request_1[i][5]);
            MPI_Isend(&a_mat[offset_and_rows[0][i] * m], offset_and_rows[1][i] * m, MPI_INT, i, mtype+6, MPI_COMM_WORLD, &master_request_1[i][6]);
        
        }
        // double start_time = MPI_Wtime();
        MPI_Waitall((size-1)*7, &master_request_1[1][0], MPI_STATUSES_IGNORE);
        // double end_time = MPI_Wtime();
        // printf("MPI waiting time: %lf Seconds\n", end_time - start_time);

        result_c_mat_master = (int *)malloc(n * l * sizeof(int));
        
        offset_master = (size-1) * avg_row;
        rows = avg_row+extra_row;

        // master do its part
        int *a_with_offset = (int*)a_mat + offset_master * m;

        for (int i = 0; i < rows; i+=1){
            for (int j = 0; j < l; j+=1){
                int tmp = 0;
                for (int k = 0; k < m; k+=1){
                    tmp += a_with_offset[i * m + k] * b_mat[j * m + k];
                }
                result_c_mat_master[(offset_master + i) * l + j] = tmp;
            }
        }
        
        // receive result from workers
        
        mtype = FROM_WORKER;
        MPI_Request master_request_2[size];

        for (int source = 1; source < size; source+=1){
            MPI_Irecv(&result_c_mat_master[offset_and_rows[0][source] * l], offset_and_rows[1][source] * l, MPI_INT, source, mtype+3, MPI_COMM_WORLD, &master_request_2[source]);
        }
        MPI_Waitall(size-1, &master_request_2[1], MPI_STATUSES_IGNORE);
        
        #if DEBUG
        // print the part of master
        printf("master:\n");
        for (int i = 0; i < rows; i+=1){
            for (int j = 0; j < l; j+=1){
                printf("%d ", result_c_mat_master[(offset_master + i) * l + j]);
            }
            printf("\n");
        }
        printf("===================\n");
        #endif

        # if not DEBUG
        for (int i = 0; i < n; i+=1){
            for (int j = 0; j < l; j+=1){
                printf("%d ", result_c_mat_master[i * l + j]);
            }
            printf("\n");
        }
        # endif
        free(result_c_mat_master);
    }
    else{
        mtype = FROM_MASTER;
        MPI_Request worker_request_1[5];
        MPI_Request worker_request_2[2];

        MPI_Irecv(&n_, 1, MPI_INT, MASTER, mtype+1, MPI_COMM_WORLD, &worker_request_1[0]);
        MPI_Irecv(&m_, 1, MPI_INT, MASTER, mtype+2, MPI_COMM_WORLD, &worker_request_1[1]);
        MPI_Irecv(&l_, 1, MPI_INT, MASTER, mtype+3, MPI_COMM_WORLD, &worker_request_1[2]);
        MPI_Irecv(&offset, 1, MPI_INT, MASTER, mtype+4, MPI_COMM_WORLD, &worker_request_1[3]);
        MPI_Irecv(&rows, 1, MPI_INT, MASTER, mtype+5, MPI_COMM_WORLD, &worker_request_1[4]);
        MPI_Waitall(5, &worker_request_1[0], MPI_STATUSES_IGNORE);
        
        int *c_send = (int *)malloc(n_ * l_ * sizeof(int));

        int *b_recv = (int *)malloc(m_ * l_ * sizeof(int));
        MPI_Irecv(&b_recv[0], m_ * l_, MPI_INT, MASTER, mtype+7, MPI_COMM_WORLD, &worker_request_2[1]);
        
        int *a_recv = (int *)malloc(rows * m_ * sizeof(int));
        MPI_Irecv(&a_recv[0], rows * m_, MPI_INT, MASTER, mtype+6, MPI_COMM_WORLD, &worker_request_2[0]);
        
        MPI_Waitall(2, &worker_request_2[0], MPI_STATUSES_IGNORE);
        
        // worker do its part
        for (int i = 0; i < rows; i+=1){
            for (int j = 0; j < l_; j+=1){
                int tmp = 0;
                for (int k = 0; k < m_; k+=1){
                    tmp += a_recv[i * m_ + k] * b_recv[j * m_ + k];
                }
                c_send[i * l_ + j] = tmp;   
            }
        }

        #if DEBUG
        // print the part of worker
        printf("worker %d:\n", rank);
        for (int i = 0; i < rows; i+=1){
            for (int j = 0; j < l_; j+=1){
                printf("%d ", c_send[i * l_ + j]);
            }
            printf("\n");
        }
        printf("===================\n");
        #endif

        // send result back to master
        mtype = FROM_WORKER;
        
        MPI_Request worker_request_3;
        // MPI_Send(&c_send[0], rows * l_, MPI_INT, MASTER, mtype+3, MPI_COMM_WORLD);
        MPI_Isend(&c_send[0], rows * l_, MPI_INT, MASTER, mtype+3, MPI_COMM_WORLD, &worker_request_3);
        free(a_recv);
        free(b_recv);
        MPI_Wait(&worker_request_3, MPI_STATUSES_IGNORE);
        free(c_send);
    }
    
    return;
}

// Remember to release your allocated memory
void destruct_matrices(int *a_mat, int *b_mat){
    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if(rank == MASTER){
        free(a_mat);
        free(b_mat);
    }
    return;
}