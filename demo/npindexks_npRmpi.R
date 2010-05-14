## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npindexks_npRmpi. Check the time in the
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

n <- 2500

set.seed(42)

x <- rchisq(n, df=3)
x1 <- (ifelse(x < 6, x, 6) - 2.348)/1.511
x <- rnorm(n)
x2 <- ifelse(abs(x) < 2 , x, 2) / 0.8796
y <- ifelse(x1 + x2 + rnorm(n) > 0, 1, 0)

mpi.bcast.Robj2slave(x1)
mpi.bcast.Robj2slave(x2)
mpi.bcast.Robj2slave(y)

## A single index model example (Klein & Spady, binary y)

t <- system.time(mpi.bcast.cmd(bw <- npindexbw(formula=y~x1+x2,
                                               method="kleinspady"),
                               caller.execute=TRUE))

summary(bw)

t <- t + system.time(mpi.bcast.cmd(model <- npindex(bws=bw, gradients=TRUE),
                                   caller.execute=TRUE))

summary(model)

## Clean up properly then quit()

mpi.close.Rslaves()

cat("Elapsed time =", t[3], "\n")

mpi.quit()