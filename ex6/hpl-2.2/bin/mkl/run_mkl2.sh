## a small script to execute my HPL benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd hpc/ex6/hpl-2.2/bin/mkl

#load modules needed
module load mkl
module load openmpi/1.8.3/intel/14.0

#run the code

mpirun -np 20 ./xhpl

echo "---------------"
echo "---------------"
echo "---------------------------------------------------------------------------------"
echo "               NOW THE INTEL ONE	            "
echo "       "
echo "   "

#now the intel

./xlinpack_xeon64 lininput_xeon64

exit
