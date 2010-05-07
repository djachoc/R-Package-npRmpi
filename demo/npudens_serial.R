## This is the serial version of npudens_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)

## Generate some data and broadcast it to all slaves (it is known to
## the master node)

set.seed(123)
x <- rnorm(2500)

t1 <- Sys.time()

## A simple example with likelihood cross-validation

bw <- npudensbw(~x)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(bw)

