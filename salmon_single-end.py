import subprocess
import os

# Criar um novo diretório
dir_name = "salmon_quant"
os.makedirs(dir_name, exist_ok=True)

# Obter a lista de arquivos na pasta fastq/
lista_arquivos = os.listdir("fastp/")

# Iterar sobre os arquivos na lista
for arquivo in lista_arquivos:
    # Caminho de entrada e saída para o Fastp
    entrada = f"fastp/{arquivo}"
    saida = f"{dir_name}/{arquivo}"

    # Comando Fastp
    comando_salmon = [
        "salmon quant",
        "-i", "cacao_index",
        "-l A",
        "-r", entrada,
        "-o", saida
    ]

    # Executar o comando Fastp
    subprocess.run(comando_salmon)
