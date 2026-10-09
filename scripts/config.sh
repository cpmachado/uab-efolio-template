#!/usr/bin/env bash
# Configura o template para um e-fólio e uma unidade curricular.
#
# Uso:
#   scripts/config.sh <A|B|global> <código> [n.º estudante]
#       ex.: scripts/config.sh A 21164
#            scripts/config.sh A 21164 2300610
#   scripts/config.sh --list                  lista as unidades curriculares
#
# Altera em main.tex: \UC, \codigoUC e \tipoEfolio (e \numeroEstudante, se
# o número de estudante for indicado; caso contrário mantém o valor atual).
# Os dados vêm de scripts/ucs.csv (colunas: codigo,nome,area,ano,semestre;
# os nomes não podem conter vírgulas).
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
csv="$root/scripts/ucs.csv"
main="$root/main.tex"

uso() {
    awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' \
        "${BASH_SOURCE[0]}" >&2
    exit "${1:-2}"
}

erro() {
    echo "erro: $*" >&2
    exit 1
}

[[ -f "$csv" ]] || erro "ficheiro $csv não encontrado"
[[ -f "$main" ]] || erro "ficheiro $main não encontrado"

if [[ "${1:-}" == "--list" ]]; then
    awk -F, 'NR > 1 { printf "%s  %s (%d.º ano, %d.º semestre)\n", $1, $2, $4, $5 }' "$csv"
    exit 0
fi

(($# == 2 || $# == 3)) || uso

efolio=${1,,}
codigo=$2
aluno=${3:-}

if [[ -n "$aluno" && ! "$aluno" =~ ^[0-9]+$ ]]; then
    erro "número de estudante inválido: '$aluno' (apenas dígitos)"
fi

case "$efolio" in
    a | b | global) ;;
    *) erro "e-fólio inválido: '$1' (use A, B ou global)" ;;
esac

nome=$(awk -F, -v c="$codigo" 'NR > 1 && $1 == c { print $2; exit }' "$csv")
[[ -n "$nome" ]] || erro "código '$codigo' não encontrado em scripts/ucs.csv (use --list)"

# Trabalha sobre uma cópia e só substitui main.tex se tudo correr bem
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
cp "$main" "$tmp"

# set_macro <macro> <valor>: reescreve a linha \newcommand{\macro}{...}
set_macro() {
    local macro=$1 valor=$2 out
    out=$(mktemp)
    PRE='\newcommand{\'"$macro"'}{' VAL=$valor awk '
        BEGIN { pre = ENVIRON["PRE"]; val = ENVIRON["VAL"] }
        index($0, pre) == 1 { print pre val "}"; found = 1; next }
        { print }
        END { exit !found }' "$tmp" >"$out" ||
        { rm -f "$out"; erro "macro \\$macro não encontrada em main.tex"; }
    cat "$out" >"$tmp"
    rm -f "$out"
}

set_macro UC "$nome"
set_macro codigoUC "$codigo"
set_macro tipoEfolio "$efolio"
[[ -z "$aluno" ]] || set_macro numeroEstudante "$aluno"

cat "$tmp" >"$main" # cat preserva as permissões de main.tex
echo "Configurado: e-fólio ${efolio^^} | $codigo $nome${aluno:+ | estudante $aluno}"
