## This is the serial version of npcdensml_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

library(MASS)
set.seed(42)
n <- 1000
rho <- 0.25
mu <- c(0,0)
Sigma <- matrix(c(1,rho,rho,1),2,2)
data <- mvrnorm(n=n, mu, Sigma)
y <- data[,1]
x <- data[,2]

## A simple example with least-squares cross-validation

t <- system.time(bw <- npcdensbw(y~x,
                                 bwmethod="cv.ml"))

summary(bw)

t <- t + system.time(model <- npcdens(bws=bw))

summary(model)

cat("Elapsed time =", t[3], "\n")

