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
mem=$((64512*20/nproc));

P=1
#setting P (and Q)for every number of processes
case $nproc in
	1)
		let P=1
	;;
	2)
		let P=2
	;;
	4)
		let P=2
	;;
	5)
                let P=5
        ;;
        10)
                let P=5
        ;;
        20)
        	let P=5
       	;;
	*)
		echo "don\'t know"
	;;
esac

Q=$((nproc/P));
sed -i '6\/.*/\"$mem        Ns\"/g' HPL.dat
#sed -i -e "6/.*/$mem      Ns/" HPL.dat #replace memory asked with mem variable
#replace P and Q line:
#sed -i '11/.*/\"$P            Ps\"/' HPL.dat
#sed -i '12/.*/$Q            Qs/g' HPL.dat
#and hopefully...

echo " "
echo " "
echo "-----------------------------------------------------------"
echo " "
echo " "
mpirun -np ${nproc} ./xhpl
done
exit

