cd /home/samadio/hpc/ex5/stream

#single core: serial run

for try in 1 2 3 4 5;do
echo "try $try" >>singlecore.txt
echo " " >>singlecore.txt
echo " " >>singlecore.txt
./stream.x >> singlecore.txt
done

#same/diff socket for memory and core
for try in 1 2 3 4 5;do
echo "RUN NUMBER $try" | tee single_samesocket.txt single_diffsocket.txt
numactl --cpunodebind=0 --membind=0 ./stream.x >>single_samesocket.txt
numactl --cpunodebind=0 --membind=1 ./stream.x>>single_diffsocket.txt
done

exit
