all:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

	R CMD BATCH --vanilla npreg_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreg_npRmpi.R

npudens:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

npreg:

	R CMD BATCH --vanilla npreg_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreg_npRmpi.R
