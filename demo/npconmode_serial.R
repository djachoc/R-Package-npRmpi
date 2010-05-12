## This is the serial version of npudens_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

library("MASS")
data("birthwt")

## A conditional mode example

t <- system.time(bw <- npcdensbw(factor(low)~factor(smoke)+ 
                                 factor(race)+ 
                                 factor(ht)+ 
                                 factor(ui)+    
                                 ordered(ftv)+  
                                 age+           
                                 lwt,           
                                 data=birthwt))

summary(bw)

model <- npconmode(bws=bw)

summary(model)

cat("Elapsed time =", t[3], "\n")
