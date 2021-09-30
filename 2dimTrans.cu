%%cu

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

//dimensões da matriz
#define LINHAS 3
#define COLUNAS 3

//dimensões da grid
#define DIMX 3
#define DIMY 3

__global__ void transp(int linha, int coluna, int* matin, int* matout) {
  
    int x = blockDim.x * blockIdx.x + threadIdx.x; //coluna
    int y = blockDim.y * blockIdx.y + threadIdx.y; //linha

    
    if(y < 2)  {
      printf("");
    }

    if(x<COLUNAS && y < LINHAS)  {
        
      int idin = y*coluna + x;
      int idout = x*linha + y;

      matout[idout] = matin[idin]; 
    }
}

void printM(int l, int c, int* mat) {

    int i, j;

    for (i = 0; i < l; i++)
    {
        for (j = 0; j < c; j++)
        {
            printf("%d\t", mat[i*c + j]); //retirei a ideia do indice daqui
        }
        printf("\n\n");
    }
    printf("\n\n");
}

int main() {
    const int nElem = LINHAS*COLUNAS; //número de elementos na matriz

    int* matin = (int*)malloc(nElem * sizeof(int*));
    int* matout = (int*)malloc(nElem * sizeof(int*));

    int elemento = 1;
    for(int i = 0; i < nElem; i++){
      
      matin[i] = elemento;
      elemento++;
    }

    printM(LINHAS, COLUNAS, matin);

    int* matinGPU = 0;
    int* matoutGPU = 0;

    cudaError_t cudaStatus;
    
    cudaStatus = cudaMalloc( ( void** ) &matinGPU , nElem * sizeof( int ) );
    cudaStatus = cudaMalloc( ( void** ) &matoutGPU , nElem * sizeof( int ) );

    cudaStatus = cudaMemcpy( matinGPU , matin , nElem * sizeof( int ) , cudaMemcpyHostToDevice );

    dim3 grid(DIMX, DIMY);

    dim3 block( (COLUNAS + DIMX - 1)/DIMX , (LINHAS + DIMY - 1)/DIMY);

    transp<<<grid, block>>>(LINHAS, COLUNAS, matinGPU, matoutGPU);

    cudaStatus = cudaMemcpy( matout, matoutGPU, nElem * sizeof( int ), cudaMemcpyDeviceToHost);
    
    printM(COLUNAS, LINHAS, matout); //Pq não posso imprimir o que está na gpu?

    return 0;
}