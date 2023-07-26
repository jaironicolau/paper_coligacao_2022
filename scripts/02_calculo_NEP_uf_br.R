#### Preamble ####
# Purpose:  calcular o NEP de votos da CD por UF (1994-2018)
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)

#### carregando o banco já limpo
voto_94_22 <- read_csv("outputs/data/votos_cd_uf_94_22.csv")

### Cálculo do NEP em âmbito estadual ###
voto_94_22  |>  
  group_by(ANO_ELEICAO, ESTADOS) |> 
  mutate(pct = votos / sum(votos), ###  calcular o pct
         pct_2 = pct^2) |> # elever o pct ao quadrado
  group_by(ANO_ELEICAO, ESTADOS) %>% 
  summarize(
    hh_v = sum(pct_2), ## somar o quadrado do pct
    nep= 1/hh_v)  |>    ##  subtrair de 1
  select (- hh_v) |>  add_column(ambito = "voto") -> nep_voto_uf_94_22

## Save data ##
write_csv(nep_voto_uf_94_22, "outputs/data/nep_voto_uf_94_22.csv")


### Cálculo do NEP em âmbito nacional ###
voto_94_22  |>  
  group_by(ANO_ELEICAO, partido)  |> 
  summarise (voto_total = sum (votos))  |> 
  mutate(pct = voto_total / sum(voto_total), 
         pct_2 = pct^2)  |> 
  group_by(ANO_ELEICAO) %>% 
  summarize(
    hh_v = sum(pct_2),
    nep_v= 1/hh_v) %>% 
  select (-hh_v) |> 
  add_column(ambito = "voto") -> nep_votos_br

## Save data ##
write_csv(nep_votos_br, "outputs/data/nep_votos_br_94_22.csv")
