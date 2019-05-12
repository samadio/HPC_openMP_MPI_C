#include <stdio.h>
#include<math.h>
#define N 8192
#define nth 1024

__global__ void fast_transpose(size_t* A, size_t* B,size_t dim){
    __shared__ size_t Ablock[nth];
    __shared__ size_t Bblock[nth];

    //dim=linear dimension of a submatrix block
    size_t th=threadIdx.x+threadIdx.y*dim;
    size_t thx=threadIdx.x;
    size_t thy=threadIdx.y;

    size_t starty=blockIdx.y*N*dim;
    size_t startx=blockIdx.x*dim;
    size_t start= startx+starty;
    //Ablock is different for every block, so I can index it with th
    Ablock[th]= A[start+thx+(thy)*(N)];
    //creation of A completed for each block
    __syncthreads();

    //transpose into B block
    Bblock[dim*thx + thy] = Ablock[th];

    __syncthreads();


    //put Bblock in B
    start=blockIdx.y*dim+dim*N*blockIdx.x; //the x block index of the original matrix becomes y index of transpose, so skip N
    B[ start+thy+(thx)*(N) ]=Bblock[dim*thx + thy];

}

int transposed(size_t *A, size_t* At){
  size_t i,j;
   for(i=0;i<N;i++){
     for(j=0;j<N;j++){
       if(A[i+j*N]!=At[j+i*N]){return 0;}
     }
   }
   return 1;
}


int main(){
    size_t elements=N*N;
    size_t space=N*N*sizeof(size_t);

    size_t*A=(size_t*)malloc(space);
    size_t*dev_A;
    size_t*B=(size_t*)malloc(space);
    size_t*dev_B;

    size_t i;
    for(i=0;i<elements;i++){
        A[i]=i%N;
    }

    cudaMalloc( (void**)&dev_A, space );
    cudaMalloc( (void**)&dev_B, space );

    cudaMemcpy( dev_A, A, space, cudaMemcpyHostToDevice );

  size_t block_side= (size_t)sqrt(nth);
  dim3 grid,block;
  grid.x=grid.y=N/block_side;  //number of orizontal blocks=number of vertical blocks
  block.x=block.y=block_side;  //block linear length
  
  fast_transpose<<< grid, block >>>(dev_A, dev_B,block_side);
  
  cudaMemcpy( B, dev_B, space, cudaMemcpyDeviceToHost );

/*  for(i=0;i<elements;i++){
     if(i%N==0 && i!=0)printf("\n");  
     printf("%d ", A[i]);
  }
  printf("\n");*/
               
               
  printf("%d\n",transposed(A,B));
  for(i=0;i<elements;i++){
    if(i%N==0 && i!=0)printf("\n");
    
    printf("%d ", B[i]);
    }
  printf("\n"); 

  free(A);free(B);
  cudaFree(dev_A);cudaFree(dev_B);
}
