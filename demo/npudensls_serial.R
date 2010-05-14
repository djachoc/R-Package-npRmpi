## This is the serial version of npudensls_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

## Generate some data

n <- 2500

mpi.bcast.cmd(set.seed(42),
              caller.execute=TRUE)

x <- rnorm(n)

## A simple example with likelihood cross-validation

t <- system.time(bw <- npudensbw(~x,
                                 bwmethod="cv.ls"))

summary(bw)

cat("Elapsed time =", t[3], "\n")
