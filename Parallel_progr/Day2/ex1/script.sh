module load gnu/4.8.3

for tries in 1 2 3 4 5;do
/home/samadio/hpc/Parallel_progr/Day2/ex1/serial >>/home/samadio/hpc/Parallel_progr/Day2/ex1/serial.txt
end do

for nth in 1 2 4 8 16 20; do
  export OMP_NUM_THREADS= nth
   for tries in 1 2 3 4 5; do
   	/home/samadio/hpc/Parallel_progr/Day2/ex1/parallel >>/home/samadio/hpc/Parallel_progr/Day2/ex1/parallel.txt
   end do
end do
