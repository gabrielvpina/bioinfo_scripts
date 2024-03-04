import subprocess

# create a new directory
dir_name = "fastqc"

# Execute mkdir
subprocess.run(["mkdir", dir_name])


# FastQC
# fastqc = "fastqc --noextract --nogroup --outdir fastqc/ fastqc fastq/*.fastq.gz"
fastqc = "fastqc --outdir fastqc/ fastqc fastq/*.fastq.gz"
print ("The command used was: " + fastqc)
subprocess.call(fastqc, shell=True)

# MultiQC
multiqc = "multiqc fastqc/"
subprocess.call(multiqc, shell=True)



