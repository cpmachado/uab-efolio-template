MAIN = main.tex
OUT = ${MAIN:.tex=.pdf}
LATEX=latexmk -pdf
LATEX_CLEAN=latexmk -c
LATEX_WATCH=latexmk -pdf -pvc

${OUT}: ${MAIN}
	latexmk -quiet $(PREVIEW_CONTINUOUSLY) -use-make -pdf ${MAIN}

watch: PREVIEW_CONTINUOUSLY=-pvc
watch: ${OUT}

clean:
	@latexmk -C -bibtex
	@rm -f *.atfi *.zip *.bbl *.run.xml *.synctex.gz *.lol *.loe

.PHONY: watch clean clean
