# uab-efolio-template

Template em $\LaTeX$ para os e-fólios da Universidade Aberta (UAb).

## Utilização

1. Usar o repositório como template no GitHub ("Use this template") ou clonar.
2. Editar os dados no preâmbulo de `main.tex`: `\numeroEstudante`, `\UC`,
   `\codigoUC`, `\docentes`, `\curso`, `\tipoEfolio` (`a`, `b` ou `global`),
   `\dataEntrega` e `\author`.
3. Escrever cada exercício num ficheiro próprio (ver `ex1.tex`) e incluí-lo em
   `main.tex` com `\include{ex2}`, etc.
4. Usar `\exercicio` e `\alinea` para os cabeçalhos, e `bibliografia.bib` para
   as referências.

Nota: por omissão `\dataEntrega` é `\today` (data de compilação). Fixe-a antes
de entregar.

## Compilar

Requisitos: TeX Live (ou equivalente) com `latexmk` e `biber`, e os pacotes de
português do `babel`.

```sh
make        # gera main.pdf
make watch  # recompila ao gravar (latexmk -pvc)
make clean  # remove main.pdf e o diretório aux/
```

## Licença

Ver o ficheiro [LICENSE](LICENSE).
