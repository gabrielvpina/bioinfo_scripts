# Processando os dados do diamond

## Query basica:

`./diamond blastx -d reference -q reads.fasta -o matches.tsv`

## Query usada: 

`./diamond blastx -d viralDB.dmnd -q SRR7172360_scaffolds.fasta --outfmt '6' qseqid sseqid qlen slen pident evalue bitscore stitle full_qseq --max-target-seqs '1' --out metaviraldmd.tsv`

## Colunas separadas por tab:

`qseqid	sseqid	qlen	slen	pident	evalue	bitscore	stitle	full_qseq`	

## As colunas são adicionadas na primeira linha do arquivo de saída.

qseqid - Query Seq - id
sseqid - Subject Seq - id
qlen - Query sequence length
slen - Subject sequence length
pident - Percentage of identical matches*
evalue - Expect value
stitle - Subject Title
full_qseq - Full query sequence

# 1) Filtro 

`grep -i 'RdRp\|RNA-dependent\|capsid\|coat\|replicase\|glycoprotein\|replicase\|nucleoprotein\|nucleocapsid' arquivo.tsv > arquivoFiltrado.tsv`
