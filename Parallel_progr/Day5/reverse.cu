#include <stdio.h>

__global__ reverse (int* in, int* out){
    out[blockDim.x-threadIdx.x]=in[threadIdx.x];
}


int main() {
    int d_in={100,110,200,220,300};
    int size = 5* sizeof( int ); // we need space for 5 integers
    int* d_out=(int*)malloc(size);
    int *dev_in, *dev_out,  // device copies 
    
    // allocate device copies of dev_in/out
    cudaMalloc( &dev_in, size );
    cudaMalloc( &dev_out, size );

   cudaMemcpy( dev_in, d_in, size, cudaMemcpyHostToDevice ); //send data to device

    // launch reverse() kernel
    reverse<<< 1, size >>>(dev_in, dev_out); //1 block of size threads

    // copy device result back to host copy of c
   cudaMemcpy( d_out, dev_out, size,   cudaMemcpyDeviceToHost );

    free( d_in );
    free( d_out );

    cudaFree( dev_in );
    cudaFree( dev_out );
    return 0;
}