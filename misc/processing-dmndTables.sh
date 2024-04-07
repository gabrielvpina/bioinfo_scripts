#!/bin/bash


sed -i 's/\[/\t/g; s/\]//g' metaviraldmd.tsv


echo "QuerySeq	SubjectSeq	QseqLength	SseqLength	Pident	Evalue	BitScore	SubjTitle	Specie	FullQueryLength" | cat - metaviraldmd.tsv > Processmetaviraldmd.tsv && mv Processmetaviraldmd.tsv metaviraldmd.tsv

