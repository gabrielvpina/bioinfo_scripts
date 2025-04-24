import os, shutil, glob
import subprocess
from pathlib import Path

def process_sra_libraries(input_file, output_dir, sra_toolkit_path=""):

    # check files
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    with open(input_file, 'r') as file:
        sra_ids = file.read().strip().split(',')

    for sra_id in sra_ids:
        sra_id = sra_id.strip()
        if not sra_id:
            continue  

        print(f"Processando {sra_id}...")

        try:
            # Prefetch
            prefetch_cmd = [f"{sra_toolkit_path}prefetch" if sra_toolkit_path else "prefetch", sra_id]
            print(f"Executando prefetch: {' '.join(prefetch_cmd)}")
            subprocess.run(prefetch_cmd, check=True)

            # fasterq-dump
            fasterq_cmd = [
                f"{sra_toolkit_path}fasterq-dump" if sra_toolkit_path else "fasterq-dump",
                "--outdir", output_dir,
                "--split-files",
                sra_id
            ]
            print(f"Executando fasterq-dump: {' '.join(fasterq_cmd)}")
            subprocess.run(fasterq_cmd, check=True)

            # gzip
            print(f"Compactando arquivos FASTQ para {sra_id}...")
            fastq_files = glob.glob(os.path.join(output_dir, f"{sra_id}*.fastq"))
            for fastq_file in fastq_files:
                gzip_cmd = ["gzip", fastq_file]
                print(f"Compactando: {' '.join(gzip_cmd)}")
                subprocess.run(gzip_cmd, check=True)

            print(f"Concluído: {sra_id}\n")
        except subprocess.CalledProcessError as e:
            print(f"Erro ao processar {sra_id}: {e}")
        except Exception as e:  
            print(f"Erro inesperado ao processar {sra_id}: {e}")

if __name__ == "__main__":
    
    input_file = "sra_ids.txt"  # Arquivo com os IDs SRA separados por vírgula
    output_dir = "fastq_output"  # Diretório para salvar os arquivos FASTQ
    sra_toolkit_path = "/run/media/gabriel/DATA_01/tools/"  # Atualize com o caminho do SRA Toolkit se necessário

    process_sra_libraries(input_file, output_dir, sra_toolkit_path)
