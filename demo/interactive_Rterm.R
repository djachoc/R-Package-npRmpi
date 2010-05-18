## This code can be run in real time inside the R terminal/console.
## It does not require that you have the .Rprofile file from
## npRmpi/inst/ in your current directory or home directory as we can
## load the npRmpi package in the standard manner.

library(npRmpi)

## Now we can spawn our slaves from within the R terminal manually. On
## a two core desktop we need an additional slave on top of the master
## node to allow both cores to run simultaneously.

mpi.spawn.Rslaves(nslaves=0#)

## Initialize master and slaves.

mpi.bcast.cmd(np.mpi.initialize(),
              caller.execute=TRUE)

## Turn off progress i/o as this clutters the output file (if you want
## to see search progress you can comment out this command)

## Load your data and broadcast it to all slave nodes

library(MASS)

mpi.bcast.cmd(set.seed(42),
              caller.execute=TRUE)
n <- 1000

rho <- 0.25
mu <- c(0,0)
Sigma <- matrix(c(1,rho,rho,1),2,2)
data <- mvrnorm(n=n, mu, Sigma)
mydat <- data.frame(x=data[,2],y=data[,1])

mpi.bcast.Robj2slave(mydat)

## A conditional density estimation example. 

t <- system.time(mpi.bcast.cmd(bw <- npcdensbw(y~x,
                                               bwmethod="cv.ml",
                                               data=mydat),
                               caller.execute=TRUE))

summary(bw)

t <- t + system.time(mpi.bcast.cmd(model <- npcdens(bws=bw),
                                   caller.execute=TRUE))

summary(model)

cat("Elapsed time =", t[3], "\n")

#mpi.bcast.cmd(plot(model),caller.execute=TRUE)

## Note - to exit you want to clean up properly then quit() via the
## following command (uncomment).

mpi.bcast.cmd(mpi.quit(),
              caller.execute=TRUE)
