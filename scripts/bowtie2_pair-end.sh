#!/bin/bash

# Criar um novo diretório
dir_name="bowtie2"
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

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_fastp/${samp}_2.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando Bowtie2
            bowtie2 -x cacao_index -1 "$arquivo" -2 "$arquivo_2" --un-conc-gz "$dir_name/${samp}_unaligned.fq.gz" -p 6
        fi
    fi
done

