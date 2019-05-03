#module load
module load gnu/4.9.2

#do 5 tries for the serial case
#for tries in 1 2 3 4 5; do
#echo ${tries} >> /home/samadio/hpc/Parallel_progr/Day2/ex1/serial.txt
#/home/samadio/hpc/Parallel_progr/Day2/ex1/serial >>/home/samadio/hpc/Parallel_progr/Day2/ex1/serial.txt
#done

for n in 1 2 4 8 16 20; do
  #set number of threads
  export OMP_NUM_THREADS=$n
  echo $n >> /home/samadio/hpc/Parallel_progr/Day2/ex1/red10.txt
  #5 iterations for each number of threads
  for tries in 1; do
   	/home/samadio/hpc/Parallel_progr/Day2/ex1/red >>/home/samadio/hpc/Parallel_progr/Day2/ex1/red10.txt
   done
   
done

exit
