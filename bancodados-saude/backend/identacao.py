import json
#le o arquivo e faz a conversão
with open("data.json", "r") as f:
    conversao = json.load(f)
#devolve pro data.json reescrito
with open("data.json", "w") as f:
    json.dump(conversao, f, indent=2)