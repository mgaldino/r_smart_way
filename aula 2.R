
getwd()

setwd("C:\\Users\\mgaldino\\2017\\Geral TB\\Treinamento\\R\\r_smart_way\\Arquivos")

idh_brasil <- read.table(file="IDH_Brasil.csv", sep="\t", header=T)
dim(idh_brasil)
head(idh_brasil)
tail(idh_brasil)
View(idh_brasil)

idh_brasil <- read.table(file="IDH_Brasil.csv", sep="\t", header=T,
                         col.names = c("UF", 1991:2005))
head(idh_brasil)

library(dplyr)
library(tidyr)

idh_brasil_g <- gather(idh_brasil, ano, idh, -UF)
head(idh_brasil_g)
View(idh_brasil_g)


idh_brasil_g <- idh_brasil %>%
  gather(ano, idh, -UF) %>%
  mutate(ano = gsub("X", "", ano))
  
head(idh_brasil_g)


