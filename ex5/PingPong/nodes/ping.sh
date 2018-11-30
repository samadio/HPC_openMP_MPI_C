module load impi-trial/5.0.1.035 
module load hwloc

cd /home/samadio/hpc/ex5/PingPong/nodes
#for tries in 1 2 3 4 5 6 7 8 9 10; do
#mpirun -np 2 -ppn 1 ./IMB-MPI1 PingPong >> ppn.txt

mpirun -np 40  --map-by ppr:20:node hostname >> np40ppn20.txt
#mpirun -np 2 --map-by node IMB-MPI1 PingPong >> bynode.txt

#done
exit
