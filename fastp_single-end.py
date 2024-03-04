import subprocess
import os

# Criar um novo diretório
dir_name = "fastp"
os.makedirs(dir_name, exist_ok=True)

# Obter a lista de arquivos na pasta fastq/
lista_arquivos = os.listdir("fastq/")

# Iterar sobre os arquivos na lista
for arquivo in lista_arquivos:
    # Caminho de entrada e saída para o Fastp
    entrada = f"fastq/{arquivo}"
    saida = f"{dir_name}/{arquivo}_cleaned.fastq.gz"

    # Comando Fastp
    comando_fastp = [
        "fastp",
        "-i", entrada,
        "-o", saida,
        "--trim_poly_g"
    ]

    # Executar o comando Fastp
    subprocess.run(comando_fastp)

