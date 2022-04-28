#candidate_fed é uma função da biblioteca Elections BR realiza o donwload de
#dados eleitorais direto do TSE de acodo com o ano desejado
candidatos <- candidate_fed(2018) 
head(candidatos)

candidatos_select <- candidatos %>% 
    select(starts_with("NM_"))
head(candidatos_select)

candidatos_select <- candidatos %>% 
    select(contains("MUNICIPIO"))
head(candidatos_select)

candidatos_select <- candidatos %>% 
    select(ends_with("_CANDIDATO"))
head(candidatos_select)

#A função mutate() é usada para criar novas colunas no tibble, mantendo as 
#outras
#Notando que a coluna DATA_ELEICAO é um caracter, vamos criar uma coluna de 
#tipo data.

typeof(candidatos$DT_ELEICAO)

#O jeito mais fácil de fazer isso é usando uma das funções da biblioteca lubridate

candidatos_com_data <- candidatos %>% 
    mutate(DATA_ELEICAO_TIPO_DATA = dmy(DT_ELEICAO)) %>% 
    select(DT_ELEICAO, DATA_ELEICAO_TIPO_DATA)
head(candidatos_com_data)

#Funções derivadas da mutate possibilitam a alteração de várias colunas ao mesmo
#tempo, usando os mesmos helpers que já vimos para a select e uma função à escolha.

candidatos_com_data <- candidatos %>% 
    mutate_at(vars(starts_with("DT_")), dmy ) %>% 
    select(starts_with("DT_"))
head(candidatos_com_data)

#A função helper num_range ajuda a encontrar colunas do tipo prefixo_n. 
#A biblioteca worldmet retorna dados de estações meteorológicas espalhadas pelo 
#planeta

#Primeiro é necessário encontrar o código da base desejada

estacao <- worldmet::getMeta("heathrow", returnMap = FALSE)
estacao
#code = código da estação metereológica desejada
dados_heathrow <- importNOAA(code = "037720-99999")

#A função helper num_range ajuda a selecionar essas colunas com prefixo comum e 
#um sufixo numérico
dados_heathrow_select <- dados_heathrow %>% 
    select( 
        date, 
        num_range("cl_", 1:3 ), 
        num_range("precip_", c(6, 12))  
    )
head(dados_heathrow_select)

#Outra forma mais nova de fazer isso é usando a função relocate(), que facilita
#a ordenação das colunas de um data frame. Exibe primeiramente as colunas 
#indicadas 
dados_heathrow_relocate <- dados_heathrow %>% 
    relocate( 
        date, 
        air_temp
    )
head(dados_heathrow_relocate)

#Por padrão, ela traz as colunas para a frente, mas é possível movê-las para 
#antes ou depois de uma outra coluna, usando o parâmetro .before OU EXCLUSIVO 
#.after

dados_heathrow_relocate <- dados_heathrow %>% 
    relocate( 
        date, 
        air_temp,
        .before = station
    )
head(dados_heathrow_relocate)

#rename() é usada para modificar os nomes das colunas. Ela renomeia as colunas 
#indicadas e mantném as outras.

dados_heathrow %>% 
    rename(
        data = date,
        estacao = station,
        temperatura = air_temp
    ) %>% 
    head()

#select()` também pode ser usado para renomear colunas, mas mantém apenas as 
#colunas citadas

dados_heathrow %>% 
    select(
        data = date,
        estacao = station,
        temperatura = air_temp
    ) %>% 
    head()

#A função rename_with()" possibilita que renomeemos várias colunas ao mesmo 
#tempo com o uso de uma função.

#Aqui fazemos uso de uma função da biblioteca stringr, que trata strings, 
#ou seja, cadeias de caracteres.

str(iris)

#Primeiro podemos nos incomodar com as letras maiúsculas e o "." separando as 
#palavras em vez de "_"

iris_padrao <- iris %>%
    rename_with(
        .fn = str_to_lower
    ) %>% 
    rename_with(
        .fn = function(x){
            str_replace(
                string = x, 
                pattern = "\\.", 
                replacement = "_"
            )}
    ) 

str(iris_padrao)

#Podemos também querer colocar um sufixo nos nomes dos campos com a unidade

#Vamos usar aqui o "\~" criando um atalho para a função, que vai receber cada 
#nome de coluna como .x

#A função str_glue() possibilita a criação de novas strings a partir de 
#variáveis já existentes de uma forma expressiva.

iris_unidade <- iris_padrao %>% 
    rename_with(
        .cols = -species ,
        .fn = ~str_glue("{.x}_inches")
    )
str(iris_unidade)

#Outras funções úteis são as que fazem operações acumuladas e as operações de 
#lag() e lead().

