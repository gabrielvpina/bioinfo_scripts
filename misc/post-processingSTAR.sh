#!/bin/bash

# Esse script deve ser inserido na pasta do STAR unmapped
# Ele deverá ser usado para filtrar os arquivos fastq da fasta de output

# Iterar sobre os arquivos Unmapped.out.mate1
for arquivo in *_Unmapped.out.mate1; do
    # Extrair o número (1 ou 2) do nome do arquivo original
    numero=$(echo "$arquivo" | grep -oE '[12]')
    novo_nome="${arquivo/_Unmapped.out.mate1/_$numero.fastq}"
    
    # Renomear o arquivo
    mv "$arquivo" "$novo_nome"
    echo "Arquivo $arquivo renomeado para $novo_nome"
done

# Iterar sobre os arquivos Unmapped.out.mate2
for arquivo in *_Unmapped.out.mate2; do
    # Extrair o número (1 ou 2) do nome do arquivo original
    numero=$(echo "$arquivo" | grep -oE '[12]')
    novo_nome="${arquivo/_Unmapped.out.mate2/_$numero.fastq}"
    
    # Renomear o arquivo
    mv "$arquivo" "$novo_nome"
    echo "Arquivo $arquivo renomeado para $novo_nome"
done

# Excluindo arquivos que não sejam fastq

# Use o comando find para encontrar todos os arquivos no diretório atual
# que não terminam com o sufixo ".fastq"
arquivos_a_excluir=$(find . -maxdepth 1 -type f ! -name "*.fastq")

# Iterar sobre os arquivos encontrados e excluí-los
for arquivo in $arquivos_a_excluir; do
    echo "Excluindo arquivo: $arquivo"
    rm "$arquivo"
done

