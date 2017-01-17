## Aula 3
## Manipulando dados com dply

# Vamos usar o banco de dados da CGM de pedidos respondidos
# para isso, vamos importar dados do google docs

# Instalapem o pacote googlesheets
#install.packages("googlesheets")


## carregando bibliotecas que vamos usar
library(dplyr)
library(tidyr)
library(googlesheets)

## url do drive 

url_drive <- "https://docs.google.com/spreadsheets/d/1uIz0YdkhpJ7jKoIDyfT7woOGdJBjt1L4OU0ar2r3zAA/edit?usp=sharing"

# podem acessar no navegador
browseURL(url_drive)

# agora vamos importar os dados no R

# primeiro atenticando conta do gmail (pode ser a da TB)
gs_ls()

## R vai listar planilhas disponsíveis
## escolhe o sheet_title GCM
## e usa gs_title para acessar o conteúdo

gcm_sheet <- gs_title("GCM")


##Agora, vamos criar nosso data.frame da aba que queremos
gcm_resposta <- gcm_sheet %>%
  gs_read(ws = "resposta")

# verificando que importação deu certo

# dimensões
dim(gcm_resposta)

# nomes das colunas
names(gcm_resposta)

# cabeçalho
head(gcm_resposta)

# vendo o banco
View(gcm_resposta)

# salvando objeto, para não ter que acessar drive em outras sessões

setwd("C:\\Users\\mgaldino\\2017\\Geral TB\\Treinamento\\R\\r_smart_way\\Arquivos")
save(gcm_resposta, file="gcm_resposta.RData")

# para carregar depois, basta usar load (se for objeto do tipo RData)
# load("gcm_resposta.RData")

#########################################################
## Agora, vamos manipular a tabela, utilizando o Dplyr
###########################################################

# Dplyr
# A lógica do dplyr é que cada manipulação tem um verbo, ou comando, que executa a manipulação
## Principais verbos

# filter() (and slice())
# arrange()
# select() (and rename())
# distinct()
# mutate() (and transmute())
# summarise()

# exemplos

# filter é como o filtro do excel ou where no SQL
# Vamos usar sempre o pipe operator
# primeiro passa o data.frame, depois fazemos o filtro.

# Vamos filtrar o banco com os pedidos finalizados
gcm_filtro1 <- gcm_resposta %>%
  filter(status_nome == "Finalizado")

head(gcm_filtro1)


# podemos ter mais de um filtro
# exemplos, Finalizado e Atendido

gcm_filtro2 <- gcm_resposta %>%
  filter( status_nome %in% c("Finalizado", "Atendido"))

head(gcm_filtro2)

## equivalente
gcm_filtro3 <- gcm_resposta %>%
  filter( status_nome == "Finalizado" | status_nome == "Atendido") # | símbolo de ou

# validando que são iguais
all.equal(gcm_filtro2, gcm_filtro3)

## Posso filtrar por mais de uma coluna
## Exemplo, status finalizado e data menor que 20 de janeiro 2014
##

gcm_filtro4 <- gcm_resposta %>%
  filter( status_nome == "Finalizado" & dt_resposta_atendimento < "2014-01-20") #

# Operadores lógicos básicos do R: == para testar igualdade, ! para negação, & para e; | para ou
View(gcm_filtro4)

# Data no R. Se usarmos o read.table para importar um arquivo,
# o R não vai ler formato data como data. Deve ser convertido.
# depois explico como faz.


# para filtrar linhas

gcm_resposta %>%
  slice(1:6) # equivalente a head

gcm_resposta %>%
  slice(dt_resposta_atendimento > "2014-01-20") # não funciona

## correto é:
gcm_resposta %>%
  filter(dt_resposta_atendimento > "2014-01-20")

## arrange
## ordena o banco pelas colunas

gcm_ordena_data <- gcm_resposta %>%
  arrange(dt_resposta_atendimento) # ordena do menor pro maior

View(gcm_ordena_data)

gcm_ordena_data1 <- gcm_resposta %>%
  arrange(desc(dt_resposta_atendimento)) # descendent order

View(gcm_ordena_data1)

## select

# primeiro ,vamos ver os nomes das nossas variáveis/colunas
names(gcm_resposta)

## selecionar algumas colunas
## usar nomes das colunas sem aspas
gcm_resposta1 <- gcm_resposta %>%
  select(  id, orgao_nome, dt_resposta_atendimento, dc_resposta) 


View(gcm_resposta1)

# outros selects
# todas as colunas entre id e dt_resposta_atendimento, inclusive
gcm_resposta %>%
  select(id:orgao_nome)

gcm_resposta %>%
  select(-(id:orgao_nome)) # menos essas colunas

