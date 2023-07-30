#### Preamble ####
# Purpose:  calcular o NEP de votos e cadeiras da CD por UF (1994-2018)
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)

#### VOTOS UF

voto_94_22 <- read_csv("outputs/data/votos_cd_uf_94_22.csv")

voto_94_22|> 
  mutate(ESTADOS = fct_recode(ESTADOS,
                              "Acre"   = "AC",
                              "Alagoas"   = "AL",
                              "Amapá" = "AP",
                              "Amazonas" = "AM",
                              "Bahia" = "BA", 
                              "Ceará" = "CE", 
                              "Distrito Federal" = "DF", 
                              "Espírito Santo" = "ES", 
                              "Goiás" = "GO", 
                              "M. G. do Sul" = "MS",
                              "Maranhão" = "MA",
                              "Mato Grosso" = "MT", 
                              "Minas Gerais" = "MG", 
                              "Paraná" = "PR", 
                              "Paraíba" = "PB", 
                              "Pará" = "PA", 
                              "Pernambuco" = "PE", 
                              "Piauí" = "PI", 
                              "R. G. do Norte" = "RN", 
                              "R. G. do Sul" = "RS", 
                              "Rio de Janeiro" = "RJ", 
                              "Rondônia" = "RO", 
                              "Roraima" = "RR", 
                              "Santa Catarina" = "SC", 
                              "Sergipe" = "SE", 
                              "São Paulo" = "SP", 
                              "Tocantins" = "TO"))  -> voto_94_22

### Cálculo do NEP em âmbito estadual ###
voto_94_22  |>  
  group_by(ANO_ELEICAO, ESTADOS) |> 
  mutate(pct = votos / sum(votos), ###  calcular o pct
         pct_2 = pct^2) |> # elever o pct ao quadrado
  group_by(ANO_ELEICAO, ESTADOS) %>% 
  summarize(
    hh_v = sum(pct_2), ## somar o quadrado do pct
    nep= 1/hh_v)  |>    ##  subtrair de 1
  select (- hh_v) |>  add_column(ambito = "voto") -> nep_voto


### CADEIRAS UF

cadeira <- read_csv("outputs/data/cadeiras_cd_uf_94_22.csv")

cadeira %>%  mutate(ESTADOS = fct_recode(ESTADOS,
                "Espírito Santo" = "Espirito Santo")) -> cadeira

cadeira %>% 
  group_by(ANO_ELEICAO, ESTADOS, partido ) %>% 
  filter (cadeiras >= 1 )  %>% 
  summarise (voto_total = sum (cadeiras)) %>%
  mutate(pct = voto_total / sum(voto_total),
         pct_2 = pct ^2) |> 
  group_by(ANO_ELEICAO, ESTADOS) %>% 
  summarize(
    hh = sum(pct_2),
    nep= 1/hh) %>% 
select (- hh) |>  add_column(ambito = "cadeira") ->  nep_cadeira


nep_voto |> 
  bind_rows(nep_cadeira) -> nep_cadeira_voto_uf


## Save data ##
write_csv(nep_cadeira_voto_uf, "outputs/data/nep_cadeira_voto_uf.csv")

### NACIONAL

### Cálculo do NEP em âmbito nacional ###
voto_94_22  |>  
  group_by(ANO_ELEICAO, partido)  |> 
  summarise (voto_total = sum (votos))  |> 
  mutate(pct = voto_total / sum(voto_total), 
         pct_2 = pct^2)  |> 
  group_by(ANO_ELEICAO) %>% 
  summarize(
    hh_v = sum(pct_2),
    nep = 1/hh_v) %>% 
  select (-hh_v) |> 
  add_column(ambito = "voto") -> nep_votos_br

cadeira %>% 
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


nep_votos_br |> 
  bind_rows(nep_cadeiras_br) -> nep_cadeira_voto_br

## Save data ##
write_csv(nep_cadeiras_br, "outputs/data/nep_votos_cadeiras_br_86_22.csv")


