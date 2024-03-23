#!/bin/bash

# INTRODUCAO
# Esse script foi escreito no intuito de analisar o output de uma lista de arquivos .csv de transcritos quantificados (TPM). Ele foi desenvolvido para ser usado no output dos arquivos do Salmon quant da plataforma galaxy.

# TIPOS DE ARQUIVO
# O script irá selecionar a primeira coluna comum dos outputs e adicionar a coluna 4 de todas as tabelas em uma única tabela, referenciando o nome de cada coluna com o arquivo original.

# USO
# Para usa-lo basta invocar o script e inserir os arquivos .csv seguidos de espaço.

# ./script.sh arquivo01.csv arquivo02.csv arquivo03.csv

# O output será chamado de "tabela_unida_titulo.csv".
# OBS: alguns ajustes são necessários na planilha final.


# Arquivo de saída
output_file="tabela_unida_titulo.csv"

# Extrair a primeira coluna do primeiro arquivo para usar como referência
first_file="$1"
reference_column=$(cut -d ',' -f 1 "$first_file")

# Cabeçalho
echo "$reference_column" > "$output_file"

# Adicionar colunas de arquivos restantes
for file in "${@:2}"; do
    # Extrair o nome do arquivo sem extensão
    file_name=$(basename "$file" .csv)
    # Extrair a quarta coluna e adicionar ao arquivo de saída
    cut -d ',' -f 4 "$file" | paste -d ',' "$output_file" - > temp.csv
    mv temp.csv "$output_file"
done

# Adicionar os nomes dos arquivos como títulos de coluna
header=$(echo "${@:2}" | tr ' ' ',' | sed "s/\.csv//g")
sed -i "1 s/^/$header\n/" "$output_file"


