#!/bin/bash

# Criar um novo diretório
dir_name="fastp"
mkdir -p "$dir_name"

# Obter a lista de arquivos na pasta fastq/
lista_arquivos=$(ls fastq/)

# Iterar sobre os arquivos na lista
for arquivo in $lista_arquivos; do
    # Caminho de entrada e saída para o Fastp
    entrada="fastq/$arquivo"
    saida="$dir_name/$arquivo"

    # Comando Fastp
     comando_fastp=(
        "fastp"
        "-i" "$entrada"
        "-o" "$saida"
        "--trim_poly_g"
    )

    # Executar o comando Fastp
     "${comando_fastp[@]}"
done

