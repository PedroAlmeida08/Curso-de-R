## Organizando os dados de forma tidy
#Arrumar os dados de forma que as linhas sejam eventos e as colunas sejam 
#atributos do evento ajuda muito a rodar modelos e construir visualizações 
#eficientemente. Esta forma de organização foi chamada de Tidy data" por Hadley 
#Wickham, o criador do conjunto de bibliotecas `Tidyverse`

#O que é o evento e o que é o atributo pode variar até para diferentes usos do 
#mesmo dado. Mas a prática ajuda a determinar isso.

#Colunas --> Variáveis
#Linhas --> Observações
#Campos --> Valores

## Tratamento de dados em passos: operador Pipe (`%>%`)
#O operador pipe, representado por %>% é extremamente útil para análise de dados
#no R com uso das bibliotecas Tidyverse

#dados de exemplo
head(gapminder)

#Vamos imaginar que queremos a média de PIB per capita por continente em 2007.
#Note quanto código desnecessário há nestas linhas: variáveis que não precisavam
#ser nomeadas nem passadas explicitamente como parâmetro.
#Este código desnecessário causa fadiga no programador, confunde o próprio autor
#do código e confunde ainda mais o leitor posterior do código.

gapminder_07 <- filter(gapminder, year == 2007)
gapminder_07_group_continente <- group_by(gapminder_07, continent)
gapminder_media_gdp_continente <- summarise(
  gapminder_07_group_continente, media_gdp = sum(gdpPercap * pop)/sum(pop)
)
resultado <- arrange(gapminder_media_gdp_continente, desc(media_gdp))

resultado

## Tratamento de dados em passos: operador Pipe (%>%)

#O operador pipe %>% faz o seguinte: x %\>% y(z) = y(x,z)

#Ou seja, o primeiro operando é enfiado como primeiro parâmetro da função que 
#está no segundo operando.

#Isso faz com que possamos escrever o código anterior assim:
  
resultado <- gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
  summarise(
    media_gdp = sum(gdpPercap * pop) / sum(pop)
  ) %>% 
  arrange(desc(media_gdp))

resultado

# Ctrl + Shift + M = %>%