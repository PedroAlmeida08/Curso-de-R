set.seed(88)
joga_monty_hall <- function(troca){
  portas <- 1:3
  #sample() sorteia elementos com ou sem reposição
  porta_carro <- sample(portas, size = 1, replace = FALSE)
  primeira_escolha <- 1
  #Seleção negativa (retirando elementos)
  portas_pra_revelar <- portas[-c(porta_carro, primeira_escolha)]
  porta_revelada <- sample( c(portas_pra_revelar, portas_pra_revelar  ), 1)
  if(troca){
    escolha <- portas[-c(primeira_escolha, porta_revelada)]
  }
  else{
    escolha <- primeira_escolha
  }
  
  escolha == porta_carro
  
}
n <- 1000
#replicate executa múltiplas vezes um comando e armazena os resultados em uma 
#estrutura única
troca <- replicate(n = n, joga_monty_hall(troca = TRUE))
fica  <- replicate(n = n, joga_monty_hall(troca = FALSE))

#Resultados:
sum(troca)/n
sum(fica)/n
