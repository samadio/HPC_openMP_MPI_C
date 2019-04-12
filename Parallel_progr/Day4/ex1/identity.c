#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc,char *argv[]){
  int rank = 0; 
  int npes = 1;
  int N=5; //global rows
  
  MPI_Init( &argc, &argv );
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &npes );
    int local_N=N/npes ; //local numb of rows; 
    int rest=N-(local_N*npes);

    if(rank<rest) local_N+=1;

    //allocate a matrix with local_N rows and N cols
    int **A=(int**)malloc(local_N*sizeof(int*));
    int** received;
    
    if(rank==0) received=(int**)malloc(local_N*sizeof(int*));   //only proc0 reserves memory
    
    int i,start;

    for (i = 0; i < local_N; i++)
    {
      A[i]=(int*)calloc(N,sizeof(int));
      if (rank==0) received[i]=(int*)malloc(N*sizeof(int)); //only proc0 reserves memory part2
    }
    
    if(rank<rest) start=rank*(local_N);  //distributing workload
    else start=rest+(rank*local_N);


    int row,col;
    for (i = 0; i <local_N; i++)
    {
      A[i][start+i]=1; //row index always between 0 and local_N, col index depends on proc
    }
    
    MPI_Request req;
    
    FILE *f = fopen("identity.txt", "a"); //output file


    if (rank!=0) //every rank except 0 send even overlapping, each has its own length local_N
    {
      MPI_Isend(A,N*local_N,MPI_INT,0,101,MPI_COMM_WORLD,&req);
    }
    

    if (rank==0) //0 receives them all
    {
      int row,col;
      for (row = 0; row < local_N; row++)
        {
          for (col = 0; col < N; col++)
          {
            fprintf(f,"%d ",A[row][col]);  //0 write its own part of the matrix
          }
          fprintf(f,"\n");
        }

      for (i = 1; i < npes; i++)
      {
        if(i==rest) local_N=local_N-1;
        MPI_Recv(received,N*local_N,MPI_INT,i,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);//&req);
        //MPI_Wait(&req,MPI_STATUS_IGNORE); //this way received can not be overwritten by another receive

        for (row = 0; row < local_N; row++)
        {
          for (col = 0; col < N; col++)
          {
            fprintf(f,"%d ",received[row][col]);
          }
          fprintf(f,"\n");
        }
      }
      
    }
    
    fclose(f);  

  MPI_Finalize();


  return 0;  
}
