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

### necessario passar para o nome completo para padronizar
concorrentes |> 
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
                              "Tocantins" = "TO" )) -> concorrentes2

### Save data ###
write_csv(concorrentes2, "outputs/data/concorrentes_uf_94_22.csv")
