#!/bin/bash

# Criar um novo diretório
dir_name="fastqc"
mkdir -p "$dir_name"

# Executar o FastQC
fastqc_command="fastqc --outdir fastqc/ fastq/*.fastq.gz"
echo "The command used was: $fastqc_command"
$fastqc_command

# Executar o MultiQC
multiqc_command="multiqc fastqc/"
$multiqc_command

