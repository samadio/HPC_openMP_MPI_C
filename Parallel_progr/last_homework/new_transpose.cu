#include <stdio.h>
#include<math.h>
#define N 80
#define nth 4

__global__ void fast_transpose(size_t* A, size_t* B,size_t dim){
    __shared__ Ablock[nth];
    __shared__ Bblock[nth]

    size_t length=blockDim.x; //dim of a single block: (nth)
    
    size_t th=threadIdx.x+threadIdx.y*dim;
    size_t thx=threadIdx.x;
    size_t thy=threadIdx.y;

    size_t starty=blockIdx.y*N;
    size_t startx=blockIdx.x*dim;
    size_t start= startx+starty;
    //Ablock is different for every block, so I can index it with th
    //go on until nth==dim, then skip N numbers
    Ablock[th]= A[start+thx+(thy)*(N)];
    //creation of A completed for each block
    __syncthreads();

    //transpose B
    Bblock[dim*thy + thx] = Ablock[th];

    __syncthreads();


    //put Bblock back in B
    start=blockIdx.y*dim+N*blockIdx.x; //the x block index of the original matrix becomes y index of transpose, so skip N
    
    B[ start+thx+(thy)*(N) ]=Bblock[dim*thy + thx];

}


in main(){
    size_t elements=80*80;
    size_t space=80*80*sizeof(size_t);

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
  
  fast_transpose<<< grid, block >>>(dev_tableA, dev_tableB,block_side);
  

    free(A);free(B);
    cudaFree(dev_A);cudafree(dev_B);
}