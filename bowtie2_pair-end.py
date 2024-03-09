# Example pair-end query

# NECESSARIO ANTES: bowtie2-build -f input_reference.fasta index_prefix

# bowtie2 -x index_prefix [-q|--qseq|-f|-r|-c] [-1 input_reads_pair_1.[fasta|fastq] -2 input_reads_pair_2.[fasta|fastq] | -U input_reads.[fasta|fastq]] -S bowtie2_alignments.sam [options]

# bowtie2 -x index_prefix -f -1 input_reads_pair_1.fasta -2 input_reads_pair_2.fasta -S bowtie2_alignments.sam --local -p $SLURM_NTASKS_PER_NODE

import subprocess
import os

# Criar um novo diretório
dir_name = "bowtie2"
os.makedirs(dir_name, exist_ok=True)

# Obter a lista de arquivos na pasta fastp/
pasta_bibliotecas = input("Insert path to the .fastq.gz archives:")

# Lista para armazenar os pares de arquivos das bibliotecas pair-end
pares_bibliotecas = []

# Iterar sobre os arquivos na pasta e agrupá-los em pares
for arquivo in os.listdir(pasta_bibliotecas):
    if arquivo.endswith("_1.fastq.gz"):
    
        # Verificar se há um arquivo correspondente para o par
        arquivo_par = arquivo.replace("_1.fastq.gz", "_2.fastq.gz")
        if arquivo_par in os.listdir(pasta_bibliotecas):
            pares_bibliotecas.append((arquivo, arquivo_par))
            
# Executar o Bowtie2 para cada par de arquivos de biblioteca pair-end
for biblioteca1, biblioteca2 in pares_bibliotecas:
    # Nome do arquivo de saída para o alinhamento
    saida_alinhamento = f"alinhamento_{biblioteca1[:-9]}_vs_{biblioteca2[:-10]}.fastq.gz"


# Iterar sobre os arquivos na lista
#for arquivo in lista_arquivos:
    # Caminho de entrada e saída para o Fastp
    #entrada1 = f"fastq/{arquivo1}"
    #entrada2 = f"fastq/{arquivo2}"
    #saida = f"{dir_name}/{arquivo}.fastq.gz"

    # Comando Fastp
    comando_bowtie2 = [
        "bowtie2",
        "-x", "cacao_index",  # Substitua "index_reference" pelo índice Bowtie2 adequado
        "-1", os.path.join(pasta_bibliotecas, biblioteca1),
        "-2", os.path.join(pasta_bibliotecas, biblioteca2),
        "--un", saida_alinhamento
    ]

    # Executar o comando Fastp
    subprocess.run(comando_bowtie2)


