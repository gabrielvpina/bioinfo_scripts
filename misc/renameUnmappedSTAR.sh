#!/bin/bash

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
