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
text <- gsub("\\s+", "", text)
text <- gsub("\n", "", text)

# Remover todos os elementos antes de E01 e todos depois de PFPRAÇADOFERREIRINHA
text <- str_extract(text, "E01.*PFPRAÇADOFERREIRINHA")

# Quebrar uma linha sempre que encontrar o padrão regex LINHA E10 ou LINHA E10A
text <- str_replace_all(text, "LINHAE\\d+[A-Z]?", "\n\\0")

# Dividir o texto em um vetor de linhas
lines <- str_split(text, "\n")[[1]]

# Criar um data frame com as linhas de ônibus
df <- data.frame(Linha = lines)

# Criar uma nova variável "linha" que extrai a informação da linha de ônibus
df$linha <- str_extract(df$Linha, "E\\d+[A-Z]?")

# Definir as expressões regulares para os percursos de ida e circular
regex_ida = "(?<=IDA).*?(?=VOLTA)"
regex_circular = "(?<=CIRCULAR:).*?(?=LINHA)"

# Usar a função str_extract para extrair as partes correspondentes das strings
ida = str_extract(df$Linha, regex_ida)
circular = str_extract(df$Linha, regex_circular)

# Combinar os resultados em uma única coluna, preenchendo os NA's da 'ida' com os valores de 'circular'
df$ida_percurso = ifelse(is.na(ida), circular, ida)

# Visualizar o data frame
print(df)