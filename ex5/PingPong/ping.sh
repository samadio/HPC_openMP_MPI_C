module load impi-trial/5.0.1.035 
module load openmpi 
module load hwloc

filename=$(echo "samesocket$1.txt")
for tries in 1 2 3; do
mpirun -np 2 hwloc-bind core:0 core:1 IMB-MPI1 PingPong >>~/hpc/ex5/PingPong/$filename
done



filename=$(echo "diffsocket$1.txt")
for tries in 1 2 3; do
mpirun -np 2 hwloc-bind core:0 core:13 IMB-MPI1 PingPong >>~/hpc/ex5/PingPong/$filename
done

exit
