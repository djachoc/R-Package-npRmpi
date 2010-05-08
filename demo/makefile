all:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

	R CMD BATCH --vanilla npcdens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdens_npRmpi.R

	R CMD BATCH --vanilla npregll_serial.R
	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R

	R CMD BATCH --vanilla npreglc_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R

	R CMD BATCH --vanilla npindex_serial.R
	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R

npudens:

	R CMD BATCH --vanilla npudens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npudens_npRmpi.R

npcdens:

	R CMD BATCH --vanilla npcdens_serial.R
	mpirun -np 2 R CMD BATCH --no-save npcdens_npRmpi.R

npregll:

	R CMD BATCH --vanilla npregll_serial.R
	mpirun -np 2 R CMD BATCH --no-save npregll_npRmpi.R

npreglc:

	R CMD BATCH --vanilla npreglc_serial.R
	mpirun -np 2 R CMD BATCH --no-save npreglc_npRmpi.R

npindex:

	R CMD BATCH --vanilla npindex_serial.R
	mpirun -np 2 R CMD BATCH --no-save npindex_npRmpi.R
