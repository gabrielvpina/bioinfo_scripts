import subprocess
import os

# Criar um novo diretório
dir_name = "bowtie2"
os.makedirs(dir_name, exist_ok=True)

# Obter o caminho completo para a pasta fastp/
pasta_fastp = "fastp"

# Iterar sobre os arquivos encontrados na pasta fastp/
for arquivo in os.listdir(pasta_fastp):
    # Verificar se o arquivo tem o padrão correto de nome (_1.fastq.gz)
    if arquivo.endswith("_1.fastq.gz"):
        # Extrair o nome do arquivo (sem extensão) e sem o sufixo _1
        samp = arquivo.replace("_1.fastq.gz", "")

        # Imprimir a mensagem de processamento
        print(f"Processing sample {samp}")

        # Verificar se existe o arquivo correspondente com o sufixo _2
        arquivo_2 = f"{samp}_2.fastq.gz"
        if arquivo_2 in os.listdir(pasta_fastp):
            # Comando Bowtie2
            comando_bowtie2 = [
                "bowtie2", "-x", "cacao_index",
                "-1", f"{pasta_fastp}/{arquivo}", "-2", f"{pasta_fastp}/{arquivo_2}",
                "--un-conc-gz", f"{dir_name}/{samp}.fq", "-p 6"
            ]

            # Executar o comando Bowtie2 usando subprocess
            subprocess.run(comando_bowtie2)
        else:
            print(f"Arquivo correspondente para {arquivo} não encontrado")



