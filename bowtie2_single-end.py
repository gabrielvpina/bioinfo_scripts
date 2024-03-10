import subprocess
import os

# Criar um novo diretório
dir_name = "bowtie2"
os.makedirs(dir_name, exist_ok=True)

# Obter a lista de arquivos na pasta fastp/
lista_arquivos = os.listdir("/fastp")

# Iterar sobre os arquivos na lista
for arquivo in lista_arquivos:
    # Caminho de entrada e saída para o Fastp
    entrada = f"fastq/{arquivo}"
    saida = f"{dir_name}/{arquivo}.fastq.gz"

    # Comando Fastp
    comando_bowtie2 = [
        "bowtie2",
        "-x", "cacao_index",  # Substitua "index_reference" pelo índice Bowtie2 adequado
        "-U", entrada,
        "--un", "bowtie2/", saida
    ]

    # Executar o comando Fastp
    subprocess.run(comando_bowtie2)

