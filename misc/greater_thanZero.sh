#!/bin/bash

# Verifica se o usuário forneceu o nome do arquivo como argumento
if [ $# -eq 0 ]; then
    echo "Uso: $0 <arquivo.csv>"
    exit 1
fi

# Verifica se o arquivo de entrada existe
if [ ! -f "$1" ]; then
    echo "Arquivo não encontrado: $1"
    exit 1
fi

# Nome do arquivo de entrada
input_file="$1"

# Loop através das colunas do arquivo .csv
num_cols=$(awk -F ',' 'NR==1 {print NF}' "$input_file")  # Obtém o número de colunas
for ((i = 1; i <= num_cols; i++)); do
    # Extrai a coluna atual para um arquivo temporário
    cut -d ',' -f "$i" "$input_file" > temp_coluna.csv
    # Conta o número total de linhas e o número de linhas maiores que zero
    total_linhas=$(wc -l < temp_coluna.csv)
    linhas_maiores_que_zero=$(awk -F ',' '$1 > 0 {count++} END {print count}' temp_coluna.csv)
    # Calcula a proporção e imprime o resultado
    proporcao=$(echo "scale=2; $linhas_maiores_que_zero / $total_linhas" | bc)
    echo "Proporção de valores maiores que zero na coluna $i: $proporcao"
    # Remove o arquivo temporário da coluna
    rm temp_coluna.csv
done

# INTRODUÇAO
# Esse script será usado para avaliar a expressão de genes com o TPM > 0
# Ele retorna a proporção entre genes TPM>0 / genes totais

# USO
# Digitar `./greater_thanZero.sh` e o arquivo em seguida com as TPMs de cada biblioteca agregadas.



# SELECIONAR SOMENTE OS NUMEROS
# Para selecionar somente os valores depois do ponto:
# awk '{print gensub(".*\\.", "", "1")}' arquivo.txt



