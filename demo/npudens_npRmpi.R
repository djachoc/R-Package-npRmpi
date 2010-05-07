## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npRmpi. Check the time in the output file
## foo.Rout (the name of this file with extension .Rout), then try
## with, say, 4 processors and compare run time.

## Initialize master and slaves.

mpi.bcast.cmd(np.mpi.initialize(),
              caller.execute=TRUE)

## Generate some data and broadcast it to all slaves (it is known to
## the master node)

set.seed(123)
x <- rnorm(2500)
mpi.bcast.Robj2slave(x)

t1 <- Sys.time()

## A simple example with likelihood cross-validation

mpi.bcast.cmd(bw <- npudensbw(~x),
              caller.execute=TRUE)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(bw)

## Clean up properly then quit()

mpi.close.Rslaves()

mpi.quit()
