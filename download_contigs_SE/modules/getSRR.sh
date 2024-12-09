#!/bin/bash

# É OBRIGATÓRIA a criação da pasta "assembled_contigs" antes de iniciar esse script.
# "mkdir assembled_contigs"

# Solicitar ao usuário que insira os SRA library runs separados por espaço
entry="SRR23455112"
sra_numbers=($entry)

# Solicitar ao usuário que insira o caminho da pasta de destino
user_path="/media/gabriel/DATA_01/download_contigs_SE"

# Inicializar a lista de pastas SRA
sra_folders=()

# Baixar os arquivos .sra para $user_path (o diretório será criado se não existir)
for sra_id in "${sra_numbers[@]}"; do
    echo "Currently downloading: $sra_id"
    prefetch="/media/gabriel/DATA_01/download_contigs_SE/sratoolkit.3.1.1-ubuntu64/bin/prefetch $sra_id"
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
    fastq_dump="/media/gabriel/DATA_01/download_contigs_SE/sratoolkit.3.1.1-ubuntu64/bin/fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --clip $sra_file_path"
    echo "The command used was: $fastq_dump"
    $fastq_dump

    # Excluir a pasta da biblioteca SRA após a extração
    rm -rf "$sra_folder_path"
    echo "Deleted folder: $sra_folder_path"
done
