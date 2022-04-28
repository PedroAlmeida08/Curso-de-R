#CRAN é o repositório de bibliotecas mantido pelo R com contribuição de 
#populares. Além de funcionalidades estatísticas e funcionalidades para lidar 
#com dados, há dados e funcionalidades para buscar dados online.

#Usaremos várias das bases como exemplo.
#A primeira é a do Banco Mundial, muito rica para quem gosta de dados 
#socioeconômicos: "wbstats"

#Para acessar um indicador precisamos achá-lo na base de indicadores com a 
#função wb_search()

#pattern é uma expressão regular. \\ serve para dizer que "(" é mesmo "(" 
#e não o ( usado nas operações de expressão regular (fora do escopo do curso)
indicadores <- wb_search(pattern = "GINI index \\(World Bank estimate\\)")
indicadores

#Sabendo o ID do indicador, podemos consultá-lo com a função wb_data()
#mrvnev é most recent non-empty values. Pode ser usado para buscar os n valores 
#mais recentes
gini = wb_data(indicator = "SI.POV.GINI", mrv = 10) %>% 
    filter(
        !is.na(SI.POV.GINI)
    )

#A função `select()` é usada para selecionar colunas do data frame/tibble
gini_select <- gini %>% 
    select(country, date, SI.POV.GINI, iso3c)
head(gini_select)
#É possível usar a seleção negativa assim como fizemos com vetores
gini_select2 <- gini_select %>% 
    select(-iso3c)
head(gini_select2)