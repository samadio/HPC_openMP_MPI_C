cd /home/samadio/hpc/ex5/nodeperf

module load impi-trial/5.0.1.035
module load intel/14.0
module load mkl/11.1
module load openmpi/1.8.3/intel/14.0

export OMP_NUM_THREADS=20
export OMP_PLACES=cores

for try in $(seq 1 5); do
echo "Try number $try" >> results.txt
./nodeperf >>results.txt
done

exit
