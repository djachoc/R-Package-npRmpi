## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npindex_npRmpi. Check the time in the
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
## to the master node so no need to broadcast it)

n <- 1000

set.seed(42)
x1 <- runif(n, min=-1, max=1)
x2 <- runif(n, min=-1, max=1)
y <- x1 - x2 + rnorm(n)

mpi.bcast.Robj2slave(x1)
mpi.bcast.Robj2slave(x2)
mpi.bcast.Robj2slave(y)

## A single index model example

t1 <- Sys.time()

mpi.bcast.cmd(bw <- npindexbw(formula=y~x1+x2),
              caller.execute=TRUE)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(bw)

mpi.bcast.cmd(model <- npindex(bws=bw, gradients=TRUE),
              caller.execute=TRUE)

summary(model)

## Clean up properly then quit()

mpi.close.Rslaves()

mpi.quit()
