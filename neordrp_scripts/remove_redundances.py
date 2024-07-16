import re

# Ler o arquivo .hmm
with open("NeoRdRp_Pfam.hmm", "r") as file:
    hmm_lines = file.readlines()

# Novo conteúdo do arquivo .hmm
new_hmm_lines = []

# Dicionário para contar as ocorrências de cada NAME
name_counter = {}

# Processar cada linha do arquivo .hmm
for line in hmm_lines:
    if line.startswith("NAME  "):
        # Extrair o valor do NAME
        name = line.split()[1]
        # Incrementar o contador para este NAME
        if name not in name_counter:
            name_counter[name] = 1
        else:
            name_counter[name] += 1
        # Adicionar o sufixo numérico ao NAME
        new_name = f"{name}{name_counter[name]}"
        new_hmm_lines.append(f"NAME  {new_name}\n")
    else:
        new_hmm_lines.append(line)

# Escrever o novo arquivo .hmm
with open("models_numerados.hmm", "w") as file:
    file.writelines(new_hmm_lines)

print("Processamento concluído. O novo arquivo foi criado como models_numerados.hmm")
