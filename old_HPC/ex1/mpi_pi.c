#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <mpi.h>
#define USE MPI
#define SEED 35791246
int main ( int argc , char *argv[ ] )
{
  // coordinates
   double x, y ;
 
   // number of points inside the circle
   long long int M, local_M ; 
   double pi ;
             
           // times 
   double start_time, end_time;   
   int myid , numprocs , proc ;
   MPI_Status status;
 
                       // master process
   int master = 0;
   int tag = 123;
 
   MPI_Init(&argc,&argv);
   MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
   MPI_Comm_rank(MPI_COMM_WORLD,&myid);
   if ( argc <=1) {
   	fprintf (stderr , " Usage : mpi -np n %s number_of_iterations \n", argv[0] ) ;
	MPI_Finalize() ;
        exit(-1) ;
    }
 
 long long int N = atoi(argv[1]);
                   // take time of processor one after I/O operation
  start_time = MPI_Wtime(); //ELAPSED TIME OF PROCESSOR, LIKE -TIME SYS

                                 // initialize random numbers 
  srand48(SEED*myid) ; // seed the number generator
  local_M=0;
  long long int i;
  for (i=0; i<N ; i++) {
           // take a point P(x,y) inside the unit square
 	 x = drand48(); 
         y = drand48();
                                                                    
  // check if the point P(x,y) is inside the circle
                                                                                         if ((x*x + y*y)<1)
  	       local_M++;
 	                                                                          }
                                                                                 if (myid ==0) { //if I am the master process gather results from others
 	                                                                                M = local_M ;
         	                                                                        for (proc=1; proc<numprocs ; proc++) {
 	   MPI_Recv(&local_M,1,MPI_LONG_LONG,proc,tag,MPI_COMM_WORLD,&status ) ;
           M += local_M ;
 	}
 	                                                                                pi = 4.0*M/(N*numprocs) ;
        	                                                                        end_time=MPI_Wtime();
                	                                                                printf ( "\n # of trials = %llu , estimate of pi is %1.9f \n", N*numprocs, pi ) ;
                        	                                                        printf ( "\n # walltime on master processor : %10.8f \n", end_time - start_time ) ;

}
                                                                                 else {   // for all the slave processes send results to the master /

    printf ( " Processor %d sending results = %llu to master process \n", myid, local_M) ;
                                                                                    MPI_Send(&local_M , 1 ,MPI_LONG_LONG, master , tag ,MPI_COMM_WORLD) ;
                                                                                }

                                                                                MPI_Finalize() ; // let MPI finish up /

                                                                                }

