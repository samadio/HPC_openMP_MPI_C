cd hpc/ex1/
echo "Weak scalability_test, base size=1000000000" 		#$1 indica il primo parametro, che metti dopo il .x
for procs in 1 2 4 8 16 20; do
# sync; echo 3 > /proc/sys/vm/drop_caches  
 echo "np=${procs}" 		
 /usr/bin/time mpirun -np ${procs} ./parallel.x 1000000000
 echo "------------------------------------------------"
 done

