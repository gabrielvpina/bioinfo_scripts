import time
import xmltodict
from Bio import Entrez
import argparse

def get_gene_ids_from_transcripts(transcript_ids, email):
    """Returns the gene IDs associated with provided transcript IDs from Entrez Nucleotide database."""
    Entrez.email = email
    gene_ids = []

    #print(f"{len(transcript_ids)} transcript IDs provided for gene ID retrieval.")
    for transcript_id in transcript_ids:
        #print(f"\tRetrieving gene ID for transcript ID {transcript_id}...")
        handle = Entrez.elink(dbfrom="nuccore", id=transcript_id, linkname="nuccore_gene")
        result = Entrez.read(handle)
        handle.close()

        try:
            gene_id = result[0]["LinkSetDb"][0]["Link"][0]["Id"]
            gene_ids.append(gene_id)
        except (IndexError, KeyError):
            None
            #print(f"No gene ID found for transcript ID {transcript_id}")

        time.sleep(0.34)  # Requests to NCBI are rate limited to 3 per second

    return gene_ids

def get_entrez_gene_summaries_by_ids(gene_ids, email):
    """Returns the 'Summary' contents for provided gene IDs from the Entrez Gene database."""
    Entrez.email = email
    gene_summaries = []

    #print(f"{len(gene_ids)} gene IDs provided for summary retrieval.")
    for gene_id in gene_ids:
        #print(f"\tRetrieving summary for gene ID {gene_id}...")
        handle = Entrez.efetch(db="gene", id=gene_id, rettype="docsum", retmode="xml")
        gene_dict = xmltodict.parse(handle.read())
        handle.close()

        gene_summaries_list = gene_dict["eSummaryResult"]["DocumentSummarySet"]["DocumentSummary"]
        if isinstance(gene_summaries_list, list):
            for gene_docsum in gene_summaries_list:
                gene_data = extract_gene_data(gene_docsum, gene_id)
                gene_summaries.append(gene_data)
        else:
            gene_docsum = gene_summaries_list
            gene_data = extract_gene_data(gene_docsum, gene_id)
            gene_summaries.append(gene_data)

        time.sleep(0.34)  # Requests to NCBI are rate limited to 3 per second

    return gene_summaries

def extract_gene_data(gene_docsum, gene_id):
    """Extracts relevant data from gene document summary."""
    gene_data = {
        'GeneID': gene_id,
        'GeneName': gene_docsum.get("Name", "Unknown"),
        'GeneDescription': gene_docsum.get("Description", "No description available"),
        'Summary': gene_docsum.get("Summary", "No summary available"),
        'Organism': gene_docsum.get("Organism", {}).get("ScientificName", "Unknown")
    }
    return gene_data

def get_transcript_info(transcript_ids, email):
    """Returns transcript information including gene ID, gene name, gene description, protein ID, and protein accession."""
    gene_ids = get_gene_ids_from_transcripts(transcript_ids, email)
    if not gene_ids:
        #print("No gene IDs found for the provided transcript IDs.")
        return []

    gene_summaries = get_entrez_gene_summaries_by_ids(gene_ids, email)
    transcript_info = []

    for transcript_id, gene_id in zip(transcript_ids, gene_ids):
        # Get protein ID associated with the gene
        protein_id = get_protein_id_from_gene(gene_id, email)

        # Get protein accession from protein ID
        protein_accession = get_protein_accession(protein_id, email)

        # Prepare transcript information
        transcript_data = {
            'TranscriptID': transcript_id,
            'GeneID': gene_id,
            'GeneName': next((gene['GeneName'] for gene in gene_summaries if gene['GeneID'] == gene_id), "Unknown"),
            'GeneDescription': next((gene['GeneDescription'] for gene in gene_summaries if gene['GeneID'] == gene_id), "No description available"),
            'ProteinID': protein_id,
            'ProteinAccession': protein_accession
        }
        transcript_info.append(transcript_data)

    return transcript_info

def get_protein_id_from_gene(gene_id, email):
    """Returns the protein ID associated with the given gene ID."""
    Entrez.email = email
    protein_id = ""

    handle = Entrez.elink(dbfrom="gene", id=gene_id, linkname="gene_protein")
    result = Entrez.read(handle)
    handle.close()

    try:
        protein_id = result[0]["LinkSetDb"][0]["Link"][0]["Id"]
    except (IndexError, KeyError):
        print(f"No protein ID found for gene ID {gene_id}")

    return protein_id

def get_protein_accession(protein_id, email):
    """Returns the protein accession associated with the given protein ID."""
    Entrez.email = email
    protein_accession = ""

    handle = Entrez.efetch(db="protein", id=protein_id, rettype="acc", retmode="text")
    protein_accession = handle.read().strip()
    handle.close()

    return protein_accession

def read_ids_from_file(file_path):
    """Reads IDs from a file where each line contains a single ID."""
    with open(file_path, 'r') as file:
        ids = [line.strip() for line in file.readlines()]
    return ids

def main():
    parser = argparse.ArgumentParser(description='Fetch gene and transcript information from Entrez Gene and Nucleotide databases.')
    parser.add_argument('email', type=str, help='Email address for NCBI Entrez.')
    parser.add_argument('file', type=str, help='Path to the file containing transcript IDs (one per line).')

    args = parser.parse_args()
    email = args.email
    file_path = args.file

    transcript_ids = read_ids_from_file(file_path)
    transcript_info = get_transcript_info(transcript_ids, email)

    # Print the table headers
    headers = list(transcript_info[0].keys()) if transcript_info else []
    if headers:
        print('\t'.join(headers))

        # Print each transcript info as a row in the table
        for info in transcript_info:
            row = [str(info.get(header, '')) for header in headers]
            print('\t'.join(row))

if __name__ == "__main__":
    main()
