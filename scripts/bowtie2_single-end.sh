#!/bin/bash

# Criar um novo diretório
dir_name="bowtie2"
mkdir -p "$dir_name"

# Obter a lista de arquivos na pasta fastp/
lista_arquivos=$(ls fastp/)

# Iterar sobre os arquivos na lista
for arquivo in $lista_arquivos; do
    # Caminho de entrada e saída para o Bowtie2
    entrada="fastp/$arquivo"
    saida="$dir_name/$arquivo"

    # Comando Bowtie2
    bowtie2_command="bowtie2 -x cacao_index -U $entrada --un $saida"

    # Executar o comando Bowtie2
    echo "Running Bowtie2 for $arquivo"
    $bowtie2_command
done

