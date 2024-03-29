# Carregar bibliotecas necessárias
library(rvest)
library(stringr)
library(dplyr)

# URL do site
url <- "https://maricainfo.com/itinerarios-dos-onibus-vermelhinhos-marica"

# Baixar dados do site
webpage <- read_html(url)

# Extrair texto
text <- html_text(webpage)

# Remover parágrafos, espaços e quebras de linha
# text <- gsub("\\s+", "", text)
text <- gsub("\n", "", text)

# Remover todos os elementos antes de E01 e todos depois de PRAÇA DO FERREIRINHA
text <- str_extract(text, "E01.*PRAÇA DO FERREIRINHA")

# Quebrar uma linha sempre que encontrar o padrão regex LINHA E10 ou LINHA E10A
text <- str_replace_all(text, "E\\d+[A-Z]?", "\n\\0")

# Dividir o texto em um vetor de linhas
lines <- str_split(text, "\n")[[1]]

# Criar um data frame com as linhas de ônibus
df <- data.frame(Linha = lines)

# Visualizar o data frame


