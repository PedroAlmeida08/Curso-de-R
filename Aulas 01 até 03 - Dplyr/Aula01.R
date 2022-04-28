#Cria vetor de 1 até 10
#L de Long Int

1L:10L#Gera um vetor com todos os números que estão entre os operandos e são
      #formados somando números inteiros ao primeiro operando

vetor <- c(1,2,c(4,5,6))#Criação de um vetor através da combinação de três
                        #vetores (v1 = 1, v2 = 2, v3 = [4,5,6])

seq(1, 9, 2) #Gera um vetor de 1 até 9 com passo 2

seq(1, 9, length.out = 3) #Gera um vetor de 1 até 9 com 3 posições

seq(1, 4, along.with = 1:10)#Gera um vetor de 1 até 4 com o mesmo número de 
                            #posições do vetor 1:10 

#Cria uma lista
list(1, "palavra", 5.4)

#Vetor == mesmo tipo de dados
#Lista == tipo de dados diferentes


#Criação de uma espécie de tabela
#Internamente é uma lista de vetores de mesmo tamanho
tibble::tibble(a = 1:10, b = 2:11)

#Code Chunck == Juntar pedaços de texto de código em MarkDown

#Para o R, uma função é um objeto de primeiro nível e por isso, variáveis podem
#armazenar uma função
#Uma função em R retorna o último comando utilizado, não é obrigatório o uso
#da palavra reservada return

f <- function(a, b){
  a + b
}

f(1L, 2L)


#Em R temos um valor double setado para representar o Infinito
typeof(Inf)

#Valores faltantes ou desconhecidos são representados por NA
a <- c(1, 2, 3, NA)
#O valor NA quase sempre contamina os cálculos
mean(a)
#Para resolver esse problema podemos usar o parâmetro na.rm = TRUE, ou seja
#NA remove = TRUE
mean(a, na.rm = TRUE)
#Podemos detectar um valor NA através do comando is.na() e ele irá nos retornar
#TRUE onde houver um valor NA
is.na(a)

#As operações em R são vetoriais
1:5 * 2 #Nesse caso, 2 é considerado um vetor de uma única posição. Nessa
        #operação ocorre o recycling, que consiste em repetir o vetor menor
        #ciclicamente de forma a ficar com o mesmo tamanho do vetor menor

#Vetores e listas em R podem ser nomeados
b <- c(primeiro = 1, segundo = 2, terceiro = 3)
#Isso é útil pois torna possível o acesso às posições do vetor pelos seus nomes
b["segundo"]
### R é uma linguagem 1-based, ou seja, vetores começam do 1 e não do 0 ###

#A função names pode retornar o nome das posições dos vetores ou então renomeá-los
names(b)
names(b) <- c("a", "b", "c")
names(b)

#Também é possível renomear elementos de uma lista
lista_nomeada <- list(primeiro = "a", segundo = 2, terceiro = c(1,2,3))
lista_nomeada
#Para acessar elementos em listas deve-se utilizar colchetes duplos
lista_nomeada[1]
lista_nomeada[[1]]
lista_nomeada[["primeiro"]]
lista_nomeada$primeiro

#O Data Frame consiste em um conjunto de vetores/listas nomeados, com o mesmo 
#número de elementos (ou que seja possível realizar o recycling), que formam 
#uma estrutura retangular, onde cada coluna é um vetor/lista e cada linha n 
#contém o n-ésimo elemento dos vetores.

### É similar, em muitas características, a uma tabela de banco de dados. ###

df <- 
  data.frame(
    nome = c("João", "Maria", "Zezinho", "Juquinha"), 
    idade = c(7, 8, 9, 10), 
    altura = c(10, 11)
  )
df

#Tibble é uma adaptação do Data Frame para análise de dados. Pra maioria dos 
#efeitos eles têm o mesmo comportamento, mas os tibbles contêm algumas 
#atualizações para os processos de análise de dados.

### Tibble não aceita reclycing de um vetor que contenha mais de um elemento ###

install.packages("tibble")
library(tibble)

tib <- 
  #try evita que o erro paralise toda a execução do script
  try(
    tibble(
      nome = c("João", "Maria", "Zezinho", "Juquinha"), 
      idade = c(7, 8, 9, 10), 
      altura = c(10, 11)
    )
  )
tib

# ~ é utilizado para definir nome de colunas
trib <- 
  try(
    tribble(
      ~nome,       ~idade,      ~altura,
      "Bruno",     41,         1.75,
      "João",      23,         1.80,
      "Maria",     29,         1.70,
      "Zezinho",   31,         1.78
    )
  )
trib
