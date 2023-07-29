#### Preamble ####
# Purpose:  Fazer as figuras que irão para o artigo
# Author: Jairo Nicolau
# Date: 6 março 2023 

#### Workspace setup ####
library(tidyverse)
library(readr)
library(cowplot)

########### Figura 1: NEP na Câmara dos Deputados

nep_cadeira <- read_csv("outputs/data/nep_cadeiras_br_86_22.csv")

nep_cadeira %>% 
  ggplot(aes(ANO_ELEICAO, nep)) +
  geom_line(size= 0.3)+
  geom_point(size=1.2) +
  scale_y_continuous(breaks = seq(0, 17, 01), 
                     limits=c(0, 17)) + 
  theme_bw() +
  scale_color_brewer(palette = "Dark2") +
  background_grid(major = 'y', minor = "none") +
  scale_x_continuous(breaks = c(1986, 1990, 1994, 1998,  
                                2002, 2006, 2010, 2014, 2018, 2022)) +
  labs(title = "",
       subtitle = "", 
       fill = "",
       color = "", 
       x = NULL, 
       y = NULL,
       caption = "" ) ## Autor: Jairo Nicolau;  Fonte: Dados do TSE

ggsave("otputs/figuras/figura1.jpeg",width = 6,  height = 5)


########## Figura 2: Numero de concorrentes e eleitos por estado


total_concorrentes_uf <- read_csv("outputs/data/concorrentes_uf_94_22.csv")
total_eleitos_uf <- read_csv("outputs/data/eleitos_uf_94_22.csv")

total_concorrentes_uf |> bind_rows(total_eleitos_uf) -> df

df %>% 
  filter(ANO_ELEICAO >1994) |> 
  ggplot(aes(ANO_ELEICAO, partido_eleito, color= total)) +
  geom_line(size= 0.3)+
  geom_point(size=0.7) +
  scale_y_continuous( name = "",limits=c(0, 35)) +
  facet_wrap(~ ESTADOS, ncol = 5) +
  theme_bw() +
  scale_color_brewer(palette = "Dark2") +
  background_grid(major = 'y', minor = "none") +
  scale_x_continuous(breaks = c(1994, 1998, 2002, 2006, 2010, 2014, 2018, 2022),
                     labels = c("94", "98", "02", "06", "10", "14", "18", "22")) +
  labs(title = "",
       subtitle = "", 
       fill = "",
       color = "", 
       x = NULL, 
       y = NULL,
       caption = "") +
  
  theme(strip.text = element_text(face = "bold"),
        plot.title = element_text(face = "bold"),
        axis.text.x = element_text(size=9),
        legend.position = "bottom") 

ggsave("otputs/figuras/figura2.jpeg", width = 8,height = 10)


#filter (ESTADOS %in% c ("Acre", "Alagoas", "Roraima", 
"Rondônia", "Amapá", "Distrito Federal", "Sergipe", 
"M. G. do Sul", "R. G. do Norte", "Piauí","Espírito Santo", 
"Mato Grosso", "Tocantins", "Paraíba")) 


