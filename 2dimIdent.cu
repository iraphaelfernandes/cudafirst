    %%cu

    #include "cuda_runtime.h"
    #include "device_launch_parameters.h"

    #include <stdio.h>

    //matriz quadrada
    #define N 3

    // 1 0 0
    // 0 1 0
    // 0 0 1
    
    
    void printM(int L, int C, int* mat) {

        int i, j;

        for (i = 0; i < L; i++)
        {
            for (j = 0; j < C; j++)
            {
                printf("%d  ", mat[i*C + j]);
            }
            printf("\n");
        }
        printf("\n\n");
    }



    __global__ void ident(int n, int* mat) {
        
        int i = blockDim.x * blockIdx.x + threadIdx.x; //i representa a coluna de um elemento qualquer
        int j = blockDim.y * blockIdx.y + threadIdx.y; //j representa a linha de um elemento qualquer
        
        int id = j*n + i; //n é a dimensão, posto

        mat[id] = 0;

        if (i < n && j < n) {
        
            if (i == j) {
                
                mat[id] = 1;
            } 
        }
    }



    int main() {

        int* mat = (int*)malloc(N * N * sizeof(int*));

        int* matGPU = 0;
        cudaError_t cudaStatus;

        // Alocar espaço na memória do device
        cudaStatus = cudaMalloc( ( void** ) &matGPU , N * N * sizeof( int ) );

        dim3 grid(2, 2);
        dim3 block(3, 3);

        ident<<<grid, block>>>(N, matGPU); //como ele executa isso?
        

        cudaStatus = cudaMemcpy( mat , matGPU , N * N * sizeof( int ) , cudaMemcpyDeviceToHost );
        
        printM(N, N, mat);

        return 0;
    }