#### Preamble ####
# Purpose:  limpar e agregar cadeiras da CD por UF (1986-2018)
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)
library(readxl)


#### Clean data ####

### 1986 (para ter a serie completa, embora nao usarei 86, 90 e 94 aqui)
deb_86 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "1986")
deb_86 %>% 
  pivot_longer(cols = PMDB:PSC,
               names_to = "partido", 
               values_to = "cadeiras",
               values_drop_na = TRUE) -> c86
c86 %>% add_column(ANO_ELEICAO = 1986) -> c86

### 1990
deb_90 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "1990")
deb_90 %>% 
  pivot_longer(cols = PMDB:PSD,
               names_to = "partido", 
               values_to = "cadeiras",
               values_drop_na = TRUE) -> c90
c90 %>% add_column(ANO_ELEICAO = 1990) -> c90

### 1994
deb_94 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "1994")
deb_94 %>% 
  pivot_longer(cols = PMDB:PRP,
               names_to = "partido", 
               values_to = "cadeiras",
               values_drop_na = TRUE) -> c94
c94 %>% add_column(ANO_ELEICAO = 1994) -> c94

### 1998
deb_98 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "1998")
deb_98 %>% 
  pivot_longer(cols = PFL:PRONA,
               names_to = "partido", 
               values_to = "cadeiras") -> c98
c98 %>% add_column(ANO_ELEICAO = 1998) -> c98

### 2002
deb_02 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2002")
deb_02 %>% 
  pivot_longer(cols = PT:PMN,
               names_to = "partido", 
               values_to = "cadeiras") -> c02
c02 %>% add_column(ANO_ELEICAO = 2002) -> c02

### 2006
deb_06 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2006")
deb_06 %>% 
  pivot_longer(cols = PMDB:PRB,
               names_to = "partido", 
               values_to = "cadeiras") -> c06
c06 %>%  add_column(ANO_ELEICAO = 2006) -> c06

### 2010
deb_10 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2010")
deb_10 %>% 
  pivot_longer(cols = PT:PTC,
               names_to = "partido", 
               values_to = "cadeiras") -> c10

c10 %>% add_column(ANO_ELEICAO = 2010) -> c10

### 2014
deb_14 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2014")
deb_14 %>% 
  pivot_longer(cols = PT:PRTB,
               names_to = "partido",values_to = "cadeiras") -> c14 
c14 %>% add_column(ANO_ELEICAO = 2014) -> c14


### 2018
deb_18 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2018")
deb_18 %>% 
  pivot_longer(cols = Acre:Tocantins,
               names_to = "ESTADOS", 
               values_to = "cadeiras") -> c18 
c18 %>% add_column(ANO_ELEICAO = 2018) -> c18

### 2022
deb_22 <- read_excel("inputs/data/deb_cadeiras_82_14.xlsx", sheet = "2022")
deb_22 %>% 
  pivot_longer(cols = Acre:Tocantins,
               names_to = "ESTADOS", 
               values_to = "cadeiras") -> c22 
c22 %>% add_column(ANO_ELEICAO = 2022) -> c22

#### juntando os bancos ####

c86 %>% 
  bind_rows(c90) |>
  bind_rows(c94) |>
  bind_rows(c98) |> 
  bind_rows(c02) |> 
  bind_rows(c06) |> 
  bind_rows(c10) |> 
  bind_rows(c14) |> 
  bind_rows(c18) |> 
  bind_rows(c22) -> cadeira_86_22  

cadeira_86_22 |>  add_column(ambito = "cadeira") -> cadeira_86_22


write_csv(cadeira_86_22, "outputs/data/cadeiras_cd_uf_94_22.csv")
