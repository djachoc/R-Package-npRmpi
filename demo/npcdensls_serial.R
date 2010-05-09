## This is the serial version of npcdens_npRmpi.R for comparison
## purposes (bandwidth ought to be identical, timing may
## differ). Study the differences between this file and its MPI
## counterpart for insight about your own problems.

library(np)
options(np.messages=FALSE)

data(wage1)

t1 <- Sys.time()

## A simple example with least-squares cross-validation

bw <- npcdensbw(lwage~married+
                female+
                nonwhite+                
                educ+
                exper+
                tenure,
                bwmethod="cv.ls",
                nmulti=1,
                data=wage1)

summary(bw)

model <- npcdens(bws=bw)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(model)

