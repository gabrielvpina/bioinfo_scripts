#!/bin/bash

# Criar um novo diretório
mkdir -p "STAR_unmapped_FASTA_SE"

# Iterar sobre os arquivos encontrados na pasta STAR_unmapped
for arquivo in "STAR_unmapped_SE"/*.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" .fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

            # Comando seqtk

            seqtk seq -a "${arquivo}" >> "STAR_unmapped_FASTA_SE/${samp}.fasta"
    fi

done

