n_simul <- 10000
n_questoes <- 240
min_aprovacao <-  0.6
n_aprovado <- 240 * min_aprovacao
prob_questao <- 0.2
acertos <- rbinom(n = n_simul, size = n_questoes, prob = prob_questao   )
sum(acertos >= n_aprovado)/n_simul

dado <- enframe(acertos/n_questoes)
mostra_chances <- function(acertos, n_questoes){
  ggplot(enframe(acertos/n_questoes)) +
    geom_density( aes(x = value)) +
    scale_x_continuous(
      labels = percent_format(accuracy = 1), 
      limits = c(0,1),
      breaks = seq(0, 1, 0.1) 
    ) +
    labs(x ="% Acertos") +
    geom_vline(xintercept = min_aprovacao, color = "red") +
    theme_light()
}
mostra_chances(acertos, n_questoes)
