#!/bin/bash

# Solicitar ao usuário que insira os SRA library runs separados por espaço
echo "-> Enter the SRA library runs separated by space: "
read -r entry
sra_numbers=($entry)

# Solicitar ao usuário que insira o caminho da pasta de destino
echo "-> Insert destination folder path here: "
read -r user_path

# Baixar os arquivos .sra para ~/ncbi/public/sra/ (o diretório será criado se não existir)
for sra_id in "${sra_numbers[@]}"; do
    sra_folder_path="$user_path/$sra_id"

    # Verificar se o arquivo .sra já foi baixado
    if [ ! -f "$sra_folder_path/${sra_id}.sra" ]; then
        echo "Currently downloading: $sra_id"
        prefetch="prefetch $sra_id"
        echo "The command used was: $prefetch"
        $prefetch
    else
        echo "Skipping download for $sra_id. File already exists."
    fi

    # Adicionar o caminho da pasta da biblioteca SRA à lista
    sra_folders+=("$sra_folder_path")
done

# Extrair os arquivos .sra para a pasta 'fastq'
for ((i=0; i<${#sra_numbers[@]}; i++)); do
    sra_id=${sra_numbers[i]}
    sra_folder_path=${sra_folders[i]}
    echo "Generating fastq for: $sra_id"
    sra_file_path="$sra_folder_path/${sra_id}.sra"

    # Verificar se o arquivo .fastq.gz já foi gerado
    if [ ! -f "fastq/${sra_id}.fastq.gz" ]; then
        fastq_dump="fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip $sra_file_path"
        echo "The command used was: $fastq_dump"
        $fastq_dump
    else
        echo "Skipping fastq generation for $sra_id. File already exists."
    fi

    # Excluir a pasta da biblioteca SRA após a extração
    rm -rf "$sra_folder_path"
    echo "Deleted folder: $sra_folder_path"
done
