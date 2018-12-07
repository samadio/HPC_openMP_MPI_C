module load impi-trial/5.0.1.035 
module load openmpi/1.8.3/intel/14.0
module load hwloc
module load intel/14.0

cd /home/samadio/hpc/ex5/PingPong/nodes

#for tries in 1 2 3; do
mpirun  -hostfile  hosts recompiled_c_mpicc -map 1x2 -multi 0 PingPong >>RESULTS_2.txt

#done

exit
