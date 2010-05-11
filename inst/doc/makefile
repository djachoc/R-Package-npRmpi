all:
	echo 'Sweave("npRmpi.Rnw", stylepath=TRUE)' | R --no-save --no-restore
	pdflatex npRmpi
	bibtex npRmpi

