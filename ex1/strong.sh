echo "Strong Scalability test, base size=$1"
for procs in 1 2 4 8 16 20 32 64 ; do
 echo "np=${procs}"
  /usr/bin/time mpirun -np ${procs} ./parallel.x $(($1/${procs}))
   echo "------------------------------------------------"
    done
