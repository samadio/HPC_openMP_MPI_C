#include <stdlib.h>
#include <stdio.h>

// Header file for compiling code including MPI APIs
#include <mpi.h>


int main( int argc, char * argv[] ){

  int imesg = 0;
  int rank = 0; // store the MPI identifier of the process
  int npes = 1; // store the number of MPI processes

  MPI_Init( &argc, &argv );
  MPI_Comm_rank( MPI_COMM_WORLD, &rank );
  MPI_Comm_size( MPI_COMM_WORLD, &npes );

  imesg = rank;
  
  if(rank==0){
    MPI_Send(&rank,1,MPI_INT,1,101,MPI_COMM_WORLD);
  }
  if(rank==1){
    MPI_Recv(&imesg,1,MPI_INT,0,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
    printf("rank %d, message %d\n", rank,imesg);
  }

  MPI_Finalize();
  
  return 0;

}
