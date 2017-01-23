## Aula 5 -- gpplot2

#############
### GGPLOT2
#############

## Visualização
## Gramática dos gráficos

url <- "http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt"
gdp <- read.table(url, header=T, sep="\t") 
head(gdp)
summary(gdp)


## lógica do ggplot
## primeiro ,passar o banco de dados
## segundo, passar os componentes estéticos (aesthetics), dado pelo arg aes
# terceiro, passar a geometira (se é barra, ponto, linha etc)

library(ggplot2)

ggplot(data=gdp, aes(x= pop, y=gdpPercap)) + geom_point()
## geom_point() é é a geomtria de pontos
## aes passa eixo x e eixo y

## cada "+" adicionar um layer ou camada
## primeiro é pra dizer quais os dados e em quais eixos
## segundo é layer com tipo de gráfico
## há mais layers

## usando o pipe
library(dplyr)
gdp %>%
  ggplot(aes(x= pop, y=gdpPercap)) + geom_point()

## algo bacana é que dá pra guardar o plot num objeto

p <- gdp %>%
  ggplot( aes(x= pop, y=gdpPercap))

p # no layers in plot
p <- p +  geom_point()
p

## superimposing layers
p1 <- p + geom_line(aes(x=pop, y=gdpPercap))
p1 # dois layers de geom, ponto e linha!

# se q1uiser so linha
p2 <-  ggplot(data=gdp, aes(x= pop, y=gdpPercap)) + geom_line(aes(x=pop, y=gdpPercap))
p2

## transparencia
p3 <- ggplot(data=gdp, aes(x= pop, y=gdpPercap))
p3 <- p3 + geom_point(alpha=.5)
p3

# cores por pontos
p4 <- ggplot(data=gdp, aes(x= pop, y=gdpPercap, color=continent))
p4 <- p4 + geom_point()
p4

# shape, mas prefiro cor
p5 <- ggplot(data=gdp, aes(x= pop, y=gdpPercap, shape=continent))
p5 <- p5 + geom_point()
p5

## facet
p6 <- ggplot(data=gdp, aes(x= pop, y=gdpPercap))
p6 <- p6 + geom_point() + facet_grid(continent ~ .)
p6

p6 <- p6 + geom_point() + facet_grid(. ~ continent )
p6

## portanto, ordem do facet determina como vai quebrar os dados

## melhorando os gráficos

p4 <- p4 + xlab("population") + ylab("gdp per capita")
p4

p4 <- p4 + labs(title= "PIB per capita x POP")
p4

## escalar de pop tá ruim
## vamos usar library(scales)

library(scales)
p4 <- p4 + scale_x_continuous(labels=comma)
p4

## themes

## adaptado de http://docs.ggplot2.org/dev/vignettes/themes.html
## vamos usar os dados mpg

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = factor(cyl))) +
  geom_jitter() +
  labs(
    x = "milhas cidade/galões",
    y = "milhas estrada/galões",
    color = "Cilindrada"
  )
p5

## objetivos

# mudar a cor do display
# mudar tamanho da fonte dos labels
# remover grid line
# mover a legenda para dentro do gráfico
# mudar a cor do background

p5 <- p5 +
  scale_colour_brewer(type = "seq", palette = "Oranges")

p5

# o que não depende dos dados, nós usamos themes
# básico, theme_gray()

theme_gray
theme_gray()

p5 + theme_gray()

p5 + theme_bw()

## ou criar nosso próprio theme

p5 + theme(
  axis.text = element_text(size = 14),
  legend.key = element_rect(fill = "navy"),
  legend.background = element_rect(fill = "white"),
  legend.position = c(0.14, 0.80),
  panel.grid.major = element_line(colour = "grey40"),
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "navy")
)

## tem themes pra gráficos tipo economist, etc.

## fiz um pra tb
## Theme for Tranasparência Brasil

theme_tb <- function(base_size = 12, base_family = "calibri", legenda="none", dir.Legenda="horizontal") {
  theme(
    line = element_line(),
    axis.title = element_text(size=base_size),
    axis.text = element_text(size=14),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.background = element_rect(),
    legend.position = legenda,
    legend.direction = dir.Legenda,
    legend.box = "vertical",
    panel.grid = element_line(colour = NULL),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    strip.background=element_rect())
}


p5 + theme_tb()


