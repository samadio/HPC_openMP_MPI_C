module load impi-trial/5.0.1.035 
module load openmpi 
module load hwloc

cd /home/samadio/hpc/ex5/PingPong/nodes
for tries in 1 2 3 4 5 6 7 8 9 10; do
mpirun -np 2 --map-by ppr:1:node ./IMB-MPI1 PingPong >> ppr.txt

#mpirun -np 2 --map-by node IMB-MPI1 PingPong >> bynode.txt

done
exit
