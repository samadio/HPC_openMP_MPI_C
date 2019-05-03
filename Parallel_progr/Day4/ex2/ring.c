#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>


int main(int argc,char *argv[]){
  int rank = 0; // store the MPI identifier of the process
  int npes = 1; // store the number of MPI processes

  MPI_Init( &argc, &argv );
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &npes );
    size_t N=100000000; //10^8
    int* message= (int*)malloc(N*sizeof(int));
    int* sum= (int*)calloc(N,sizeof(int));

    int i;
    for (i = 0; i < N; i++)
    {
      message[i]=rand()%10;
    }
    
    for (i = 0; i < npes; i++)
    {
      MPI_Request req;

      MPI_Isend(message,N,MPI_INT,(rank+1)%npes,101,MPI_COMM_WORLD,&req); //send message npes times
      int rec;
      if(rank!=0){
        rec=rank-1;
      }
      else
      {
        rec=npes-1;
      }
      
      int j;
      for ( j = 0; j < N; j++)
      {
        sum[j]+=message[j];
      }
      
      MPI_Wait(&req,MPI_STATUS_IGNORE);
      MPI_Recv(message,N,MPI_INT,rec,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
    }

/*
    for (size_t i = 0; i <N; i++)
    {
      printf("%d ", sum[i]);
    }
    printf(" from proc %d\n", rank);
*/ //checked it works with N=4 

  MPI_Finalize();


  return 0;  
}
