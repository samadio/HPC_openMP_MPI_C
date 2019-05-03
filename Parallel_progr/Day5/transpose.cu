#include <stdio.h>
#define row 4
#define col 5
#define space row*col*sizeof(int)
#define elements row*col

__global__ void tranpose (int* A, int*B){
  int row= gridDim.x;
  int col= blockDim.x;
  B[col+row*i]=A[row+col*i];
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
  cudaMalloc( (void*)&dev_A, space );
  cudaMalloc( (void*)&dev_B, space );

  cudaMemcpy( dev_A, A, size, cudaMemcpyHostToDevice ); //send data to device

  // launch reverse() kernel
  transpose<<< row, col >>>(dev_A, dev_B);

  // copy device result back to host copy of c
  cudaMemcpy( B, dev_B, size,   cudaMemcpyDeviceToHost );

  for(i=0;i<elements;i++){
    if(i%col==0 && i!=0)printf("\n");
    printf("%d ", B[i]);
  }

  free(A); free(B);
  cudaFree( dev_A ); cudaFree( dev_B );
  return 0;
}
