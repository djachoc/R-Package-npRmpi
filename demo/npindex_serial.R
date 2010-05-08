## This is the serial version of npindex_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

## Generate some data

n <- 1000

set.seed(42)
x1 <- runif(n, min=-1, max=1)
x2 <- runif(n, min=-1, max=1)
y <- x1 - x2 + rnorm(n)

## A single index model example

t1 <- Sys.time()

bw <- npindexbw(formula=y~x1+x2)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(bw)

model <- npindex(bws=bw, gradients=TRUE)

summary(model)
