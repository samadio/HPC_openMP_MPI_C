cd hpc/ex1/
echo "Strong Scalability test, base size=$1"
module load openmpi
for procs in 1 2 4 8 16 20; do
 echo "np=${procs}"
  /usr/bin/time mpirun -np ${procs} ./parallel.x $(( 100000000 / ${procs} )) >> strongelaps
   echo "------------------------------------------------"
    done
#this is strong because we give N/np in input and it computes for N*np=> it's always N, the same work for increasing number of processors
