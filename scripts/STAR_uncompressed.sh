#!/bin/bash

# Criar um novo diretório
dir_name="STAR_unmapped"
mkdir -p "$dir_name"

# Obter o caminho completo para a pasta fastp/
pasta_fastp="fastp/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_fastp"/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Descomprimir o arquivo _1.fastq.gz
        gunzip -c "$arquivo" > "$pasta_fastp/${samp}_1.fastq"

        # Descomprimir o arquivo _2.fastq.gz
        gunzip -c "$pasta_fastp/${samp}_2.fastq.gz" > "$pasta_fastp/${samp}_2.fastq"

        # Comando STAR
        STAR --runThreadN 12 --genomeDir star_genome --readFilesIn "$pasta_fastp/${samp}_1.fastq" "$pasta_fastp/${samp}_2.fastq" --outFileNamePrefix "$dir_name/${samp}.fastq" --outReadsUnmapped Fastx 

        # Comprimir novamente os arquivos _1.fastq e _2.fastq
        rm "$pasta_fastp/${samp}_1.fastq"
        rm "$pasta_fastp/${samp}_2.fastq"
    fi
done
