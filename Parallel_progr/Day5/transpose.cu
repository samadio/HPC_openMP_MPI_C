#include <stdio.h>
#define row 4
#define col 5
#define space 4*5*sizeof(int)
#define elements 4*5

//this works until col<=Nthreads. In this case every threads moves only 1 data
__global__ void transpose (int* A, int*B){
  int i=threadIdx.x+(blockIdx.x*blockDim.x);
  int totlength= blockDim.x*gridDim.x-1;
  int factor;
  if(blockIdx.x==0) factor=1;
  else factor=blockIdx.x;
  int j= i*(gridDim.x) %(totlength*factor);
  B[j]=A[i];
}


/*x=threadidx, y=blockidx
* while (x<N){        //in case col>Nthreads
  M_out(y*N+x)=M_in(x*N+y);
} x+=blockdim.x
*
*/

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
