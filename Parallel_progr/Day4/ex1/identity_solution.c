#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc,char *argv[]){
  int rank = 0; 
  int npes = 1;
  int N=8; //global 
  FILE *f = fopen("identity.txt", "w"); //output file

//////////////No rest//////////////////

  MPI_Init( &argc, &argv );
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &npes );
    int local_N=N/npes ; //local numb of rows; 
   
    if(rank<rest) local_N+=1;

    //allocate a matrix with local_N rows and N cols
    int *A=(int*)calloc(local_N*N,sizeof(int));
    
    int i,j,start;
    
    if(rank<rest) start=rank*(local_N);  //distributing workload
    else start=rest+(rank*local_N);

    //for no rest, i_global=i+(rank*local_N)
    for (i = 0; i <local_N; i++)
    {
        for ( j = 0; j <N; j++)
        {
            if(i_global==j)A[i][j]=1;
        }        
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
///////////////////////////////////overlapping/////////////////////


///every process has its own A

if(rank==0){
    int* buffer=(int*) malloc(local_N*N*sizeof(int));
    int count;
    MPI_Request req;
         for(count=1; count<=npes;count++){   
            MPI_Irecv(buffer,N*local_N,MPI_INT,count,101,MPI_COMM_WORLD,&req);
            print(A); 
            MPI_Wait(&req,MPI_STATUS_IGNORE);
            //copy(A,buffer)
            //or just swap pointers
            swap(A,buffer);
         }
         print(A); //last print missing
}
