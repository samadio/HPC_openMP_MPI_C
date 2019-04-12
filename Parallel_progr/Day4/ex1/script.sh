cd /home/samadio/hpc/Parallel_progr/Day4/ex1
module load openmpi

for p in 1 2 4 8 16 20 40;do
    mpirun -np $p ring.exe >> results.txt
done
exit
