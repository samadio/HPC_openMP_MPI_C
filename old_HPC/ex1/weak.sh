cd hpc/ex1/
echo "Weak scalability_test, base size=10^9" 		#$1 indica il primo parametro, che metti dopo il .x
module load openmpi
for procs in 1 2 4 8 16 20; do
# sync; echo 3 > /proc/sys/vm/drop_caches 
 echo "np=${procs}"
 /usr/bin/time mpirun -np ${procs} ./parallel.x 100000000 >> elapsweak 2>&1
 echo "------------------------------------------------" 
 done

#this is weak because in input there's 10^9 and the C program uses 10^9 * np, so the size of the problem increases along with the number of processors
