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

