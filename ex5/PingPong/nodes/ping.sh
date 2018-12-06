module load impi-trial/5.0.1.035 
module load openmpi/1.8.3/intel/14.0
module load hwloc
module load intel/14.0

#filename=$(echo "diffsocket$1.txt")
#for tries in 1 2 3; do
mpirun -np 2 IMB-MPI1 -map 1x2 -multi 0 PingPong
#done

exit
