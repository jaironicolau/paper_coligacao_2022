#### Preamble ####
# Purpose:  calcular o NEP de cadeiras da CD por UF (1994-2018)
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)

#### carregando o banco já limpo
cadeira_94_22 <- read_csv("outputs/data/cadeiras_cd_uf_94_22.csv")

### Cálculo do NEP em âmbito estadual // para 2022 considerei as federações
cadeira_94_22 %>% 
  group_by(ANO_ELEICAO, ESTADOS, partido ) %>% 
  filter (cadeiras >= 1 )  %>% 
  summarise (voto_total = sum (cadeiras)) %>%
  mutate(pct = voto_total / sum(voto_total),
         pct_2 = pct ^2) |> 
  group_by(ANO_ELEICAO, ESTADOS) %>% 
  summarize(
    hh = sum(pct_2),
    nep= 1/hh) -> nep_uf_c

## Save data ##
write_csv(nep_uf_c, "outputs/data/nep_cadeiras_uf_86_22.csv")

### Cálculo do NEP nacional // para 2022 considerei as federações
cadeira_94_22 %>% 
  group_by(ANO_ELEICAO, partido ) %>% 
  filter (cadeiras >= 1 )  %>% 
  summarise (voto_total = sum (cadeiras)) %>%
  mutate(pct = voto_total / sum(voto_total),
         pct_2 = pct ^2)   |> 
  group_by(ANO_ELEICAO) %>% 
  summarize(
    hh = sum(pct_2),
    nep= 1/hh) |> 
  select (- hh) |>
  add_column(ambito = "cadeira") -> nep_cadeiras_br

write_csv(nep_cadeiras_br, "outputs/data/nep_cadeiras_br_86_22.csv")


