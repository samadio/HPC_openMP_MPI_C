#include <stdio.h>

__global__ void reverse (int* in, int* out){
    out[blockDim.x-threadIdx.x-1]=in[threadIdx.x];
}


int main() {
    int d_in[]={100,110,200,220,300};
    int size = 5* sizeof( int );
    int* d_out=(int*)malloc(size);
    int *dev_in, *dev_out;  // device copies 
    int i;
    
    // allocate device copies of dev_in/out
    cudaMalloc( (void**)&dev_in, size );
    cudaMalloc( (void**)&dev_out, size);

   cudaMemcpy( dev_in, d_in, size, cudaMemcpyHostToDevice ); //send data to device

    // launch reverse() kernel
    reverse<<< 1, 5 >>>(dev_in, dev_out); //1 block of size threads

    // copy device result back to host copy of c
   cudaMemcpy( d_out, dev_out, size,   cudaMemcpyDeviceToHost );

   for(i=0;i<5;i++){
     printf(" %d ",d_in[i]);
   }
   printf("\n");
           
   for(i=0;i<5;i++){
     printf(" %d ",d_out[i]);
   }
   printf("\n");	

    free( d_out );
    cudaFree( dev_in );
    cudaFree( dev_out );
    return 0;
}
