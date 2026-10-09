MAIN = main.tex
ALL_TEX_FILES  = $(wildcard *.tex)
OUT  = ${MAIN:.tex=.pdf}

all: ${OUT}

${OUT}:
	latexmk -quiet -auxdir=aux -pdf ${MAIN}

watch:
	latexmk -pvc -auxdir=aux -pdf ${MAIN}

clean:
	latexmk -C -auxdir=aux ${MAIN}
	rm -rf aux

format:
	latexindent -l -s -wd -c=aux $(ALL_TEX_FILES)

.PHONY: all watch clean ${OUT} format
