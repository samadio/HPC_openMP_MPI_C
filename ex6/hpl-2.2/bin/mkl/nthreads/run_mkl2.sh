## a small script to execute my benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd hpc/ex6/hpl-2.2/bin/mkl/nthreads

#load modules needed
module load mkl
module load openmpi/1.8.3/intel/14.0

#now the intel
export OMP_NUM_THREADS=5
mpirun -np 4 ./xlinpack_xeon64 lininput_xeon64

exit
