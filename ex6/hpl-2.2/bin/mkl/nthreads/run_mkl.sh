## a small script to execute my HPL benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd hpc/ex6/hpl-2.2/bin/mkl/nthreads

#load modules needed
module load mkl
module load openmpi/1.8.3/intel/14.0

#run the code
for nproc in 1 2 4 5 10 20; do
echo "nproc=${nproc}"
echo " "
echo " "
export OMP_NUM_THREADS=$((20/nproc));
mem=$((64512/OMP_NUM_THREADS));
sed -i -e "s/64512/$mem/g" HPL.dat
mpirun -np ${nproc} ./xhpl 
done
exit

#for procs in 1 2 4 8 16 20; do
# echo "np=${procs}"
#  /usr/bin/time mpirun -np ${procs} ./parallel.x 1000000000 | grep "walltime" | $
#   echo "------------------------------------------------" 
#    done
