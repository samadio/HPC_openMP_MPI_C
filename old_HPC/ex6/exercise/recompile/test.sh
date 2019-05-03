## a small script to execute my HPL benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd /home/samadio/hpc/ex6/exercise/recompile

#load modules needed
module load impi-trial/5.0.1.035
module load mkl

#run the code
#for nproc in 1 2 4 5 10 20; do
export nproc=2
echo "nproc=${nproc}"
echo " "
echo " "

export OMP_DYNAMIC=FALSE
export MKL_NUM_THREADS=2
export OMP_NUM_THREADS=2
export KMP_NUM_THREADS=2

P=1
#setting P (and Q)for every number of processes
case $nproc in
	1)
		P=1
	;;
	2)
		P=2
	;;
	4)
		P=2
	;;
	5)
                P=5
        ;;
        10)
                P=5
        ;;
        20)
        	P=5
       	;;
	*)
		echo  "don\'t know"
	;;
esac

Q=$((nproc/P));

#replace the N line

	#sed -i '6 c '${mem}'         Ns' HPL.dat

#replace P and Q line:

sed -i '11 c '${P}'         Ps' HPL.dat
sed -i '12 c '${Q}'         Qs' HPL.dat
#and hopefully...

echo " "
echo " "
echo "-----------------------------------------------------------"
echo " "
echo " "

mpirun -np ${nproc} ./recompiled_static
#done
exit
