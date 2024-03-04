import subprocess

# This script allows the user to download SRA libraries by their SRR id 
entry = input("-> Enter the SRA library runs separated by space: ")
user_input = entry.split()
sra_numbers = user_input

user_path = input("-> Insert destination folder path here:")


# this will download the .sra files to ~/ncbi/public/sra/ (will create directory if not present)
for sra_id in sra_numbers:
    print ("Currently downloading: " + sra_id)
    prefetch = "prefetch " + sra_id
    print ("The command used was: " + prefetch)
    subprocess.call(prefetch, shell=True)

# this will extract the .sra files from above into a folder named 'fastq'
for sra_id in sra_numbers:
    print ("Generating fastq for: " + sra_id)
    # insert destination folder path here
    sra_file_path = user_path + sra_id + "/" + sra_id + ".sra"
    fastq_dump = "fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip " + sra_file_path
    print ("The command used was: " + fastq_dump)
    subprocess.call(fastq_dump, shell=True)

