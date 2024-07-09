import time
import xmltodict
from collections import defaultdict
from Bio import Entrez
import argparse

def get_entrez_protein_summaries_by_ids(protein_ids, email):
    """Returns the 'Summary' contents for provided protein IDs
    from the Entrez Protein database.
    
    Args:
        protein_ids (list): List of protein IDs (e.g., ['XP_001234567.1', 'XP_987654321.1'])
        email (string): Required email for making requests
        
    Returns:
        list of dict: Summaries for all protein IDs
    """
    Entrez.email = email

    protein_summaries = []
    
    #print(f"{len(protein_ids)} protein IDs provided for summary retrieval.")
    for protein_id in protein_ids:
        #print(f"\tRetrieving summary for protein ID {protein_id}...")
        handle = Entrez.efetch(db="protein", id=protein_id, rettype="ipg", retmode="text")
        protein_summary_bytes = handle.read()
        handle.close()
        
        protein_summary = protein_summary_bytes.decode('utf-8')
        protein_summary_lines = protein_summary.strip().split('\n')
        
        headers = protein_summary_lines[0].split('\t')
        values = protein_summary_lines[1].split('\t')
        
        protein_data = dict(zip(headers, values))
        protein_summaries.append(protein_data)
        
        time.sleep(0.34)  # Requests to NCBI are rate limited to 3 per second

    return protein_summaries

def read_protein_ids_from_file(file_path):
    """Reads protein IDs from a file where each line contains a single protein ID."""
    with open(file_path, 'r') as file:
        protein_ids = [line.strip() for line in file.readlines()]
    return protein_ids

def main():
    parser = argparse.ArgumentParser(description='Fetch protein summaries from Entrez Protein database.')
    parser.add_argument('email', type=str, help='Email address for NCBI Entrez.')
    parser.add_argument('file', type=str, help='Path to the file containing protein IDs (one per line).')

    args = parser.parse_args()
    email = args.email
    file_path = args.file

    protein_ids = read_protein_ids_from_file(file_path)
    summaries = get_entrez_protein_summaries_by_ids(protein_ids, email)

    # Extract headers for the table
    if summaries:
        headers = summaries[0].keys()
        # Print the table headers
        print('\t'.join(headers))
        # Print each protein summary as a row in the table
        for summary in summaries:
            row = [summary.get(header, '') for header in headers]
            print('\t'.join(row))

if __name__ == "__main__":
    main()