#BETS é uma biblioteca criada pela FGV que dá acesso a séries temporais econômicas

series <- BETS::BETSsearch("exchange dollar")
series

#No código abaixo, calculamos o retorno da série, a volatilidade histórica e a 
#volatilidade EWMA

#lag se refere ao valor anterior
dolar <- BETSget(1) 
dolar_com_info <- dolar %>% 
    filter(date > ymd("1994-07-01")) %>% 
    arrange(date) %>% 
    mutate(
        retorno = (value - lag(value))/value,
        retorno_quad = retorno^2,
        dia = row_number(),
        fator_ewma = (1/0.94)^dia*1e-20
    ) %>% 
    filter(!is.na(retorno))

#cumsum == soma acumulada
#cumvar == variância acumulada
dolar_com_vol <- dolar_com_info %>% 
    mutate(vol = sqrt(cumvar(retorno)) * sqrt(252) ) %>% 
    mutate(vol_ewma = sqrt(cumsum(retorno_quad * fator_ewma)/cumsum(fator_ewma)) * sqrt(252) ) %>% 
    rename(dolar = value) %>% 
    select(
        date,
        dolar,
        retorno,
        vol,
        vol_ewma
    )

#Uma das formas de se criar tabelas em R
datatable(dolar_com_vol) %>% 
    formatPercentage(c("retorno", "vol", "vol_ewma"), 2)

#transmute() cria colunas e mantém apenas as colunas citadas
gapminder %>% 
    transmute(
        ano = year,
        pais = country,
        pib = gdpPercap * pop
    ) %>% 
    head()

#arrange() é utilizado para mudar as posições das linhas
dados_ordenados <- dados_heathrow %>% 
arrange(date)

#A função desc() permite a ordenação decrescente

dados_ordenados <- dados_heathrow %>% 
    arrange(date %>% desc())
head(dados_ordenados)

#filter() seleciona colunas de acordo com os seus valores

#Filtrando países (note o operador %in%)

gapminder %>% 
    filter(country %in% c("Brazil", "Argentina", "Chile")) %>% 
    ggplot() +
    geom_line(aes(x = year, y = gdpPercap, color = country )) +
    geom_point(aes(x = year, y = gdpPercap, color = country )) +
    theme_light()

#slice_max() seleciona as n linhas maiores de acordo com uma das colunas.

#Selecionando os países mais ricos em 2007 com o parâmetro n.
gapminder %>% 
  filter(year == 2007) %>% 
  slice_max(order_by = gdpPercap, n = 5) %>% 
  ggplot() +
    geom_col(aes(x = country, y = gdpPercap)) +
    theme_light()

#O parâmetro prop permite a seleção de uma proporção das linhas
ricos <- gapminder %>% 
    filter(year == 2007) %>% 
    slice_max(prop = .2, order_by = gdpPercap ) %>% 
    mutate(categoria = "Rico")

#slice() seleciona "linhas" de um data frame/tibble

classificacao_brasileirao <- read_html("https://pt.wikipedia.org/wiki/Campeonato_Brasileiro_de_Futebol_de_2019_-_S%C3%A9rie_A") %>% 
    html_nodes("table") %>% 
    extract2(7) %>% 
    html_table()

limbo <- classificacao_brasileirao %>% 
    slice(12:16) %>% 
    select(time = Equipes )
limbo

#group_by() particiona o tibble. As operações passam a ser executadas em cada partição.

indicadores <- wb_search(pattern = "GINI index \\(World Bank estimate\\)")
indicadores

gini = wb_data(indicator = "SI.POV.GINI", mrv = 10) %>% 
    filter(
        !is.na(SI.POV.GINI)
    )

gini_agrupado <- gini %>% 
    select(country, date, SI.POV.GINI) %>% 
    group_by(country) 

#Para várias operações, o agrupamento faz com que o comportamento seja diferente.
#Uma operação bastante usada é numerar as linhas de um tibble.
#No tibble agrupado, essa operação acontece em cada grupo.

gini_agrupado_linha <- gini_agrupado %>% 
    arrange(country, date) %>% 
    mutate(linha = row_number()) %>% 
    view()

#A função group_by só leva a uma sumarização, ou seja, só transforma o tibble 
#em um tibble com o número de linhas igual ao número de grupos, quando executamos
#a função summarise()

#Se executarmos summarise() sem particionar o tibble, a operação resulta em uma linha.

maiores_temp_dia <- dados_heathrow %>% 
  group_by(date(date)) %>% 
  summarise(
    maxima = max(air_temp),
    minima = min(air_temp),
    media = mean(air_temp)
  )


datatable(maiores_temp_dia) %>% 
  formatRound(c("maxima", "minima", "media"), 1)
