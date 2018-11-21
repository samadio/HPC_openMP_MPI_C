## a small script to execute my HPL benchamrk

/bin/hostname #name of the node which is executing my job
#enter in the right position
cd hpc/ex6/hpl-2.2/bin/mkl/nthreads

#load modules needed
module load mkl
module load openmpi/1.8.3/intel/14.0

#run the code
for nproc in 1 2 4 5 10 20; do
echo "nproc=${nproc}"
echo " "
echo " "
export OMP_NUM_THREADS=$((20/nproc));
mem=$((64512/nproc));

#setting P (and Q)for every number of processes
case proc in
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
		echo "don\'t know"
	;;
esac

Q=$((np/P));

sed -i -e "s/64512/$mem/g" HPL.dat #replace memory asked with mem variable
#replace P and Q line:
sed -i '11/.*/$P            Ps/' HPL.dat
sed -i '12/.*/$Q            Qs/' HPL.dat
#and hopefully...

echo " "
echo " "
echo "-----------------------------------------------------------"
echo " "
echo " "
mpirun -np ${nproc} ./xhpl
done
exit

