import pandas as pd

# Ler a tabela
tabela = pd.read_csv("annotPfam_noSpace.tsv", sep="\t")

# Ler o arquivo .hmm
with open("NeoRdRp.hmm", "r") as file:
    hmm_lines = file.readlines()

# Dicionário para mapear targets a PfamAnnot
target_to_pfam = dict(zip(tabela['target'], tabela['PfamAnnot']))

# Novo conteúdo do arquivo .hmm
new_hmm_lines = []

# Processar cada linha do arquivo .hmm
for line in hmm_lines:
    if line.startswith("NAME  "):
        # Extrair o target do parâmetro NAME
        target = line.split()[1]
        # Substituir pelo PfamAnnot correspondente, se existir no dicionário
        if target in target_to_pfam:
            new_name = target_to_pfam[target]
            new_hmm_lines.append(f"NAME  {new_name}\n")
        else:
            new_hmm_lines.append(line)
    else:
        new_hmm_lines.append(line)

# Escrever o novo arquivo .hmm
with open("models_novo.hmm", "w") as file:
    file.writelines(new_hmm_lines)

print("Substituições concluídas. O novo arquivo foi criado como models_novo.hmm")
