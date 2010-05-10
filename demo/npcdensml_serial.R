## This is the serial version of npcdens_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

data(wage1)

## A simple example with likelihood cross-validation

system.time(bw <- npcdensbw(lwage~married+
                            female+
                            nonwhite+                
                            educ+
                            exper+
                            tenure,
                            data=wage1))

summary(bw)

model <- npcdens(bws=bw)

summary(model)

