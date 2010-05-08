all:

	rm .Rprofile
	R CMD BATCH --vanilla npudens_serial.R
	R CMD BATCH --vanilla npreg_serial.R
	cp ../inst/Rprofile .Rprofile
	mpirun -np 2 R CMD BATCH --vanilla npudens_npRmpi.R
	mpirun -np 2 R CMD BATCH --vanilla npreg_npRmpi.R
