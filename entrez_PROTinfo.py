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
        dict: Summaries for all protein IDs (keys → protein ID, values → protein summary)
    """
    Entrez.email = email

    protein_summaries = defaultdict(dict)
    
    print(f"{len(protein_ids)} protein IDs provided for summary retrieval.")
    for protein_id in protein_ids:
        print(f"\tRetrieving summary for protein ID {protein_id}...")
        handle = Entrez.efetch(db="protein", id=protein_id, rettype="ipg", retmode="text")
        protein_summary_bytes = handle.read()
        handle.close()
        
        protein_summary = protein_summary_bytes.decode('utf-8')
        
        protein_summaries[protein_id] = protein_summary
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

    # Print the summaries
    for protein_id, summary in summaries.items():
        print(f"Protein ID: {protein_id}\nSummary:\n{summary}\n")

if __name__ == "__main__":
    main()
