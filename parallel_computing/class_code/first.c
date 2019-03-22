// This is our first parallel code that implements the sum of 2 vectors in parallel
//using a shared memory approach, implemented with OpenMP
#include<stdlib.h>
#include<stdio.h>

//Header file for compiling code including OpenMP APIs
#include<omp.h>

#define N 16

int main(int argc, char* argv[]){
  
  int thread_id=0;
  int *a, *b, *c;
  int i=0;

  a=(int*)malloc(N*sizeof(int));
  b=(int*)malloc(N*sizeof(int));  
  c=(int*)malloc(N*sizeof(int));

#pragma omp parallel private(thread_id,i)
  {
    int n_threads=omp_get_num_threads();
    thread_id=omp_get_thread_num();
    int num_ist_per_thread= N/n_threads;

    int start=num_ist_per_thread*thread_id;
    int stop=start+num_ist_per_thread;
    for(i = start; i < stop; i++)
    {
        a[i]=b[i]=thread_id;
        c[i]=a[i]+b[i];
    }
    
  }
  for(i = 0; i < N; i++)
  {
    fprintf(stdout, "c[ %d ]= a[ %d ]+ b[ %d ]= %d\n", i,i,i, c[i]);
  }
  
  return 0;
}