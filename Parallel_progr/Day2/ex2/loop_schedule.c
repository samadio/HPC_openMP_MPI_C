#include <stdlib.h>
#include <stdio.h>
#include<omp.h>

void print_usage( int * a, int N, int nthreads ) {

  int tid, i;
  for( tid = 0; tid < nthreads; ++tid ) {

    fprintf( stdout, "%d: ", tid );

    for( i = 0; i < N; ++i ) {

      if( a[ i ] == tid) fprintf( stdout, "*" );
      else fprintf( stdout, " ");
    }
    printf("\n");
  }
}

int main( int argc, char * argv[] ) {
  const int N=250;
  int a[N];
  int nthreads=10;

    #pragma omp parallel
    {
      #pragma omp single //only one should execute this, no matter who
      {
        printf("chunk= None\n");
      }

      int thread_id=omp_get_thread_num(); //identifier
      int i;
      
      #pragma omp for schedule(dynamic)//implicit barrier is placed

      for(i = 0; i < N; i++)
      {
        a[i]=thread_id;
      }
      
      //only one should execute this, no matter who
      #pragma omp single
      {
        print_usage(a,N,nthreads);
        printf("\n");
      }
    }
  return 0;
}
