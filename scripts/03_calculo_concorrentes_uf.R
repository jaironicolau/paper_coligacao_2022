#### Preamble ####
# Purpose:  Calcularo numero de partidos/federação que concorreu por UF
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)

#### carregando o banco já limpo
voto_94_22 <- read_csv("outputs/data/votos_cd_uf_94_22.csv")

### Cálculo do numero de partidos que lançøu candidatos
voto_94_22 |> 
  group_by(ESTADOS, ANO_ELEICAO, partido) |> 
  summarize(total =n()) |> 
  group_by(ESTADOS, ANO_ELEICAO) |> 
  summarize (partido_eleito = sum(total)) |> 
  add_column(total = "concorreu") -> concorrentes

### Save data ###
write_csv(concorrentes, "outputs/data/concorrentes_uf_94_22.csv")
