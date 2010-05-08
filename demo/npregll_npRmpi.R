## Make sure you have the .Rprofile file from npRmpi/inst/ in your
## current directory or home directory. It is necessary.

## To run this on systems with OPENMPI installed and working, try
## mpirun -np 2 R CMD BATCH npreg_npRmpi. Check the time in the output
## file foo.Rout (the name of this file with extension .Rout), then
## try with, say, 4 processors and compare run time.

## Initialize master and slaves.

mpi.bcast.cmd(np.mpi.initialize(),
              caller.execute=TRUE)

## Turn off progress i/o as this clutters the output file (if you want
## to see search progress you can comment out this command)

mpi.bcast.cmd(options(np.messages=FALSE),
              caller.execute=TRUE)

## Load your data and broadcast it to all slave nodes

data(wage1)
mpi.bcast.Robj2slave(wage1)

t1 <- Sys.time()

## A regression example (local linear)

mpi.bcast.cmd(bw <- npregbw(lwage~married+
                            female+
                            nonwhite+                
                            educ+
                            exper+
                            tenure,
                            regtype="ll",
                            bwmethod="cv.aic",
                            nmulti=1,
                            data=wage1),
              caller.execute=TRUE)

summary(bw)

mpi.bcast.cmd(model <- npreg(bws=bw),
              caller.execute=TRUE)

t2 <- Sys.time()

as.numeric((t2-t1),units="secs")

summary(model)

## Clean up properly then quit()

mpi.close.Rslaves()

mpi.quit()
