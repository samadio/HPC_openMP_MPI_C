#include <stdio.h>
#include<math.h>
#define row 8192
#define col 8192
#define space 8192*8192*sizeof(int)
#define elements 8192

#define th_per_block 64


//this works until col<=Nthreads. In this case every threads moves only 1 data

__global__ void initialize_table (int* A, int** table, int ncol){
  int i=threadIdx.x;
  table[i]=A+i*ncol;  
}


__global__ void transpose (int** A, int** B,size_t cols){
  size_t i=blockIdx.x;
  size_t j=threadIdx.x;
  while(i<cols){
    B[j][i]=A[i][j];
    i+=blockDim.x;
  }

}

__global__ void fast_transpose (int** tableA, int** tableB, const size_t dim){
  __shared__ int miniblockA[blockDim.x];
  __shared__ int miniblockB[blockDim.x];
  size_t dim= (size_t) sqrt(size);
  if(threadIdx.x==0 && threadIdx.y==0){
    size_t i;  
    for(i=0;i<blockDim.x;i++){
        miniblockA[i]=tableA[dim*blockIdx.y+i/dim][dim*blockIdx.x+i%dim];
      }
  }
  __sychthreads();

  miniblockB[dim*threadIdx.x+threadIdx.x]=miniblockA[dim*threadIdx.x+threadIdx.y];

  __sychthreads();

  if(threadIdx.x==0 && threadIdx.y==0){
    for(i=0;i<blockDim.x;i++){
      tableB[dim*blockIdx.y+i/dim][dim*blockIdx.x+i%dim]=miniblockB[i];
    }
  }

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

  int** dev_tableA;
  int** dev_tableB;

  // allocate device copies of A and B
  cudaMalloc( (void**)&dev_A, space );
  cudaMalloc( (void**)&dev_B, space );
  cudaMalloc( (void***)&dev_tableA, row*sizeof(int) );
  cudaMalloc( (void***)&dev_tableB, col*sizeof(int) );

  cudaMemcpy( dev_A, A, space, cudaMemcpyHostToDevice ); //send data to device

  initialize_table<<< 1, row >>>(dev_A, dev_tableA,col); 
  initialize_table<<< 1, col >>>(dev_B, dev_tableB,row); 


  // launch transpose() kernel
  transpose<<< elements/th_per_block, th_per_block >>>(dev_tableA, dev_tableB,col,dim); 

  int dim= (int)sqrt(th_per_block);
  dim3 grid,block;
  grid.x=col/dim;
  grid.y=row/dim;
  block.x=dim;
  block.y=dim;

  fast_transpose<<< row*col/th_per_block, th_per_block >>>(dev_tableA, dev_tableB,dim); 

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
  cudaFree( dev_A ); cudaFree( dev_B ); cudaFree(tableA);cudaFree(tableB);
  return 0;
}
