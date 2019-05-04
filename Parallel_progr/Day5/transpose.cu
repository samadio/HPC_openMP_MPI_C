#include <stdio.h>
#define row 4
#define col 5
#define space 4*5*sizeof(int)
#define elements 4*5

__global__ void transpose (int* A, int*B){
  int rows=blockIdx.x;
  int column=threadIdx.x;
  int col_dim=blockDim.x;
  int row_dim=gridDim.x;
  B[column+rows*row_dim]=A[rows+column*col_dim];
}


int main() {
    
  int*A=(int*)malloc(space);
  int* dev_A;
  int*B=(int*)malloc(space);
  int* dev_B;

  int i;
  for(i=0;i<elements;i++){
    A[i]=i;
  }

  // allocate device copies of A and B
  cudaMalloc( (void**)&dev_A, space );
  cudaMalloc( (void**)&dev_B, space );

  cudaMemcpy( dev_A, A, space, cudaMemcpyHostToDevice ); //send data to device

  // launch transpose() kernel
  transpose<<< row, col >>>(dev_A, dev_B);

  // copy device result back to host copy of c
  cudaMemcpy( B, dev_B, space,   cudaMemcpyDeviceToHost );

  for(i=0;i<elements;i++){
    if(i%col==0 && i!=0)printf("\n");
      printf("%d ", A[i]);
  }
  printf("\n");

  for(i=0;i<elements;i++){
    if(i%row==0 && i!=0)printf("\n");
    printf("%d ", B[i]);
  }
  printf("\n");

  free(A); free(B);
  cudaFree( dev_A ); cudaFree( dev_B );
  return 0;
}
