%%cu

#include <stdio.h>
#include <stdlib.h>

//dimensões da matriz
#define L 4
#define C 5

//dimensões da grid
#define BLOCKDIMX 3
#define BLOCKDIMY 2

//1 dimensão pq não consigo passar 2 dimensoes do host para o device
// int matrizEntrada[];
// int matrizSaida[];

void printMatriz(int l, int c, int* mat) {
    
    int i, j;

    for (i = 0; i < l; i++){
        
        for (j = 0; j < c; j++){
            
            printf("%d\t", mat[i*c + j]);
        }
        printf("\n\n");
    }
    printf("\n\n");
}

__global__ void invertePosicaoDasLinhas(int* matrizEntrada, int* matrizSaida) {
    
    int elementoSaida, elementoEntrada;
    
    //coluna de um elemento qualquer de matin
    int j = blockDim.x * blockIdx.x + threadIdx.x;
    //linha de um elemento qualquer de matin
    int i = blockDim.y * blockIdx.y + threadIdx.y;
    
    elementoSaida = i*C+j;
    elementoEntrada = (i+1)*C+j;
    matrizSaida[elementoSaida]=matrizEntrada[elementoEntrada];


    if(i==(L-1)) {
        
        elementoEntrada=j;
        elementoSaida=i*C+j;
        matrizSaida[elementoSaida]=matrizEntrada[elementoEntrada];
    }
}

int main() {

    float time;
    cudaEvent_t start, stop;
    
    const int len = L*C; //número de elementos na matriz
    
    //1 dimensão pq não consigo passar 2 dimensoes do host para o device
    int* matin = (int*)malloc(len * sizeof(int*));
    int* matout = (int*)malloc(len * sizeof(int*));
    
    cudaError_t cudaStatus;

    //Preenche a matriz de entrada aleatoriamente
    for(int i = 0; i < len; i++){
        matin[i] = (rand() % 99) + 1;
    }
    
    //antes da função principal, depois das declarações de matrizes e vars
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    cudaEventRecord(start, 0);
    
    
    
    int* dev_matin = 0;
    int* dev_matout = 0;
    // Alocar espaço na memória do device
    cudaStatus = cudaMalloc( ( void** ) &dev_matin , len * sizeof( int ) );
    cudaStatus = cudaMalloc( ( void** ) &dev_matout , len * sizeof( int ) );

    // Copia matin para a memória do device
    cudaStatus = cudaMemcpy( dev_matin , matin , len * sizeof( int ) , cudaMemcpyHostToDevice );

    dim3 block(BLOCKDIMX, BLOCKDIMY);
    dim3 grid( (C + BLOCKDIMX - 1)/BLOCKDIMX , (L + BLOCKDIMY - 1)/BLOCKDIMY);

    
    invertePosicaoDasLinhas<<<grid, block>>>(dev_matin, dev_matout);


    //depois da função principal
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&time, start, stop);

    //Copia matout para a memória do host
    cudaStatus = cudaMemcpy( matout, dev_matout, len * sizeof( int ), cudaMemcpyDeviceToHost);


    
    
    //----------------Imprimir----------------------
    printf("Matriz de entrada:\n\n");
    printMatriz(L, C, matin);
    
    printf("Matriz de saída:\n\n");
    printMatriz(L, C, matout);
    
    //depois de tudo
    printf("Time to generate:  %3.5f ms \n", time);
    
}