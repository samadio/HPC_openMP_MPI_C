#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc,char *argv[]){
  int rank = 0; 
  int npes = 1;
  int N=7; //global 
  //FILE *f = fopen("identity.txt", "a"); //output file
  
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


    int row,col;
    for (i = 0; i <local_N; i++)
    {
      A[i+N*(start+i)]=1; //row index always between 0 and local_N, col index depends on proc
    }
    
    MPI_Request req;


    if (rank!=0) //every rank except 0 send even overlapping, each has its own length local_N
    {
      MPI_Isend(&A,N*local_N,MPI_INT,0,101,MPI_COMM_WORLD,&req);
    }

    if (rank==0) //0 receives them all
    {
      int row,col;
      for (row = 0; row < local_N; row++)
        {
          for (col = 0; col < N; col++)
          {
            printf("%d ",A[col+row*N]);  //0 write its own part of the matrix
          }
          printf("\n");
        }

      int* received;
      for (i = 1; i <npes; i++)
      {
        if(i==rest) local_N=local_N-1;
        received =(int*)malloc(N*local_N*sizeof(int));
        MPI_Recv(&received,N*local_N,MPI_INT,i,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);//&req);
        
        //MPI_Wait(&req,MPI_STATUS_IGNORE); //this way received can not be overwritten by another receive

        
        for (row = 0; row < local_N; row++)
        {
          for (col = 0; col < N; col++)
          {
            printf("%d ",received[col+row*N]);
          }
          printf("by rank %d\n", i);
        }
        free(received);
      }
    }

    free(A);

  MPI_Finalize();

//  fclose(f);  
  return 0;  
}
