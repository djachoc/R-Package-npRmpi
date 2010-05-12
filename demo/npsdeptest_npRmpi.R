## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npsdeptest_npRmpi. Check the time in the
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

set.seed(42)

## A function to create a time series

ar.series <- function(phi,epsilon) {
  n <- length(epsilon)
  series <- numeric(n)
  series[1] <- epsilon[1]/(1-phi)
  for(i in 2:n) {
    series[i] <- phi*series[i-1] + epsilon[i]
  }
  return(series)
}

n <- 1000

## Stationary persistent time-series

yt <- ar.series(0.95,rnorm(n))

mpi.bcast.Robj2slave(yt)

## A simple example with likelihood cross-validation

t <- system.time(mpi.bcast.cmd(output <- npsdeptest(yt,
                                                    lag.num=2,
                                                    boot.num=399,
                                                    method="summation"),
                               caller.execute=TRUE))

output

## Clean up properly then quit()

mpi.close.Rslaves()

cat("Elapsed time =", t[3], "\n")

mpi.quit()
