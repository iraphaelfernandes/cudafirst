%%cu
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>


// int xindex = threadIdx.x + blockIdx.x * blockDim.x;
__global__ void meu_kernel( void ){
  
  printf( "ID da thread: %d\n" , threadIdx.x );
  printf( "Dim do bloco: %d\n" , blockDim.x );
  printf( "ID bloco: %d\n" , blockIdx.x);
}

// Define a variável de captura de erros
cudaError_t cudaStatus;

int main( ){

// Informa o device a ser usado caso exista mais de 1
cudaStatus = cudaSetDevice( 0 );

// Testa a função cudaSetDevice retornou erro
if ( cudaStatus != cudaSuccess ){
  
    fprintf( stderr , "cudaSetDevice falhou! Existe dispositivo com suporte a CUDA instalado?" );
    goto Error;
  }


meu_kernel << <1 , 10 >> > ( );


// Captura o último erro ocorrido
cudaStatus = cudaGetLastError( );
if ( cudaStatus != cudaSuccess ){
  
  fprintf( stderr , "meu_kernel falhou: %s\n" ,
    cudaGetErrorString( cudaStatus ) );
  goto Error;
}

// Sincroniza a execução do kernel com a CPU
cudaStatus = cudaDeviceSynchronize( );
if ( cudaStatus != cudaSuccess ){
  
  fprintf( stderr , "cudaDeviceSynchronize retornou erro %d após lançamento do kernel!\n" ,
      cudaStatus );
  goto Error;
}

int nDevices;

  // cudaGetDeviceCount(&nDevices);
  // for (int i = 0; i < nDevices; i++) {
  //   cudaDeviceProp prop;
  //   cudaGetDeviceProperties(&prop, i);
  //   printf("Device Number: %d\n", i);
  //   printf("  Device name: %s\n", prop.name);
  //   printf("  Memory Clock Rate (KHz): %d\n",
  //          prop.memoryClockRate);
  //   printf("  Memory Bus Width (bits): %d\n",
  //          prop.memoryBusWidth);
  //   printf("  Peak Memory Bandwidth (GB/s): %f\n\n",
  //          2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  // }

Error:
// Executa a limpeza GPU
cudaStatus = cudaDeviceReset ( );
if ( cudaStatus != cudaSuccess )
{
  fprintf( stderr , "cudaDeviceReset falhou!"  );
  return 1;
}

  return 0 ;
 
}