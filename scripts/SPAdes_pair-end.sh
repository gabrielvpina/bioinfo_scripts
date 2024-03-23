#!/bin/bash

# Criar um novo diretório
dir_name="spades"
mkdir -p "$dir_name"

# Obter o caminho completo para a pasta fastp/
pasta_bowtie2="bowtie2/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_bowtie2"/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_fastp/${samp}_2.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando Bowtie2
            spades.py --isolate --threads 16 --memory 200 -1 "$arquivo" -2 "$arquivo_2" -o "$dir_name/${samp}_assembly.fq.gz" 
        fi
    fi
