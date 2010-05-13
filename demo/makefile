all:

	mpirun -np $(np) R CMD BATCH --no-save npudens_npRmpi.R
	grep "time = " npudens*.Rout
	grep Objective npudens*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npregll_npRmpi.R
	grep "time = " npregll*.Rout
	grep Objective npregll*.Rout
	grep squared npregll*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npreglc_npRmpi.R
	grep "time = " npreglc*.Rout
	grep Objective npreglc*.Rout
	grep squared npreglc*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npindex_npRmpi.R
	grep "time = " npindex*.Rout
	grep Objective npindex*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npscoef_npRmpi.R
	grep "time = " npscoef*.Rout
	grep Objective npscoef*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npcdensml_npRmpi.R
	grep "time = " npcdensml*.Rout
	grep Objective npcdensml*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npcdensls_npRmpi.R
	grep "time = " npcdensls*.Rout
	grep Objective npcdensls*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npconmode_npRmpi.R
	grep "time = " npconmode*.Rout
	grep Objective npconmode*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npcmstest_npRmpi.R
	grep "time = " npcmstest*.Rout
	grep "Test Statistic" npcmstest*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npsigtest_npRmpi.R
	grep "time = " npsigtest*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npsdeptest_npRmpi.R
	grep "time = " npsdeptest*.Rout
	grep "Test Statistic" npsdeptest*.Rout

npudens:

	mpirun -np $(np) R CMD BATCH --no-save npudens_npRmpi.R
	grep "time = " npudens*.Rout
	grep Objective npudens*.Rout

npcdensml:

	mpirun -np $(np) R CMD BATCH --no-save npcdensml_npRmpi.R
	grep "time = " npcdensml*.Rout
	grep Objective npcdensml*.Rout

npcdensls:

	mpirun -np $(np) R CMD BATCH --no-save npcdensls_npRmpi.R
	grep "time = " npcdensls*.Rout
	grep Objective npcdensls*.Rout

npconmode:

	mpirun -np $(np) R CMD BATCH --no-save npconmode_npRmpi.R
	grep "time = " npconmode*.Rout
	grep Objective npconmode*.Rout

npcmstest:

	mpirun -np $(np) R CMD BATCH --no-save npcmstest_npRmpi.R
	grep "time = " npcmstest*.Rout
	grep "Test Statistic" npcmstest*.Rout

npsigtest:

	mpirun -np $(np) R CMD BATCH --no-save npsigtest_npRmpi.R
	grep "time = " npsigtest*.Rout

npsdeptest:

	mpirun -np $(np) R CMD BATCH --no-save npsdeptest_npRmpi.R
	grep "time = " npsdeptest*.Rout
	grep "Test Statistic" npsdeptest*.Rout

npregll:

	mpirun -np $(np) R CMD BATCH --no-save npregll_npRmpi.R
	grep "time = " npregll*.Rout
	grep Objective npregll*.Rout
	grep squared npregll*.Rout

npreglc:

	mpirun -np $(np) R CMD BATCH --no-save npreglc_npRmpi.R
	grep "time = " npreglc*.Rout
	grep Objective npreglc*.Rout
	grep squared npreglc*.Rout

npindex:

	mpirun -np $(np) R CMD BATCH --no-save npindex_npRmpi.R
	grep "time = " npindex*.Rout
	grep Objective npindex*.Rout

npscoef:

	mpirun -np $(np) R CMD BATCH --no-save npscoef_npRmpi.R
	grep "time = " npscoef*.Rout
	grep Objective npscoef*.Rout

clean:

	rm *.out *.Rout *~
