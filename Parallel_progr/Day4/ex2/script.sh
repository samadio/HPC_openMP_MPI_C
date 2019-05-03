cd /home/samadio/hpc/Parallel_progr/Day4/ex1
module load openmpi

for p in 1 2 4 8 16 20;do
    echo "number of processes: $p">>results.txt
    mpirun -np $p ring.x >> results.txt
    echo " ">>results.txt
done
exit
