#!/bin/bash

# Criar um novo diretório
dir_name="STAR_unmapped"
mkdir -p "$dir_name"

# Descompactar arquivos da pasta fastp
gunzip fastp/*

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in fastp/*_1.fastq; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_fastp/${samp}_2.fastq"
        if [[ -f "$arquivo_2" ]]; then
            
            # Comando STAR
            STAR --runThreadN 12 --genomeDir star_genome --readFilesIn "$arquivo" "$arquivo_2" --outReadsUnmapped Fastx >> STAR_unmapped/


        fi
    fi
done

# Compactar arquivos de volta 
gzip fastp/*
