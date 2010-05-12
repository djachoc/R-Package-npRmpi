## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npconmode_npRmpi. Check the time in the
## output file foo.Rout (the name of this file with extension .Rout),
## then try with, say, 4 processors and compare run time.

## Initialize master and slaves.

mpi.bcast.cmd(np.mpi.initialize(),
              caller.execute=TRUE)

## Turn off progress i/o as this clutters the output file (if you want
## to see search progress you can comment out this command)

mpi.bcast.cmd(options(np.messages=FALSE),
              caller.execute=TRUE)

## Generate some data and broadcast it to all slaves (it will be known
## to the master node)

## A conditional mode example

library("MASS")
data("birthwt")

mpi.bcast.Robj2slave(birthwt)

t <- system.time(mpi.bcast.cmd(bw <- npcdensbw(factor(low)~factor(smoke)+ 
                                               factor(race)+ 
                                               factor(ht)+ 
                                               factor(ui)+    
                                               ordered(ftv)+  
                                               age+           
                                               lwt,           
                                               data=birthwt),
                               caller.execute=TRUE))

summary(bw)

t <- t + system.time(mpi.bcast.cmd(model <- npconmode(bws=bw),
                                   caller.execute=TRUE))

summary(model)

mpi.close.Rslaves()

cat("Elapsed time =", t[3], "\n")

mpi.quit()
