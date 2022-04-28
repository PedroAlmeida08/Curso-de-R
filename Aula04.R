#A função across(), quando usada em conjunto com mutate(), summarise(), 
#filter()... , facilita a execução de operações iguais em diversos campos com 
#base no nome dos campos ou no valor deles.

#A função across() tem dois parâmetros.
#   O parâmetro `.cols` define em quais colunas serão aplicados as funções
#   O parâmetro `.fns` define a função (ou a lista de funções) que serão aplicadas 
#em cada coluna

candidatos %>% 
    mutate(
        across(
            .cols = starts_with("DATA")  ,
            .fns = dmy
        )
    ) %>% 
    relocate(starts_with("DATA") ) %>% 
    str() 

#nest() e unnest()
#rowwise()
#Leitura de arquivos 