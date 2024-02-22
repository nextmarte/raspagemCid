import requests
from bs4 import BeautifulSoup
import pandas as pd
import re

# Baixar o conteúdo da página
url = "https://maricainfo.com/itinerarios-dos-onibus-vermelhinhos-marica"
response = requests.get(url)

# Analisar o conteúdo HTML
soup = BeautifulSoup(response.text, 'html.parser')

# Encontrar todos os parágrafos
paragraphs = soup.find_all('p')

# Remover tags HTML e substituir quebras de linha e parágrafos por espaços
cleaned_text = [re.sub('<.*?>', '', str(p)) for p in paragraphs]
cleaned_text = [re.sub('\n', ' ', str(p)) for p in cleaned_text]
cleaned_text = [re.sub('\r', ' ', str(p)) for p in cleaned_text]

# Criar um DataFrame vazio
df = pd.DataFrame(columns=['LINHA', 'Origem x Destino', 'IDA', 'VOLTA'])

# Preencher o DataFrame
for text in cleaned_text:
    if text.startswith('LINHA'):
        split_text = text.split(' ')
        linha = split_text[1]
        origem_destino = ' '.join(split_text[3:split_text.index('IDA:')])
        ida = ' '.join(split_text[split_text.index('IDA:')+1:split_text.index('VOLTA:')])
        volta = ' '.join(split_text[split_text.index('VOLTA:')+1:])
        df = df.append({'LINHA': linha, 'Origem x Destino': origem_destino, 'IDA': ida, 'VOLTA': volta}, ignore_index=True)

# Salvar o DataFrame
df.to_csv('itinerarios.csv', index=False)