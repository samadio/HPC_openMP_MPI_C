serial = read.table("~/Desktop/DSSC/Ulysses/ex1/results/piserial", quote="\"", comment.char="")
strong = read.table("~/Desktop/DSSC/Ulysses/ex1/results/strongtime", quote="\"", comment.char="")
weak= read.table("~/Desktop/DSSC/Ulysses/ex1/results/weaktime", quote="\"")

speedstrong=c()
speedstrong$x=c(1,2,4,8,16,20)
speedstrong$y=serial$V1/strong$V2

plot(speedstrong, type= "b",xlab="np",ylab="strong speedup",col="red")
plot(weak, type= "b", xlab="np",ylab="weak elapsed time", col="blue",ylim=c(0,23))
fitstrong=lm(y~.,data=speedstrong)

effstrong=c()
effstrong$x=speedstrong$x
effstrong$y=speedstrong$y/speedstrong$x

plot(effstrong, type= "b",xlab="np",ylab="strong efficiency",col="red")