#!/bin/bash

# ./fastaXtractor.sh file.fasta headers.txt


# Verifica se os argumentos foram fornecidos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <arquivo_fasta> <arquivo_lista>"
    exit 1
fi

# Arquivos de entrada
fasta_file="$1"
lista_file="$2"
output_file="Xresult.fasta"

# Cria o arquivo de saída ou limpa se já existir
> "$output_file"

# Lê os cabeçalhos dos genes de interesse em um array
mapfile -t Xresult < "$lista_file"

# Variável para armazenar se estamos no gene de interesse
is_interesting_gene=false

# Lê o arquivo fasta linha por linha
while IFS= read -r line; do
    if [[ $line =~ ^\> ]]; then
        # Remove o '>' do início do cabeçalho
        header="${line#>}"
        
        # Verifica se o cabeçalho está na lista de genes de interesse
        if [[ " ${Xresult[*]} " == *" $header "* ]]; then
            is_interesting_gene=true
            echo "$line" >> "$output_file"
        else
            is_interesting_gene=false
        fi
    else
        if [ "$is_interesting_gene" = true ]; then
            echo "$line" >> "$output_file"
        fi
    fi
done < "$fasta_file"

echo "Arquivo $output_file criado com sucesso."

