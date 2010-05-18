all:
	echo 'Sweave("npRmpi_vignette.Rnw", stylepath=TRUE)' | R --no-save --no-restore
	pdflatex npRmpi_vignette
	bibtex npRmpi_vignette

clean:
	rm *.aux *.log *.bbl *.blg *.out *.tex
