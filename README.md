# Some bash scripts used in bioinformatics research

## Download the sequences
`fastq_donwload_input.py`
- This script allows the user to download SRA libraries by their SRR id.
- small single-end (random) libraries will be selected - https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP422037&o=bytes_l%3Aa

SRR23422991 SRR23423005 SRR23423009 SRR23423008

## MultiQC installation
`pip install multiqc`

## Quality Control 
quality_control.py
- This script will run fastqc and multiqc of all librarys

# Execução dos scripts em série
É possível criar um script em Python que invoque outros scripts de forma serial, onde o término de um script dita o início do próximo. Isso pode ser feito utilizando a função subprocess.run() para chamar os scripts sequencialmente.
```
import subprocess

# Chamar o primeiro script
subprocess.run(["python", "script1.py"])

# Chamar o segundo script após o término do primeiro
subprocess.run(["python", "script2.py"])

# Chamar o terceiro script após o término do segundo
subprocess.run(["python", "script3.py"])

# E assim por diante...
```
d
