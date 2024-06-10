#!/bin/bash

# Criar um novo diretório
mkdir -p "STAR_unmapped_FASTA"

# Iterar sobre os arquivos encontrados na pasta STAR_unmapped
for arquivo in "STAR_unmapped"/*_01.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _01.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="STAR_unmapped/${samp}_02.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando seqtk
            
            seqtk seq -a "${arquivo}" >> "STAR_unmapped_FASTA/${samp}_01.fasta"
        
            seqtk seq -a "${arquivo_2}" >> "STAR_unmapped_FASTA/${samp}_02.fasta"
            
        fi
    fi
    
done

    
