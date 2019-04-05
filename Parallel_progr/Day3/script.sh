cd /home/samadio/hpc/Parallel_progr/Day3
module load openmpi

for p in 1 2 4 8 16 20 40;do
  for tries in 1 2;do
    mpirun -np $p ./a.out >> results.txt
  done
  echo ""
done
exit
