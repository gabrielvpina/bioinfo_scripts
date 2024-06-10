#!/bin/bash
#
chmod +x modules/*
#
echo "################### Get all SRR libs"
./modules/getSRR.sh
#
#
echo "################### Trimming sequences"
mkdir -p "fastp"
./modules/trimmingPE.sh
#
#
echo "################### Mapping sequences"
./modules/mappingPE.sh
#
#
rename 's/_pass_Unmapped.out.mate1/_01.fastq/' STAR_unmapped/*
rename 's/_pass_Unmapped.out.mate2/_02.fastq/' STAR_unmapped/*
gzip STAR_unmapped/*_01.fastq
gzip STAR_unmapped/*_02.fastq
echo "################### Assembly sequences"
./modules/spadesPE.sh
#
#
echo "################### Getting contigs"
./modules/getContigs.sh
#
#
echo "################### Formatting Star results"
./modules/fastqToFasta.sh

