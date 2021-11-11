%%cu

#include <stdio.h>
#include <stdlib.h>

//dimensões da matriz
#define L 5
#define C 5
//dimensões da grid
#define BLOCKDIMX 3
#define BLOCKDIMY 2

// gerar uma matriz aleatoriamente na memória, transferir a matriz para gpu. 
// Na gpu, criar uma nova matriz, onde linha i de Nova = Linha i+1 da matriz A

//1 dimensão pq não consigo passar 2 dimensoes do host para o device
// int matrizEntrada[];
// int matrizSaida[];

void printMatriz(int l, int c, int* mat);
void invertePosicaoDasLinhas(int* matrizEntrada, int* matrizSaida);

int main() {

    float time;
    cudaEvent_t start, stop;
    
    const int len = L*C; //número de elementos na matriz
    
    //1 dimensão pq não consigo passar 2 dimensoes do host para o device
    int* matin = (int*)malloc(len * sizeof(int*));
    int* matout = (int*)malloc(len * sizeof(int*));
    
    cudaError_t cudaStatus;
    
    //antes da função principal, depois das declarações de matrizes e vars
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);

    //Preenche a matriz de entrada aleatoriamente
    for(int i = 0; i < len; i++){
        matin[i] = (rand() % 99) + 1;
    }
    
    
    invertePosicaoDasLinhas(matin, matout);
    //depois da função principal
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&time, start, stop);
    
    
    
    //----------------Imprimir----------------------
    printf("Matriz de entrada:\n\n");
    printMatriz(L, C, matin);
    
    printf("Matriz de saída:\n\n");
    printMatriz(L, C, matout);
    
    //depois de tudo
    printf("Time to generate:  %3.5f ms \n", time);
    
    int* dev_matin = 0;
    int* dev_matout = 0;
}

void printMatriz(int l, int c, int* mat) {
    
    int i, j;

    for (i = 0; i < l; i++)
    {
        for (j = 0; j < c; j++)
        {
            printf("%d\t", mat[i*c + j]);
        }
        printf("\n\n");
    }
    printf("\n\n");
}

void invertePosicaoDasLinhas(int* matrizEntrada, int* matrizSaida){
    
    int i, j;
    int contador;
    int elementoSaida, elementoEntrada;
    
    for(i=0; i<(L-1); i++){
        
        for (j = 0; j < C; j++){
            
            elementoSaida = i*C+j;
            elementoEntrada = (i+1)*C+j;
            matrizSaida[elementoSaida]=matrizEntrada[elementoEntrada];
        }
        
    }
    
    for(i=0; i < C; i++){
        
        elementoEntrada=i;
        elementoSaida=((L-1)*C)+i;
        
        matrizSaida[elementoSaida]=matrizEntrada[elementoEntrada];
    }
}