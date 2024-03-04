# some bash scripts used in bioinformatics research

## `fastq_donwload_input.py`
- This script allows the user to download SRA libraries by their SRR id.
- small single-end (random) libraries will be selected - https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP422037&o=bytes_l%3Aa

SRR23422991
SRR23423005
SRR23423009
SRR23423008

## FastQC query
fastqc --outdir fastqc/ fastqc fastq/*.fastq.gz

## multiqc installation
pip install multiqc

## `quality_control.py`
- This script will run fastqc and multiqc of all librarys

# Execução no terminal
Para executar scripts em série no terminal Linux, onde a execução de um script só pode ser realizada após o término do anterior, você pode usar operadores de controle de fluxo, como && ou ;, ou você pode encadear os comandos usando &&. Aqui estão algumas maneiras de fazer isso:

    Usando && para encadear os comandos: Desta forma, o próximo comando só será executado se o anterior for concluído com sucesso:

bash

comando1 && comando2 && comando3

Por exemplo:

bash

./script1.sh && ./script2.sh && ./script3.sh

    Usando ; para separar os comandos: Esta forma executa os comandos sequencialmente, independentemente do sucesso ou falha do comando anterior:

bash

comando1 ; comando2 ; comando3

Por exemplo:

bash

./script1.sh ; ./script2.sh ; ./script3.sh

    Usando uma linha de comando única com && para todos os scripts:

bash

./script1.sh && ./script2.sh && ./script3.sh

Neste caso, cada script só será executado se o anterior for concluído com sucesso.

Escolha o método que melhor atende às suas necessidades e à lógica do seu fluxo de trabalho.
