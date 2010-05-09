## This is the serial version of npudens_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

## Generate some data

set.seed(42)
x <- rnorm(2500)

## A simple example with likelihood cross-validation

system.time(bw <- npudensbw(~x))

summary(bw)

