#!/bin/bash

# Criar um novo diretório
mkdir -p "spades"

# Obter o caminho completo para a pasta STAR_unmapped
pasta_star_unmapped="STAR_unmapped"

# Iterar sobre os arquivos encontrados na pasta STAR_unmapped
for arquivo in "$pasta_star_unmapped"/*_pass_Unmapped.out.mate1; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _pass_Unmapped.out.mate1)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_star_unmapped/${samp}_pass_Unmapped.out.mate2"
        if [[ -f "$arquivo_2" ]]; then
            # Comando SPAdes
            spades.py --threads 7 --memory 14 --pe1-1 "$arquivo" --pe1-2 "$arquivo_2" -o "spades/${samp}_assembly" 

            echo "Assembling $arquivo. The query used was: spades.py --threads 7 --memory 14 --pe1-1 $arquivo --pe1-2  $arquivo_2  -o spades/${samp}_assembly"
        fi
    fi
done

# rm -r STAR_unmapped
