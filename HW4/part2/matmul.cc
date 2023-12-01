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
        useless = scanf("%d %d %d", n_ptr, m_ptr, l_ptr);
        *a_mat_ptr = (int *)malloc((*n_ptr) * (*m_ptr) * sizeof(int));
        *b_mat_ptr = (int *)malloc((*m_ptr) * (*l_ptr) * sizeof(int));
        for (int i = 0; i < (*n_ptr) * (*m_ptr); i++)
            useless = scanf("%d", *a_mat_ptr+i);
        for (int i = 0; i < (*m_ptr); i++)
            for (int j = 0; j < (*l_ptr); j++)
                useless = scanf("%d", *b_mat_ptr + j * (*m_ptr) + i);
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
        result_c_mat_master = (int *)malloc(n * l * sizeof(int));
        avg_row = n / size;
        extra_row = n % size;
        offset = 0;
        int offset_master = 0;
        mtype = FROM_MASTER;
    
        for( int dest = 1; dest < size; dest += 1){
            rows = (dest < extra_row) ? avg_row + 1 : avg_row;
            MPI_Send(&n, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&m, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&l, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&offset, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&rows, 1, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&a_mat[offset * m], rows * m, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            MPI_Send(&b_mat[0], m * l, MPI_INT, dest, mtype, MPI_COMM_WORLD);
            offset += rows;
        }

        offset_master = offset;
        // master do its part
        rows = (rank < extra_row) ? avg_row + 1 : avg_row;
        int *a_with_offset = (int*)a_mat + offset_master * m;

        for (int i = 0; i < rows; i++){
            for (int j = 0; j < l; j++){
                result_c_mat_master[(offset_master + i) * l + j] = 0;
                for (int k = 0; k < m; k++){
                    result_c_mat_master[(offset_master + i) * l + j] += a_with_offset[i * m + k] * b_mat[j * m + k];
                }
            }
        }

        // receive result from workers
        
        mtype = FROM_WORKER;
        for (int source = 1; source < size; source+=1){
            MPI_Recv(&offset, 1, MPI_INT, source, mtype, MPI_COMM_WORLD, &status);
            MPI_Recv(&rows, 1, MPI_INT, source, mtype, MPI_COMM_WORLD, &status);
            MPI_Recv(&result_c_mat_master[offset * l], rows * l, MPI_INT, source, mtype, MPI_COMM_WORLD, &status);
        }
        

        #if DEBUG
        // print the part of master
        printf("master:\n");
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < l; j++){
                printf("%d ", result_c_mat_master[(offset_master + i) * l + j]);
            }
            printf("\n");
        }
        printf("===================\n");
        #endif
        for (int i = 0; i < n; i++){
            for (int j = 0; j < l; j++){
                printf("%d ", result_c_mat_master[i * l + j]);
            }
            printf("\n");
        }
        free(result_c_mat_master);
    }
    else{
        mtype = FROM_MASTER;
        MPI_Recv(&n_, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&m_, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&l_, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);

        MPI_Recv(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&rows, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);

        int *a_recv = (int *)malloc(n_ * m_ * sizeof(int));
        int *b_recv = (int *)malloc(m_ * l_ * sizeof(int));
        int *c_send = (int *)malloc(n_ * l_ * sizeof(int));
        
        MPI_Recv(&a_recv[0], rows * m_, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);
        MPI_Recv(&b_recv[0], m_ * l_, MPI_INT, MASTER, mtype, MPI_COMM_WORLD, &status);

        // worker do its part
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < l_; j++){
                c_send[i * l_ + j] = 0;
                for (int k = 0; k < m_; k++){
                    c_send[i * l_ + j] += a_recv[i * m_ + k] * b_recv[j * m_ + k];
                }
                
            }
        }

        #if DEBUG
        // print the part of worker
        printf("worker %d:\n", rank);
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < l_; j++){
                printf("%d ", c_send[i * l_ + j]);
            }
            printf("\n");
        }
        printf("===================\n");
        #endif

        // send result back to master
        mtype = FROM_WORKER;
        MPI_Send(&offset, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
        MPI_Send(&rows, 1, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
        MPI_Send(&c_send[0], rows * l_, MPI_INT, MASTER, mtype, MPI_COMM_WORLD);
        free(a_recv);
        free(b_recv);
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
}