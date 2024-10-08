#!/bin/bash

# É OBRIGATÓRIA a criação da pasta "assembled_contigs" antes de iniciar esse script.
# "mkdir assembled_contigs"

# Solicitar ao usuário que insira os SRA library runs separados por espaço
entry="SRR17587557 SRR17587556"
sra_numbers=($entry)

# Solicitar ao usuário que insira o caminho da pasta de destino
user_path="/home/gabriel/bioinfo/teste_diversidade"

# Inicializar a lista de pastas SRA
sra_folders=()

# Baixar os arquivos .sra para $user_path (o diretório será criado se não existir)
for sra_id in "${sra_numbers[@]}"; do
    echo "Currently downloading: $sra_id"
    prefetch="prefetch $sra_id"
    echo "The command used was: $prefetch"
    $prefetch

    # Adicionar o caminho da pasta da biblioteca SRA à lista
    sra_folder_path="$user_path/$sra_id"
    sra_folders+=("$sra_folder_path")
done

mkdir -p "fastq"

# Extrair os arquivos .sra para a pasta 'fastq'
for ((i=0; i<${#sra_numbers[@]}; i++)); do
    sra_id=${sra_numbers[i]}
    sra_folder_path=${sra_folders[i]}
    echo "Generating fastq for: $sra_id"
    sra_file_path="$sra_folder_path/${sra_id}.sra"
    fastq_dump="fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip $sra_file_path"
    echo "The command used was: $fastq_dump"
    $fastq_dump

    # Excluir a pasta da biblioteca SRA após a extração
    rm -rf "$sra_folder_path"
    echo "Deleted folder: $sra_folder_path"
done

################ trimmming - Fastp ###############################

mkdir -p "fastp"

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

################ mapping - STAR ###############################

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

################# assembling - SPAdes ###########################

# Criar um novo diretório
mkdir -p "spades"

# Obter o caminho completo para a pasta STAR_unmapped
pasta_star_unmapped="STAR_unmapped/"

# Iterar sobre os arquivos encontrados na pasta STAR_unmapped
for arquivo in "$pasta_star_unmapped"/*_1.fastq.gz; do
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq)
    if [[ -f "$arquivo" ]]; then
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp=$(basename "$arquivo" _1.fastq.gz)

        # Imprimir a mensagem de processamento
        echo "Processing sample $samp"

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2="$pasta_star_unmapped/${samp}_2.fastq.gz"
        if [[ -f "$arquivo_2" ]]; then
            # Comando SPAdes
            spades.py --threads 7 --memory 14 -1 "$arquivo" -2 "$arquivo_2" -o "spades/${samp}_assembly" 

            echo "Assembling $arquivo. The query used was: spades.py --threads 10 --memory 200 -1 $arquivo -2 $arquivo_2 -o spades/${samp}_assembly"
        fi
    fi
done

# rm -r STAR_unmapped

############### getting contigs #################

# Iterar sobre os diretórios encontrados na pasta spades
for dir in spades/*_assembly; do
    # Verificar se a pasta tem o padrão correto de nome (_assembly)
    if [[ -d "$dir" ]]; then
        # Extrair o nome do diretório (sem extensão)
        samp=$(basename "$dir" _assembly)
        
        # Copiar o arquivo contigs.fasta para assembled_contigs
        cp "$dir/contigs.fasta" "assembled_contigs/${samp}.fasta"
    fi
done
