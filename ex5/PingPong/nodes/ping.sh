module load impi-trial/5.0.1.035 
module load openmpi/1.8.3/intel/14.0
module load hwloc
module load intel/14.0

cd /home/samadio/hpc/ex5/PingPong/nodes

#for tries in 1 2 3; do
mpirun -np 2 --map-by ppr:1:node recompiled_c_mpicc -iter 1000 PingPong >>RESULTS_1.txt
#done

exit
