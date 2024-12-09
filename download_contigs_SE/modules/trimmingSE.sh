#!/bin/bash

# lendo os arquivos da pasta fastq
for arquivo in fastq/*.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" .fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

            # Comando Fastp
            fastp --trim_poly_g --in1 "$arquivo" --out1 "fastp/${samp}.fastq.gz"  

            echo "Trimming $samp. The query used is: fastp --trim_poly_g --in1 $arquivo --out1 fastp/${samp}.fq.gz"

    fi
done

# rm -r fastq

