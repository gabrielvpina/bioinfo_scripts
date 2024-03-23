import subprocess

# create a new directory
dir_name = "fastqc-post-fastp"
# Execute mkdir
subprocess.run(["mkdir", dir_name])

dir_out = "multiqc-post-fastp"
subprocess.run(["mkdir", dir_out])




# FastQC
# fastqc = "fastqc --noextract --nogroup --outdir fastqc/ fastqc fastq/*.fastq.gz"
fastqc = "fastqc --outdir fastqc-post-fastp/ fastqc fastp/*.fastq.gz"
print ("The command used was: " + fastqc)
subprocess.call(fastqc, shell=True)

# MultiQC
multiqc = "multiqc fastqc/ -o multiqc-post-fastp"
subprocess.call(multiqc, shell=True)

