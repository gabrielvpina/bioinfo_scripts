  GNU nano 6.2                                                             trinity_PE.sh                                                                      
#!/bin/bash

# Criar um novo diretório
dir_name="trinity"
mkdir -p "$dir_name"

# Obter o caminho completo para a pasta fastp/
pasta_STAR="STAR_unmapped/"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in "$pasta_STAR"/*1.fq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" 1.fq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_STAR/${samp}2.fq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando Bowtie2
             Trinity --seqType fq --no_bowtie --max_memory 50G --left "$arquivo"  --right "$arquivo_2" --CPU 10 --output trinity/"$samp.fasta"
        fi
    fi

done


