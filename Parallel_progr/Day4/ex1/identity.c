#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc,char *argv[]){
  int rank = 0; 
  int npes = 1;
  int N=8; //global 
  FILE *f = fopen("identity.txt", "w"); //output file
  
  MPI_Init( &argc, &argv );
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &npes );
    int local_N=N/npes ; //local numb of rows; 
    int rest=N%npes;

    if(rank<rest) local_N+=1;

    //allocate a matrix with local_N rows and N cols
    int *A=(int*)calloc(local_N*N,sizeof(int));
    
    int i,start;
    
    if(rank<rest) start=rank*(local_N);  //distributing workload
    else start=rest+(rank*local_N);


    for (i = 0; i <local_N; i++)
    {
      A[N*i+(start+i)]=1; //row index always between 0 and local_N, col index depends on proc
    }
    
    if (rank!=0) //every rank except 0 send even overlapping, each has its own length local_N
    {
      MPI_Send(A,N*local_N,MPI_INT,0,101,MPI_COMM_WORLD);
    }

    if (rank==0) //0 receives them all
    {
      int row,col;
      for (row = 0; row < local_N; row++)
       {
        for (col = 0; col < N; col++)
        {
          fprintf(f,"%d ",A[col+row*N]);  //0 write its own part of the matrix
        }
        fprintf(f,"\n");
       }
    
      int* received;
      received =(int*)malloc(N*local_N*sizeof(int)); //received has the maximum local_N, so it's fine
      for (i = 1; i <npes; i++)
      {
        if(i==rest  && rest!=0) local_N=local_N-1;
        MPI_Recv(received,N*local_N,MPI_INT,i,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
        
        for (row = 0; row < local_N; row++)
        {
          for (col = 0; col < N; col++)
          {
            fprintf(f,"%d ",received[col+row*N]);
          }
          fprintf(f,"by rank %d\n", i);
        }
      }
      free(received);
    }

  free(A);

  MPI_Finalize();

  fclose(f);  
  return 0;  
}
