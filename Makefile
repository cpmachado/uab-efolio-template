MAIN = main.tex
OUT = ${MAIN:.tex=.pdf}

${OUT}: ${MAIN}
	latexmk -quiet $(PV) -auxdir=aux -use-make -pdf ${MAIN}

watch: PV=-pvc
watch: ${OUT}

clean:
	rm -rf aux ${OUT}

.PHONY: watch clean
