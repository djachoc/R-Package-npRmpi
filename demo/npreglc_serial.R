## This is the serial version of npreg_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

data(wage1)
attach(wage1)

## A regression example (local constant)

system.time(bw <- npregbw(lwage~married+
                          female+
                          nonwhite+                
                          educ+
                          exper+
                          tenure,
                          regtype="lc",
                          bwmethod="cv.aic",
                          data=wage1))

summary(bw)

model <- npreg(bws=bw)

summary(model)

