# This command extract the transcript_id code and protein_id code of a gtf file.

grep -E 'transcript_id|protein_id' annot.gtf | sed -E 's/.*transcript_id "([^"]+)".*protein_id "([^"]+)".*/\1 \2/'
