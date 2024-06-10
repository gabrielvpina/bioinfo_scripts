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


