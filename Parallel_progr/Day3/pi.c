#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

double seconds()

/* Return the second elapsed since Epoch (00:00:00 UTC, January 1, 1970)                                                                     
 */

{

  struct timeval tmp;
  double sec;
  gettimeofday( &tmp, (struct timezone *)0 );
  sec = tmp.tv_sec + ((double)tmp.tv_usec)/1000000.0;
  return sec;

}


double f( double x){
    return 1.0/(1.0+x*x);
}


int main(int argc,char *argv[]){
  size_t N=10000000000;
  double h=1.0/(N);
  double pi=0.0;
  int rank = 0; // store the MPI identifier of the process
  int npes = 1; // store the number of MPI processes

  MPI_Init( &argc, &argv );
    double tstart=seconds();
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &npes );
    double local=0.0;
    size_t work=N/npes;
    size_t rest= N-N/npes*npes; //number of elements lost in division
    
    if(rank<rest){
      size_t start=rank*(work+1); //to rest procs i give one more element
      size_t end=start+work+1;
    }
    else{
      size_t start=rank*work+rest;
      size_t end=start+work;
    }
    

    //size_t start= rank*work;
    //size_t end=(rank+1)*work;
    //if(rank==npes-1){end=N;} //unbalanced work
    size_t i;
    for(i = start; i < end; i++)
    {
      local+=f((i*h)+h/2.0);
    }
    local=local*4*h;
    MPI_Reduce(&local,&pi,1,MPI_DOUBLE,MPI_SUM,npes-1,MPI_COMM_WORLD);
    double duration=seconds()-tstart;

    if(rank==npes-1){
      MPI_Send(&pi,1,MPI_DOUBLE,0,101,MPI_COMM_WORLD);
    }

    if(rank==0){
      MPI_Recv(&pi,1,MPI_DOUBLE,npes-1,101,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
      printf("%lf in %lf sec by proc %d\n", pi,duration,rank);
    }

  MPI_Finalize();


  return 0;  
}
