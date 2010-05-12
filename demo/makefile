all:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R
	grep "time = " npudens*.Rout
	grep Objective npudens*.Rout

	R CMD BATCH --vanilla npregll_serial.R
	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R
	grep "time = " npregll*.Rout
	grep Objective npregll*.Rout
	grep squared npregll*.Rout

	R CMD BATCH --vanilla npreglc_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R
	grep "time = " npreglc*.Rout
	grep Objective npreglc*.Rout
	grep squared npreglc*.Rout

	R CMD BATCH --vanilla npindex_serial.R
	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R
	grep "time = " npindex*.Rout
	grep Objective npindex*.Rout

	R CMD BATCH --vanilla npscoef_serial.R
	mpirun -np 2 R CMD BATCH --no-save npscoef_npRmpi.R
	grep "time = " npscoef*.Rout
	grep Objective npscoef*.Rout

	R CMD BATCH --vanilla npcdensml_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensml_npRmpi.R
	grep "time = " npcdensml*.Rout
	grep Objective npcdensml*.Rout

	R CMD BATCH --vanilla npcdensls_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensls_npRmpi.R
	grep "time = " npcdensls*.Rout
	grep Objective npcdensls*.Rout

	R CMD BATCH --vanilla npconmode_serial.R
	mpirun -np 2 R CMD BATCH --no-save npconmode_npRmpi.R
	grep "time = " npconmode*.Rout
	grep Objective npconmode*.Rout

npudens:

	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R
	R CMD BATCH --vanilla npudens_serial.R
	grep "time = " npudens*.Rout
	grep Objective npudens*.Rout

npcdensml:

	mpirun -np 2 R CMD BATCH --no-save npcdensml_npRmpi.R
	R CMD BATCH --vanilla npcdensml_serial.R
	grep "time = " npcdensml*.Rout
	grep Objective npcdensml*.Rout

npcdensls:

	mpirun -np 2 R CMD BATCH --no-save npcdensls_npRmpi.R
	R CMD BATCH --vanilla npcdensls_serial.R
	grep "time = " npcdensls*.Rout
	grep Objective npcdensls*.Rout

npconmode:

	mpirun -np 2 R CMD BATCH --no-save npconmode_npRmpi.R
	R CMD BATCH --vanilla npconmode_serial.R
	grep "time = " npconmode*.Rout
	grep Objective npconmode*.Rout

npregll:

	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R
	R CMD BATCH --vanilla npregll_serial.R
	grep "time = " npregll*.Rout
	grep Objective npregll*.Rout
	grep squared npregll*.Rout

npreglc:

	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R
	R CMD BATCH --vanilla npreglc_serial.R
	grep "time = " npreglc*.Rout
	grep Objective npreglc*.Rout
	grep squared npreglc*.Rout

npindex:

	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R
	R CMD BATCH --vanilla npindex_serial.R
	grep "time = " npindex*.Rout
	grep Objective npindex*.Rout

npscoef:

	mpirun -np 2 R CMD BATCH --no-save npscoef_npRmpi.R
	R CMD BATCH --vanilla npscoef_serial.R
	grep "time = " npscoef*.Rout
	grep Objective npscoef*.Rout
