#### Preamble ####
# Purpose:  limpar e agregar votos par CD por UF (1994-2018)
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)
library(readxl)

#### Clean data ####

### 1994
deb_94 <- read_excel("inputs/data/deb_votos_82_14.xlsx", 
                           sheet = "voto_1994")
deb_94 %>% 
  pivot_longer(cols = PMDB:PTdoB, names_to = "partido", values_to = "votos") %>% 
  drop_na(votos)  -> v94 
v94 %>% add_column(ANO_ELEICAO = 1994) -> v94

### 1998-2018 (dados do cepesp: agregação para todo o período) 
cepesp <- read_csv("inputs/data/TSE_DEPUTADO_FEDERAL_UF_PARTIDO_2018_2014_2010_2006_2002_1998.csv") 

cepesp %>% 
  group_by(ANO_ELEICAO, UF, SIGLA_PARTIDO) %>% 
  summarise (votos = sum (QTDE_VOTOS)) %>% 
  rename (partido = SIGLA_PARTIDO,
          ESTADOS = UF) -> v_98_18

### 2022
tse_22 <- read_delim("inputs/data/quociente_eleitoral-brasil_presidente_2022.csv", 
  delim = ";", escape_double = FALSE, 
  locale = locale(encoding = "latin1"), trim_ws = TRUE)

tse_22 %>%  filter (cd_cargo == 6)  %>% 
  select(aa_eleicao, sg_uf, tx_legenda_tot, qt_votos_coligacao_qp) %>% 
  rename(ESTADOS = sg_uf,
         partido = tx_legenda_tot,
         votos = qt_votos_coligacao_qp,
         ANO_ELEICAO = aa_eleicao) -> v_22

#### Juntando os bancos ####
v94 %>% 
  bind_rows(v_98_18) %>% 
  bind_rows(v_22) -> voto_94_22

#### Save data ####
write_csv(voto_94_22, "outputs/data/votos_cd_uf_94_22.csv")



