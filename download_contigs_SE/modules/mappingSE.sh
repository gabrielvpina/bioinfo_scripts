#!/bin/bash

mkdir -p "STAR_unmapped_SE"
pasta_fastp="fastp/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_fastp"/*.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" .fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Descomprimir o arquivo .fq.gz
        gunzip -c "$arquivo" > "$pasta_fastp/${samp}.fastq"

        # Comando STAR
        ./STAR --runThreadN 6 --genomeDir star_genome --readFilesIn "$pasta_fastp/${samp}.fastq" --outFileNamePrefix "STAR_unmapped_SE/${samp}_" --outReadsUnmapped Fastx
        

        # Comprimir novamente os arquivos .fastq
        echo "Removing uncompressed files"
        rm "$pasta_fastp/${samp}.fastq"
    fi
done

# echo "Removing file 'fastp'"
# rm -r fastp

