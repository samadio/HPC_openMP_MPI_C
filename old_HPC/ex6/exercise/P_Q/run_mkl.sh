## a small script to execute my HPL benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd hpc/ex6/hpl-2.2/bin/mkl/P_Q

#load modules needed
module load mkl
module load openmpi/1.8.3/intel/14.0

#run the code

for try in 1 2 3; do
mpirun -np 20 ./xhpl >>p1_$try
done
exit
