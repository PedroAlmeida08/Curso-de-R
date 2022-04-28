funcao <- function(x) x^2
#Map retorna uma lista
map(.x = 1:10, .f = funcao)
#Map_dbl retorna um vetor
map_dbl(.x = 1:10, .f = funcao)
#Map_chr retorna um vetor de Strings
map_chr(.x = 1:10, .f = funcao)
#Map_df aceita um dataframe como parâmetro e retorna um dataframe
map_df(.x = tibble(x = 1:10), .f = funcao)

#As funções tbm podem ser declaradas na chamada do map
#rnorm gera n medidas cada uma com uma média x e desvio padrão sd
map(.x = 1:3, .f = function(x){rnorm(n = 4, mean = x, sd = .01)} )

#É possível utiizar shortcuts para funções
map(.x = 1:5, .f = ~rnorm(n = 4, mean = .x, sd = .01) )

# Os argumentos são repassados pela map para a função executada. Podemos então 
# passar os argumentos para a map.
map(.x = 1:5, .f = rnorm, n = 4, sd = .01 )

#map2 e suas modificações para retornos em outros tipos, como map2_dbl(), 
#são preparadas para funções de dois argumentos.
tib_2_arg <- tribble(
  
  ~mean,  ~sd,
  0,       2,
  0,       4,
  1,       2,
  1,       4,
  
)

map2(
  .x = tib_2_arg$mean, 
  .y = tib_2_arg$sd, 
  .f = ~rnorm(n = 4, mean = .x, sd = .y) 
)


#pmap e suas modificações para retornos em outros tipos, como pmap_dbl(), são 
#preparadas um número ilimitado de argumentos.
#Uma lista de vetores nomeados deve ser passada para a pmap(). Esses são os 
#argumentos passados para a função.
#Lembre que um Data Frame/Tibble é exatamente isso: uma lista de vetores nomeados.
#O detalhe é que os nomes dos vetores deve bater com o nome dos parâmetros da função
tib_n_arg <- tribble(
  
  ~mean,  ~sd,  ~n,
  0,       2,   5,
  0,       4,   5,
  1,       2,   5,
  1,       4,   5,
  0,       2,   10,
  0,       4,   10,
  1,       2,   10,
  1,       4,   10
  
)
pmap(.l = tib_n_arg, .f = rnorm)
