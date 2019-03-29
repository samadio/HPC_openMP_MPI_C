module load gcc/4.8.2 

export OMP_NUM_THREADS=10

for tries in 1 2 3 4 5 6 7 8 9 10; do
/home/samadio/hpc/Parallel_progr/Day2/ex2/loop >> /home/samadio/hpc/Parallel_progr/Day2/ex2/dynamic.txt
done

exit
