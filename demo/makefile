all:

	mpirun -np $(np) R CMD BATCH --no-save npudensml_npRmpi.R
	grep "time = " npudensml*.Rout
	grep Objective npudensml*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npudensls_npRmpi.R
	grep "time = " npudensls*.Rout
	grep Objective npudensls*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npregll_npRmpi.R
	grep "time = " npregll*.Rout
	grep Objective npregll*.Rout
	grep squared npregll*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npreglc_npRmpi.R
	grep "time = " npreglc*.Rout
	grep Objective npreglc*.Rout
	grep squared npreglc*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npindexich_npRmpi.R
	grep "time = " npindexich*.Rout
	grep Objective npindexich*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npindexks_npRmpi.R
	grep "time = " npindexks*.Rout
	grep Objective npindexks*.Rout

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

	mpirun -np $(np) R CMD BATCH --no-save npdeptest_npRmpi.R
	grep "time = " npdeptest*.Rout
	grep "Test Statistic" npdeptest*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npunitest_npRmpi.R
	grep "time = " npunitest*.Rout
	grep "Test Statistic" npunitest*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npdeneqtest_npRmpi.R
	grep "time = " npdeneqtest*.Rout
	grep "Test Statistic" npdeneqtest*.Rout

	mpirun -np $(np) R CMD BATCH --no-save npqreg_npRmpi.R
	grep "time = " npqreg*.Rout
	grep Objective npqreg*.Rout

npudensml:

	mpirun -np $(np) R CMD BATCH --no-save npudensml_npRmpi.R
	grep "time = " npudensml*.Rout
	grep Objective npudensml*.Rout

npudensls:

	mpirun -np $(np) R CMD BATCH --no-save npudensls_npRmpi.R
	grep "time = " npudensls*.Rout
	grep Objective npudensls*.Rout

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

npdeptest:

	mpirun -np $(np) R CMD BATCH --no-save npdeptest_npRmpi.R
	grep "time = " npdeptest*.Rout
	grep "Test Statistic" npdeptest*.Rout

npunitest:

	mpirun -np $(np) R CMD BATCH --no-save npunitest_npRmpi.R
	grep "time = " npunitest*.Rout
	grep "Test Statistic" npunitest*.Rout

npdeneqtest:

	mpirun -np $(np) R CMD BATCH --no-save npdeneqtest_npRmpi.R
	grep "time = " npdeneqtest*.Rout
	grep "Test Statistic" npdeneqtest*.Rout

npqreg:

	mpirun -np $(np) R CMD BATCH --no-save npqreg_npRmpi.R
	grep "time = " npqreg*.Rout
	grep Objective npqreg*.Rout

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

npindexich:

	mpirun -np $(np) R CMD BATCH --no-save npindexich_npRmpi.R
	grep "time = " npindexich*.Rout
	grep Objective npindexich*.Rout

npindexks:

	mpirun -np $(np) R CMD BATCH --no-save npindexks_npRmpi.R
	grep "time = " npindexks*.Rout
	grep Objective npindexks*.Rout

npscoef:

	mpirun -np $(np) R CMD BATCH --no-save npscoef_npRmpi.R
	grep "time = " npscoef*.Rout
	grep Objective npscoef*.Rout

clean:

	rm *.out *.Rout *~
