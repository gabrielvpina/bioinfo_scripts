# Essa versão permite a exclusão das pastas dos arquivos .sra de forma automatizada
import subprocess
import shutil
import os

# Solicitar ao usuário que insira os SRA library runs separados por espaço
entry = input("-> Enter the SRA library runs separated by space: ")
user_input = entry.split()
sra_numbers = user_input

# Solicitar ao usuário que insira o caminho da pasta de destino
user_path = input("-> Insert destination folder path here: ")

# Lista para armazenar os caminhos das pastas das bibliotecas SRA
sra_folders = []

# Baixar os arquivos .sra para ~/ncbi/public/sra/ (o diretório será criado se não existir)
for sra_id in sra_numbers:
    print("Currently downloading: " + sra_id)
    prefetch = "prefetch " + sra_id
    print("The command used was: " + prefetch)
    subprocess.call(prefetch, shell=True)

    # Adicionar o caminho da pasta da biblioteca SRA à lista
    sra_folder_path = os.path.join(user_path, sra_id)
    sra_folders.append(sra_folder_path)

# Extrair os arquivos .sra para a pasta 'fastq'
for sra_id, sra_folder_path in zip(sra_numbers, sra_folders):
    print("Generating fastq for: " + sra_id)
    sra_file_path = os.path.join(sra_folder_path, f"{sra_id}.sra")
    fastq_dump = "fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip " + sra_file_path
    print("The command used was: " + fastq_dump)
    subprocess.call(fastq_dump, shell=True)

    # Excluir a pasta da biblioteca SRA após a extração
    shutil.rmtree(sra_folder_path)
    print(f"Deleted folder: {sra_folder_path}")
