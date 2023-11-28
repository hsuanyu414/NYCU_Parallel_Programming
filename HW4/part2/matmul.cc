#include <mpi.h>
#include <stdio.h>

#define MASTER 0
#define FROM_MASTER 1
#define FROM_WORKER 2

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
    int rank;
    int size;
    int a;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank == MASTER){
        a = scanf("%d %d %d", n_ptr, m_ptr, l_ptr);
        *a_mat_ptr = (int *)malloc((*n_ptr) * (*m_ptr) * sizeof(int));
        *b_mat_ptr = (int *)malloc((*m_ptr) * (*l_ptr) * sizeof(int));
        for (int i = 0; i < (*n_ptr) * (*m_ptr); i++)
            a = scanf("%d", *a_mat_ptr+i);
        for (int i = 0; i < (*m_ptr) * (*l_ptr); i++)
            a = scanf("%d", *b_mat_ptr+i);
        // transpose b_mat
        int *b_mat = *b_mat_ptr;
        int *b_mat_t = (int *)malloc((*m_ptr) * (*l_ptr) * sizeof(int));
        for (int i = 0; i < (*m_ptr); i++)
            for (int j = 0; j < (*l_ptr); j++)
                b_mat_t[j * (*m_ptr) + i] = b_mat[i * (*l_ptr) + j];
        free(b_mat);
        *b_mat_ptr = b_mat_t;
    }// singel node io
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
    int rank, size;
    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {// only compute on the master node
        int *c_mat = (int *)malloc(n * l * sizeof(int));
        for (int i = 0; i < n; i++)
            for (int j = 0; j < l; j++)
            {
                c_mat[i * l + j] = 0;
                for (int k = 0; k < m; k++)
                    // c_mat[i * l + j] += a_mat[i * m + k] * b_mat[k * l + j];
                    c_mat[i * l + j] += a_mat[i * m + k] * b_mat[j * m + k];
            }
        for (int i = 0; i < n ; i++)
        {
            for (int j = 0; j < l; j++)
                printf("%d ", c_mat[i * l + j]);
            printf("\n");
        }
        
        free(c_mat);
    }
}

// Remember to release your allocated memory
void destruct_matrices(int *a_mat, int *b_mat){
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if(rank == 0){
        free(a_mat);
        free(b_mat);
    }
}