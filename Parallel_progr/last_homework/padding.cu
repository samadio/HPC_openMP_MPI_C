#include <stdio.h>
#include<sys/time.h>
#include<math.h>

#define N 8192
#define nth 1024

__global__ void fast_transpose(size_t* A, size_t* B){
    __shared__ size_t Ablock[nth];
    __shared__ size_t Bblock[nth];

    size_t dimx=blockDim.x;
    size_t dimy=blockDim.y;
    
    //dimx=linear dimension in x of a submatrix block
    size_t th=threadIdx.x+threadIdx.y*dimx;
    size_t thx=threadIdx.x;
    size_t thy=threadIdx.y;

    size_t starty=blockIdx.y*N*dimy;
    size_t startx=blockIdx.x*dimx;
    size_t start= startx+starty;
    //Ablock is different for every block, so I can index it with th
    Ablock[th]= A[start+thx+(thy)*(N)];
    //creation of A completed for each block
    __syncthreads();

    //transpose into B block
    Bblock[dimy*thx + thy] = Ablock[th];

    __syncthreads();


    //put Bblock in B
    start=blockIdx.y*dimy+dimx*N*blockIdx.x; //the x block index of the original matrix becomes y index of transpose, so skip N
    B[ start+thy+(thx)*(N) ]=Bblock[dimy*thx + thy];

}

__global__ void transpose(size_t* A, size_t *B){
  size_t j=blockIdx.x;
  size_t i=threadIdx.x;
  while(i<N){
    B[j+i*N]=A[i+j*N];
    i+=blockDim.x;
  }
  
}

                                        /////////////////////C utilites//////////////////////////////

int transposed(size_t *A, size_t* At){
  size_t i,j;
   for(i=0;i<N;i++){
     for(j=0;j<N;j++){
       if(A[i+j*N]!=At[j+i*N]){return 0;}
     }
   }
   return 1;
}

double seconds()

{

  struct timeval tmp;
  double sec;
  gettimeofday( &tmp, (struct timezone *)0 );
  sec = tmp.tv_sec + ((double)tmp.tv_usec)/1000000.0;
  return sec;

}

                            ////////////////////////////////////main
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

  double tstart=seconds();
  transpose<<< N, nth >>>(dev_A, dev_B); 
  cudaDeviceSynchronize();
  double duration=seconds()-tstart;
  printf("transp time: %lf\n",duration);

  cudaMemcpy( B, dev_B, space, cudaMemcpyDeviceToHost );

  printf("correct? %d\n\n",transposed(A,B));

  size_t block_side= (size_t)sqrt(nth);
  dim3 grid,block;
  if(block_side*block_side==nth){
    grid.x=grid.y=N/block_side;  //number of orizontal blocks=number of vertical blocks
    block.x=block.y=block_side;  //block linear length
  }
  else{
    grid.x=N/32; //ideally, we should have an algorithm that given nth finds (a,b) integers such that nth=a*b and (a,b) closest to each other
    grid.y=N/16; //to be preferred a>b, so that we read more often on x (continous in memory)
    block.x=32;
    block.y=16;
  }
  
  tstart=seconds();
  fast_transpose<<< grid, block >>>(dev_A, dev_B);
  cudaDeviceSynchronize();
  duration=seconds()-tstart;
  printf("fast times: %lf\n",duration);

  cudaMemcpy( B, dev_B, space, cudaMemcpyDeviceToHost );

/*  for(i=0;i<elements;i++){
     if(i%N==0 && i!=0)printf("\n");  
     printf("%d ", A[i]);
  }
  printf("\n");
               
               
  for(i=0;i<elements;i++){
    if(i%N==0 && i!=0)printf("\n");
    
    printf("%d ", B[i]);
    }
  printf("\n"); */

  printf("correct? %d\n\n",transposed(A,B));

  free(A);free(B);
  cudaFree(dev_A);cudaFree(dev_B);
}
