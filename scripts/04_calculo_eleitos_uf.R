#### Preamble ####
# Purpose:  Calcularo numero de partidos/federação que elegeu por UF
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)

#### carregando o banco já limpo
cadeira_94_22 <- read_csv("outputs/data/cadeiras_cd_uf_94_22.csv")

### Cálculo do numero de partidos que lançøu candidatos
cadeira_94_22 |> 
  filter (cadeiras > 0 ) |> 
  group_by(ESTADOS, ANO_ELEICAO, partido) |> 
  summarize(total =n()) |> 
  group_by(ESTADOS, ANO_ELEICAO) |> 
  summarize (partido_eleito = sum(total)) -> eleitos

eleitos |>  add_column(total = "elegeu") ->  eleitos  
 
eleitos|> 
  mutate(ESTADOS = fct_recode(ESTADOS,
                              "Espírito Santo"   = "Espirito Santo",
                              "Paraíba" = "Paraíba")) -> eleitos2

### Save data ###
write_csv(eleitos2, "outputs/data/eleitos_uf_94_22.csv")




