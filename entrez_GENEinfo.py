import time
import xmltodict
from collections import defaultdict
from Bio import Entrez
import argparse

def get_entrez_gene_summaries_by_ids(gene_ids, email):
    """Returns the 'Summary' contents for provided gene IDs
    from the Entrez Gene database.
    
    Args:
        gene_ids (list): List of gene IDs (e.g., ['1234', '5678'])
        email (string): Required email for making requests
        
    Returns:
        dict: Summaries for all gene IDs (keys → gene ID, values → gene summary)
    """
    Entrez.email = email

    gene_summaries = defaultdict(dict)
    
    print(f"{len(gene_ids)} gene IDs provided for summary retrieval.")
    for gene_id in gene_ids:
        print(f"\tRetrieving summary for gene ID {gene_id}...")
        handle = Entrez.efetch(db="gene", id=gene_id, rettype="docsum")
        gene_dict = xmltodict.parse(
            "".join([x.decode(encoding="utf-8") for x in handle.readlines()]),
            dict_constructor=dict,
        )
        handle.close()
        
        # Check if there are multiple summaries returned
        gene_summaries_list = gene_dict["eSummaryResult"]["DocumentSummarySet"]["DocumentSummary"]
        if isinstance(gene_summaries_list, list):
            for gene_docsum in gene_summaries_list:
                name = gene_docsum.get("Name")
                summary = gene_docsum.get("Summary")
                gene_organism = gene_docsum.get("Organism")["CommonName"]
                gene_summaries[gene_organism][name] = summary
        else:
            gene_docsum = gene_summaries_list
            name = gene_docsum.get("Name")
            summary = gene_docsum.get("Summary")
            gene_organism = gene_docsum.get("Organism")["CommonName"]
            gene_summaries[gene_organism][name] = summary
        
        time.sleep(0.34)  # Requests to NCBI are rate limited to 3 per second

    return gene_summaries

def read_gene_ids_from_file(file_path):
    """Reads gene IDs from a file where each line contains a single gene ID."""
    with open(file_path, 'r') as file:
        gene_ids = [line.strip() for line in file.readlines()]
    return gene_ids

def main():
    parser = argparse.ArgumentParser(description='Fetch gene summaries from Entrez Gene database.')
    parser.add_argument('email', type=str, help='Email address for NCBI Entrez.')
    parser.add_argument('file', type=str, help='Path to the file containing gene IDs (one per line).')

    args = parser.parse_args()
    email = args.email
    file_path = args.file

    gene_ids = read_gene_ids_from_file(file_path)
    summaries = get_entrez_gene_summaries_by_ids(gene_ids, email)

    # Print the summaries
    for org, genes in summaries.items():
        print(f"Organismo: {org}")
        for gene, summary in genes.items():
            print(f"Gene: {gene}\nResumo: {summary}\n")

if __name__ == "__main__":
    main()
