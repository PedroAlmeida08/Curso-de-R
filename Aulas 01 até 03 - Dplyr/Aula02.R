# A função if_else`(da biblioteca dplyr) funciona de vetorial.
#if_else é mais rápida que a função ifelse da biblioteca base, mas só aceita 
#argumentos de mesmo tipo no segundo e terceiro parâmetros

#Primeiro parâmetro é um vetor de condições
#Segundo parâmetro executa caso seja verdadeiro
#Terceiro parâmetro executa caso seja falso
jogo_do_pim_silvio_santos <- if_else(
  condition = 1:40 %% 4 == 0 ,
  true =  "PIM",
  false =  as.character(1:40) #Converte um tipo em char
)
jogo_do_pim_silvio_santos


#case_when é o equivalente vetorial do switch case
case_when(
  1:40 %% 10 == 0 ~ "dezena",
  1:40 %% 2 == 0 ~ "par",
  TRUE ~ as.character(1:40)
)

#As cláusulas next e break modificam o comportamento, respectivamente caminhando
#direto para a próxima iteração e saindo do for

for(i in 1:5){
  if (i %% 2 == 0){
    next
  }
  print(i)
}

for(i in 1:5){
  if (i %% 2 == 0){
    break
  }
  print(i)
}

### Vantagens da programação funcional ###

com_loop <- function(n){
  x <- integer()
  for (i in 1:n){
    x <- c(x, i^2)
  }
  x
}
#programação funcional: aprenderemos posteriomente
sem_loop <- function(n){
  x <- 1:n %>% 
    map_dbl(function(x){x^2})
  x
}

#A biblioteca bench oferece funções ótimas para avaliar a performance de pedaços
#pequenos de código.
resultados_perf <- mark(
  sem_loop(1e4),
  com_loop(1e4),
  (1:1e4)^2
)

 resultados_perf %>% 
  select(expression, min, median, `itr/sec` )
plot(resultados_perf)
