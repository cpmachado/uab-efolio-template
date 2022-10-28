MAIN=main.tex
LATEX=latexmk -pdf
LATEX_CLEAN=latexmk -c
LATEX_WATCH=latexmk -pdf -pvc

all:
	${LATEX} ${MAIN}

clean:
	${LATEX_CLEAN} ${MAIN}

watch:
	${LATEX_WATCH} ${MAIN}