# ver o help pra mais formas de usar select

# renomear
# use rename

gcm <- gcm_resposta %>%
  rename(id_interacao = id,
         id_status = cd_status_atendimento_pedido,
         status = status_nome,
         id_pedido = cd_pedido,
         conteudo_interacao = dc_pedido,# evitar usar acento em nome de coluna
         data_interacao = dt_resposta_atendimento,
         conteudo_resposta = dc_resposta) 

names(gcm)
View(gcm)

## selecionar únicos
## útil pra validar e outras coisas
# exemplo, pegar orgaos únicos

gcm_unico_orgao <- gcm %>%
  distinct(orgao_nome)

View(gcm_unico_orgao)

# job, excluir cpfs repetidos
# várias maneiras de fazer, vamos usar dply

## Adicionando novas colunas
## mutate

# Quais interações ocorreram após 2015?
# vou criar nova coluna, bol_maior2015

gcm2 <- gcm %>%
  mutate(bol_maior2015 = data_interacao > "2015-01-01")

View(gcm2)

# quero zero ou 1, não TRUE ou FALSE
gcm2 <- gcm %>%
  mutate(bol_maior2015 = as.numeric(data_interacao > "2015-01-01")) # as numeric transforma em número

View(gcm2)

# posso adicionar várias variáveis de uma vez

gcm2 <- gcm %>%
  mutate(bol_maior2015 = as.numeric(data_interacao > "2015-01-01"),
         bol_maior_data_mediana = as.numeric(data_interacao > median(data_interacao)))

View(gcm2)

# last, but not least, summarise
# transforma a tabela numa única linha (soma, tira média)

gcm %>%
  summarise(data_interacao_mediana = median(data_interacao),
            data_interacao_mais_antiga = min(data_interacao),
            data_interacao_mais_nova = max(data_interacao))

## Todos os verbos compartilham algumas características

## 1. O primeiro argumento é uma tabela/data.frame (ou usando o pipe, data.frame vem antes do pipe)
## 2. os argumentos seguintes descrevem o que fazer com a tabela e 
## 3. os verbos sempre retornam uma tabela (portanto em geral vamos atribuir resultado a nova tabela)

## isso permite encadearmos vários verbos

## E é poderoso quando usamos o operador group_by

## Quando fazemos uma tabela dinâmica, o que em geral queremos fazer é
## aplicar o que chamamos de estratégia split, apply, combine
## ou seja

## 1. Split (divida) o banco de dados de acordo com uma ou mais variáveis
## 2. aplique uma função em cada um dos sub banco de dados
## 3. combine tudo num novo banco

## Quero número de interações por órgão

## Passo 1: split: group_by orgao_nome
## passo 2: calcular estatística: número de linhas por interação , n()
## passo trÊs, retornar um banco: comando summarise

num_int_orgao <- gcm %>%
  group_by(orgao_nome) %>%
  summarise(n()) # n() me dá o número de linhas

num_int_orgao
## Mais complexo
## Top 10 órgãos
## com mais pedidos

gcm %>%
  group_by(id_pedido) %>%
  summarise(n_distinct(id_pedido))

top_orgaos_geral <- gcm %>%
  mutate(total_pedidos = n_distinct(id_pedido)) %>%
  group_by(orgao_nome) %>%
  summarise(num_pedidos = n_distinct(id_pedido),
            total = max(total_pedidos),
            perc_total = round(num_pedidos/total, 2)) %>%
  arrange(desc(num_pedidos)) %>%
  slice(1:10)

View(top_orgaos_geral)


## Quantos pedidos por status?

## issues
## Cada linha uma interação
## quando finaliza, há uma interação chamada finalizado. Precisamos remover
## Vamos supor que última interação é o status final do pedido.

top_status <- gcm %>%
  filter(status != "Finalizado") %>%
  group_by(id_interacao) %>%
  summarise(last_status = last(status)) %>%
  mutate(total_pedidos = n_distinct(id_interacao)) %>%
  group_by(last_status) %>%
  summarise(num_pedidos = n_distinct(id_interacao),
            total = max(total_pedidos),
            perc_total = round(num_pedidos/total, 2)) %>%
  select(-3) %>%
  arrange(desc(num_pedidos))

View(top_status)

### Tempo por pedido



## More resources
# http://datasciencelv.github.io/R-UsersGroup/2nd_Meetup/dplyr-tidyr.html#/7
# https://rpubs.com/m_dev/tidyr-intro-and-demos
# http://gastonsanchez.com/work/webdata/getting_web_data_r5_json_data.pdf
# http://gastonsanchez.com/work/webdata/getting_web_data_r8_web_apis.pdf




