
getwd()

setwd("C:\\Users\\mgaldino\\2017\\Geral TB\\Treinamento\\R\\r_smart_way\\Arquivos")

idh <- read.table(file="IDH_Brasil.csv", sep="\t", header=T)

dim(idh)
head(idh, 3)
tail(idh, 1)
View(idh)

idh_brasil <- read.table(file="IDH_Brasil.csv", sep="\t", header=T,
                         col.names = c("UF", 1991:2005))
head(idh)

library(dplyr)
library(tidyr)

idh_g <- gather(data = idh, key=ano, value=idh, -UF)
head(idh_g)
View(idh_g)

acoes <- data_frame(
  tempo = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)

## criando data de forma repetitiva e tediosa. O que queremos evitar!
c(as.Date('2009-01-01'), as.Date('2009-01-02'), as.Date('2009-01-03'),
  as.Date('2009-01-04'), as.Date('2009-01-05'), as.Date('2009-01-06'),
  as.Date('2009-01-07'), as.Date('2009-01-08'), as.Date('2009-01-09'),
  as.Date('2009-01-10'))

acoes
acoes_g <- gather(data=acoes, key=nome_da_acao, value=valorizacao, -tempo)

acoes_g_1 <- gather(data=acoes, key=nome_da_acao, value=valorizacao, c(X, Y, Z))

head(acoes_g_1)
tail(acoes_g)
acoes_g
View(acoes_g)

## explicando data rapidamente
data_ex <- "2017-10-23"
data_ex1 <- as.Date(data_ex)

data_ex1 + 0:9
## fim da explicação rápida de data


acoes_g_1 <- gather(data=acoes, key=nome_da_acao, value=valorizacao, c(X, Y, Z))

idh <- gather(data = idh, key=ano, value=idh, -UF)

idh_g2 <- idh %>% 
  gather(key=ano, value=idh, -UF)

head(idh_g2)




idh_g <- idh %>%
  gather(ano, idh, -UF) %>%
  mutate(ano = gsub("X", "", ano))
  
head(idh_brasil_g)


