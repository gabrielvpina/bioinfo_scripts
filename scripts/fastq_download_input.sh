#!/bin/bash

# This script allows the user to download SRA libraries by their SRR id 
read -p "-> Enter the SRA library runs separated by space: " entry
sra_numbers=($entry)

read -p "-> Insert destination folder path here: " user_path

# this will download the .sra files to ~/ncbi/public/sra/ (will create directory if not present)
for sra_id in "${sra_numbers[@]}"; do
    echo "Currently downloading: $sra_id"
    prefetch="prefetch $sra_id"
    echo "The command used was: $prefetch"
    $prefetch
done

# this will extract the .sra files from above into a folder named 'fastq'
for sra_id in "${sra_numbers[@]}"; do
    echo "Generating fastq for: $sra_id"
    # insert destination folder path here
    sra_file_path="$user_path/$sra_id/$sra_id.sra"
    fastq_dump="fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip $sra_file_path"
    echo "The command used was: $fastq_dump"
    $fastq_dump
done

