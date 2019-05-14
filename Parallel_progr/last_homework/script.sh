module load cudatoolkit/10.0
cd /home/samadio/hpc/Parallel_progr/last_homework
for tries in 1 2 3 4 5; do
./padding.x >> /home/samadio/hpc/Parallel_progr/last_homework/results_1024.txt
print " " >> results_1024.txt
done

exit
