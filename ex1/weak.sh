echo "Weak scalability_test, base size=$1" 		\\$1 indica il primo parametro, che metti dopo il .x
for procs in 1 2 4 8 16 20 32 64 ; do
 echo "np=${procs}" 		
 usr/bin/time mpirun -np ${procs} ./parallel.x $1
 echo "------------------------------------------------"
 done
