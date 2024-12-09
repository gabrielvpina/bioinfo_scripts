#!/bin/bash
#
chmod +x modules/*
#
echo "\n ################### Get all SRR libs \n"
./modules/getSRR.sh
#
#
echo "\n ################### Trimming sequences \n"
mkdir -p "fastp"
./modules/trimmingSE.sh
rm -r "fastq"
#
#
echo "\n ################### Mapping sequences \n"
./modules/mappingSE.sh
rm -r "fastp"
#
#
rename 's/_pass_Unmapped.out.mate1/.fastq/' STAR_unmapped_SE/*

#
echo "\n ################### Compressing files \n"
gzip STAR_unmapped_SE/*.fastq
echo "\n ################### Assembly sequences \n"
./modules/spadesSE.sh
#
#
echo "\n ################### Getting contigs \n"
./modules/getContigs.sh
#
#
echo "\n ################### Formatting Star results \n"
./modules/fastqToFasta.sh
#
#
gzip STAR_unmapped_FASTA/*
rm -r STAR_unmapped

