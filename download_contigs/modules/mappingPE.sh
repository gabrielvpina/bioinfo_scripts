#!/bin/bash

mkdir -p "STAR_unmapped"
pasta_fastp="fastp/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_fastp"/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Descomprimir o arquivo _1.fq.gz
        gunzip -c "$arquivo" > "$pasta_fastp/${samp}_1.fastq"

        # Descomprimir o arquivo _2.fq.gz
        gunzip -c "$pasta_fastp/${samp}_2.fastq.gz" > "$pasta_fastp/${samp}_2.fastq"

        # Comando STAR
        STAR --runThreadN 7 --genomeDir star_genome --readFilesIn "$pasta_fastp/${samp}_1.fastq" "$pasta_fastp/${samp}_2.fastq" --outFileNamePrefix "STAR_unmapped/${samp}_" --outReadsUnmapped Fastx 

        # Comprimir novamente os arquivos _1.fastq e _2.fastq
        echo "Removing uncompressed files"
        rm "$pasta_fastp/${samp}_1.fastq"
        rm "$pasta_fastp/${samp}_2.fastq"
    fi
done

# echo "Removing file 'fastp'"
# rm -r fastp
