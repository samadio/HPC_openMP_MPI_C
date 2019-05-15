#include<stdio.h>
#include<sys/time.h>

int transposed(size_t *A, size_t* At){
  size_t i,j;
   for(i=0;i<8192;i++){
     for(j=0;j<8192;j++){
       if(A[i+j*8192]!=At[j+i*8192]){return 0;}
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

int main(){

  size_t* A=(size_t*)malloc(8192*8192*sizeof(size_t));
  size_t* B=(size_t*)malloc(8192*8192*sizeof(size_t));
  size_t i,j;
  for(i=0;i<8192*8192;i++) A[i]=i%8192;
  double tstart=seconds();
  for(i=0;i<8192;i++){
    for(j=0;j<8192;j++){
      B[j+i*8192]=A[i+j*8192];
    }
  }
  double duration=seconds()-tstart;
  printf(" %d: %lf \n",transposed(A,B),duration);
  return 0;
}
