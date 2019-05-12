#include <stdio.h>
#include<math.h>

#define row 8192
#define col 8192
#define space 8192*8192*sizeof(size_t)
#define elements 8192*8192

#define th_per_block 1024

///////////////////CUDA///////////////////
__global__ void initialize_table (size_t* A, size_t** table, size_t ncol){
  size_t i=threadIdx.x;
  size_t j=blockIdx.x;
  table[i]=A+j*gridDim.x+i*ncol;
}


__global__ void transpose (size_t** A, size_t** B,size_t cols){
  size_t i=blockIdx.x;
  size_t j=threadIdx.x;
  while(i<cols){
    B[j][i]=A[i][j];
  i+=blockDim.x;
}

}

__global__ void fast_transpose (size_t** tableA, size_t** tableB, const size_t dim){
  __shared__ size_t miniblockA[th_per_block];
  __shared__ size_t miniblockB[th_per_block];
  if(threadIdx.x==0 && threadIdx.y==0){
    size_t i;
    for(i=0;i<th_per_block;i++){
      miniblockA[i]=tableA[dim*blockIdx.y+i/dim][dim*blockIdx.x+i%dim];
    }
  }
  __syncthreads();

  miniblockB[dim*threadIdx.y+threadIdx.x]=miniblockA[dim*threadIdx.x+threadIdx.y];

  __syncthreads();

  if(threadIdx.x==0 && threadIdx.y==0){
    size_t i;
    for(i=0;i<th_per_block;i++){
      tableB[dim*blockIdx.x+i/dim][dim*blockIdx.y+i%dim]=miniblockB[i];
    }
  }

}

//////////////////////C utilites

void print_is_transpose(size_t *mat, size_t *transp, const size_t n){
    
  size_t i, j;
  for (i = 0; i < n; ++i){
for (j = 0; j < n; ++j)
    printf("%d ",(mat[i*n + j] != transp[j*n + i]) ? 0 : 1);
putchar('\n');
  }
}

int main() {

  size_t*A=(size_t*)malloc(space);
  size_t* dev_A;
  size_t* B=(size_t*)malloc(space);
  size_t* dev_B;
  
  size_t i;
  for(i=0;i<elements;i++){
    A[i]=i%row;
  }
  
  size_t** dev_tableA;
  size_t** dev_tableB;
  
  cudaMalloc( (void**)&dev_A, space );
  cudaMalloc( (void**)&dev_B, space );
  cudaMalloc( (void***)&dev_tableA, row*sizeof(size_t) );
  cudaMalloc( (void***)&dev_tableB, col*sizeof(size_t) );
  
  cudaMemcpy( dev_A, A, space, cudaMemcpyHostToDevice ); //send data to device
  
  if(row<=1024 && col<=1024){
    initialize_table<<< 1, row >>>(dev_A, dev_tableA,col);
    initialize_table<<< 1, col >>>(dev_B, dev_tableB,row);  
  }
  else{
    initialize_table<<< elements/th_per_block, th_per_block >>>(dev_A, dev_tableA,col);
    initialize_table<<< elements/th_per_block, th_per_block >>>(dev_B, dev_tableB,row);
  }
  
  // launch transpose() kernel
  transpose<<< elements/th_per_block, th_per_block >>>(dev_tableA, dev_tableB,col);
  
  size_t dim= (size_t)sqrt(th_per_block);
  dim3 grid,block;
  grid.x=col/dim;
  grid.y=row/dim;
  block.x=dim;
  block.y=dim;
  
  fast_transpose<<< grid, block >>>(dev_tableA, dev_tableB,dim);
  
  // copy device result back to host copy of c
  cudaMemcpy( B, dev_B, space, cudaMemcpyDeviceToHost );
  
/*  for(i=0;i<elements;i++){
  if(i%col==0 && i!=0)printf("\n");
  printf("%d ", A[i]);
  }
  printf("\n"); */
  
  for(i=0;i<elements;i++){
  if(i%row==0 && i!=0)printf("\n");
  
  printf("%d ", B[i]);
  }
  printf("\n");
 

<<<<<<< HEAD
  print_is_transpose(A,B, col); 
=======
  //print_is_transpose(mat_array, transp_array, N); 
>>>>>>> 9a442a36d2458910f4b2d0f9c80aaae55e549740
  free(A); free(B);
  cudaFree( dev_A ); cudaFree( dev_B ); cudaFree(dev_tableA);cudaFree(dev_tableB);
  return 0;
  }
