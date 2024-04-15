#!/bin/bash

# Criar um novo diretório
dir_name="fastp"
mkdir -p "$dir_name"

# Obter o caminho completo para a pasta fastp/
pasta_fastq="fastq/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_fastq"/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_fastq/${samp}_2.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando Fastp
            fastp --trim_poly_g --in1 "$arquivo" --in2 "$arquivo_2" --out1 "$dir_name/${samp}_1.fq.gz" --out2 "$dir_name/${samp}_2.fq.gz" 
        fi
    fi
done
