#!/bin/bash

# lendo os arquivos da pasta fastq
for arquivo in fastq/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="fastq/${samp}_2.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando Fastp
            fastp --trim_poly_g --in1 "$arquivo" --in2 "$arquivo_2" --out1 "fastp/${samp}_1.fastq.gz" --out2 "fastp/${samp}_2.fastq.gz" 

            echo "Trimming $samp. The query used is: fastp --trim_poly_g --in1 $arquivo --in2 $arquivo_2 --out1 fastp/${samp}_1.fq.gz --out2 fastp/${samp}_2.fq.gz"
        fi
    fi
done

# rm -r fastq

