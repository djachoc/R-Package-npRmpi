all:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

	R CMD BATCH --vanilla npcdensml_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensml_npRmpi.R

	R CMD BATCH --vanilla npcdensls_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensls_npRmpi.R

	R CMD BATCH --vanilla npregll_serial.R
	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R

	R CMD BATCH --vanilla npreglc_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R

	R CMD BATCH --vanilla npindex_serial.R
	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R

	R CMD BATCH --vanilla npscoef_serial.R
	mpirun -np 2 R CMD BATCH --no-save npscoef_npRmpi.R

npudens:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

npcdensml:

	R CMD BATCH --vanilla npcdensml_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensml_npRmpi.R

npcdensls:

	R CMD BATCH --vanilla npcdensls_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdensls_npRmpi.R

npregll:

	R CMD BATCH --vanilla npregll_serial.R
	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R

npreglc:

	R CMD BATCH --vanilla npreglc_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R

npindex:

	R CMD BATCH --vanilla npindex_serial.R
	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R

npscoef:

	R CMD BATCH --vanilla npscoef_serial.R
	mpirun -np 2 R CMD BATCH --no-save npscoef_npRmpi.R
