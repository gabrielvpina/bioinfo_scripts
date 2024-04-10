#!/bin/bash

# Defina seu email para identificação ao usar o Entrez
email="gvprodrigues.ppggbm@uesc.br"

# Número de acesso da montagem RefSeq
assembly_accession="GCF_006538345.1"  # Substitua pelo número de acesso da sua montagem

# Consulta ao Entrez para obter informações sobre a montagem RefSeq
esearch -db assembly -query "$assembly_accession" | esummary | xtract -pattern DocumentSummary \
        -def "NA" -element AssemblyAccession,Taxid,assembly-status -block Stat \
        -if Stat@category -equals contig_count -or Stat@category -equals contig_l50 \
        -or Stat@category -equals contig_n50 -or Stat@category -equals total_length \
        -sep "," -def "NA" -element Stat@category,Stat \
        
        >> All-bacteria-refseq-complete-assembly-info.tsv
# Exemplo de execução:
# ./get_genome_size.sh

