## Aula 4

### Joins
## O dplyr também tem verbos para duas tabelas
## os joins, que servem para juntar duas tabelas
## Simples exemplo, adaptaod de https://stat545-ubc.github.io/bit001_dplyr-cheatsheet.html

super_heroes <-
  c("    name, alignment, gender,         publisher",
    " Magneto,       bad,   male,            Marvel",
    "   Storm,      good, female,            Marvel",
    "Mystique,       bad, female,            Marvel",
    "  Batman,      good,   male,                DC",
    "   Joker,       bad,   male,                DC",
    "Catwoman,       bad, female,                DC",
    " Hellboy,      good,   male, Dark Horse Comics")
super_heroes <- read.csv(text = super_heroes, strip.white = TRUE)

publishers <- 
  c("publisher, yr_founded",
    "       DC,       1934",
    "   Marvel,       1939",
    "    Image,       1992")
publishers <- read.csv(text = publishers, strip.white = TRUE)

super_heroes
publishers

## objetivo, pegar o ano de fundaçao da revista, e juntar cm superheroes

## verbos
## inner_join, left_join, right_join, full_join etc.
inner_join(super_heroes, publishers)
# perdemos Hell boy

left_join(super_heroes, publishers)

right_join(super_heroes, publishers)

anti_join(super_heroes, publishers)
# deixa o que n tem match


# Tidyr

# What this means is that every column in your data frame represents a variable
# and every row represents an observation. 
# This is also referred to as long format (as opposed to wide format).

# Tidyr tem três verbos básicos: gather(), separate() and spread().

library(tidyr)
library(dplyr)

## exemplo 1
stocks <- data_frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)

stocks
# a gente tem o valor de três ações (x, y, x) em vários dias.
# no banco, a gente tem na verdade uma variável com data, 
# uma variável com os nomes das ações
# e outra com o valor das ações
# tidy data: cada variável tem sua coluna, cada observação é uma linha
# ação não tem coluna, e os nomes das ações são variáveis, não observações.

# verbo gather
# gahter(data.frame, key, value, variáveis to gather)
# com o pipe
# data.frame %>%
#   gather(key, value, variáveis to gather)

stocks %>% 
  gather(acao, preco, c(X, Y, Z)) # variáveis x, y e z to gather

stocks %>% 
  gather(acao, preco, -time) # todas menos time to gather

stocks %>% 
  gather(preco, acao, -time)

## exemplo 2

set.seed(1)
tidyr.ex <- data.frame(
  participant = c("p1", "p2", "p3", "p4", "p5", "p6"), 
  info = c("g1m", "g1m", "g1f", "g2m", "g2m", "g2m"),
  day1score = rnorm(n = 6, mean = 80, sd = 15), 
  day2score = rnorm(n = 6, mean = 88, sd = 8)
)
tidyr.ex

## As colunas day1score e day2score misturam duas colunas:
## uma coluna day, e uma coluna score.

# gather
## banco de dados, pipe, variáveis que vamos mudar
tidyr.ex %>%
  gather(day, score, c(day1score, day2score))

## spread
## é o oposto de gather
## Pega diferentes níveis de uma variável categórica (factor), 
## e os transformam em variáveis
## gather(df, var1 (key), var2 (value))

###
stocks %>% 
  gather(acao, preco, c(X, Y, Z)) %>%
  spread(acao, preco)


tidyr.ex %>%
  gather(day, score, c(day1score, day2score)) %>%
  spread(day, score)
