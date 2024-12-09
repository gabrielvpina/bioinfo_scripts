#!/bin/bash

# Criar um novo diretório
mkdir -p "spades"

# Obter o caminho completo para a pasta STAR_unmapped
pasta_star_unmapped="STAR_unmapped_SE"

# Iterar sobre os arquivos encontrados na pasta STAR_unmapped
for arquivo in "$pasta_star_unmapped"/*.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" .fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

            # Comando SPAdes
            python3 /media/gabriel/DATA_01/download_contigs_SE/SPAdes-4.0.0-Linux/bin/spades.py --threads 6 --memory 14 -s "$arquivo" -o "spades/${samp}_assembly" 

            echo "Assembling $arquivo. The query used was: spades.py --threads 6 --memory 14 -1 $arquivo -o spades/${samp}_assembly"
    fi
done

# rm -r STAR_unmapped
