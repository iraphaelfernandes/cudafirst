%%cu
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "stdio.h"



int main() {
  int nDevices;
  nDevices = 5;
  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Nome do divice: %s\n", prop.name);
    printf("  Taxa de clock da memória (KHz): %d\n",
           prop.memoryClockRate);
    printf("  Largura do barramento de memória (bits): %d\n",
           prop.memoryBusWidth);
    printf("  Pico de largura de banda de memória (GB/s): %f\n\n",
           2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  }
}
