library(tidyverse)
library(geobr)
library(basedosdados)
library(sf)


#Mapa de Minas Gerais
mg <- geobr::read_municipality(code_muni = 31) %>% 
  mutate(id_municipio = as.character(code_muni))



#Base de saneamento
basedosdados::set_billing_id('double-voice-305816')

sanea <- basedosdados::read_sql("SELECT id_municipio, indice_sem_atend
FROM `basedosdados.br_ana_atlas_esgotos.municipio` 
WHERE sigla_uf = 'MG'")


#Mapa
mapa <- mg %>% 
  inner_join(sanea, by = 'id_municipio')



ggplot(data = mapa) + geom_sf(aes(fill = indice_sem_atend))+
  scale_fill_viridis_c(option = "plasma", trans = "sqrt")+
  theme_void() + labs(fill = "Porcentagem 
sem saneamento (%)") +
  theme(legend.title = element_text( size = 15),
        legend.text = element_text(size = 16))
