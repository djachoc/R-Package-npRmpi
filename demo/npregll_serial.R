## This is the serial version of npreg_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

data(wage1)
attach(wage1)

t1 <- Sys.time()

## A regression example (local linear)

bw <- npregbw(lwage~married+
              female+
              nonwhite+                
              educ+
              exper+
              tenure,
              regtype="ll",
              bwmethod="cv.aic",
              nmulti=1,
              data=wage1)

summary(bw)

model <- npreg(bws=bw)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(model)

