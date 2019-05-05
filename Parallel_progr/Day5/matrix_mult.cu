#include <stdio.h>
#define N 2048
#define nthreads 512


__global__ void matrix_mul (int* A, int*B,int*C,int size){
  int i=threadIdx.x+(blockIdx.x*blockDim.x);
  int rowidx= (i/size)*size;
  int colidx= i%size;
  int acc=0;
  int k;
  
  for(k=0; k<size;k++){
    acc+=A[rowidx+k]*B[colidx+k*size];
  }
  C[i]=acc;
}


int main() {
    
  int*A=(int*)malloc(N*N*sizeof(int));
  int* dev_A;
  int*B=(int*)malloc(N*N*sizeof(int));
  int* dev_B;
  int*C=(int*)malloc(N*N*sizeof(int));
  int* dev_C;

  int i;
  for(i=0;i<N*N;i++){
    A[i]=i;
  }
  
  for(i=0;i<N*N;i++){
    B[i]=i;
  }


  // allocate space for all the three matrixes
  cudaMalloc( (void**)&dev_A,  N*N*sizeof(int));
  cudaMalloc( (void**)&dev_B, N*N*sizeof(int) );
  cudaMalloc( (void**)&dev_C, N*N*sizeof(int) );

  //send data to device
  cudaMemcpy( dev_A, A, N*N*sizeof(int), cudaMemcpyHostToDevice );
  cudaMemcpy( dev_B, B, N*N*sizeof(int), cudaMemcpyHostToDevice );

  // launch matrix_mul kernel
  matrix_mul<<< (N*N)/nthreads, nthreads >>>(dev_A, dev_B, dev_C, N);

  // copy results
  cudaMemcpy( C, dev_C, N*N*sizeof(int),   cudaMemcpyDeviceToHost );

/*  for(i=0;i<N*N;i++){
    if(i%N==0 && i!=0)printf("\n");
      printf("%d ", C[i]);
  }
  printf("\n"); */

  free(A); free(B);free(C);
  cudaFree( dev_A ); cudaFree( dev_B );cudaFree( dev_C );
  return 0;
}
