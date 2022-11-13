MAIN=main.tex
SRC=$(wildcard *.tex)
LATEX=latexmk -pdf
LATEX_CLEAN=latexmk -c
LATEX_WATCH=latexmk -pdf -pvc

all:
	${LATEX} ${MAIN}

clean:
	$(foreach file,${SRC}, ${LATEX_CLEAN} ${file};)

watch:
	${LATEX_WATCH} ${MAIN}
