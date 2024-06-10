#!/bin/bash

# Iterar sobre os diretórios encontrados na pasta spades
for dir in spades/*_assembly; do
    # Verificar se a pasta tem o padrão correto de nome (_assembly)
    if [[ -d "$dir" ]]; then
        # Extrair o nome do diretório (sem extensão)
        samp=$(basename "$dir" _assembly)
        
        # Copiar o arquivo contigs.fasta para assembled_contigs
        cp "$dir/contigs.fasta" "assembled_contigs/${samp}.fasta"
    fi
done
