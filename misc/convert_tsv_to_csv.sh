#!/bin/bash

for arquivo in *.tabular; do
    awk 'BEGIN {FS="\t"; OFS=","} {$1=$1} 1' "$arquivo" > "${arquivo%.tabular}.csv"
done

