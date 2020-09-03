library(tidyverse)
library(tidygeocoder)
library(maps)
library(leaflet)

# Antônio Prado, Rio Grande do Sul[20]
# Bento Gonçalves, Rio Grande do Sul[21][22][23]
# Camargo, Rio Grande do Sul[24]
# Caxias do Sul, Rio Grande do Sul[25]
# Fagundes Varela, Rio Grande do Sul[26]
# Flores da Cunha, Rio Grande do Sul[27][28][29]
# Guabiju, Rio Grande do Sul[24]
# Ivorá, Rio Grande do Sul[24]
# Nova Erechim, Santa Catarina[30]
# Nova Pádua, Rio Grande do Sul[24]
# Nova Roma do Sul, Rio Grande do Sul[31][32]
# Paraí, Rio Grande do Sul[33]
# Serafina Corrêa, Rio Grande do Sul[34][35]

cities = tibble(city = c("Antônio Prado, Rio Grande do Sul",
                         "Bento Gonçalves, Rio Grande do Sul",
                         "Camargo, Rio Grande do Sul",
                         "Caxias do Sul, Rio Grande do Sul",
                         "Fagundes Varela, Rio Grande do Sul",
                         "Flores da Cunha, Rio Grande do Sul",
                         "Guabiju, Rio Grande do Sul",
                         "Ivorá, Rio Grande do Sul",
                         "Nova Erechim, Santa Catarina",
                         "Nova Pádua, Rio Grande do Sul",
                         "Nova Roma do Sul, Rio Grande do Sul",
                         "Paraí, Rio Grande do Sul",
                         "Serafina Corrêa, Rio Grande do Sul"
                         ))

cities

# TEST:

geo(address = "Serafina Corrêa, Rio Grande do Sul", method = "osm")

d = geo(address = cities$city, method = "osm")

d

# d = d %>% 
#     mutate(lat = ifelse(str_detect(address, "Erechim"),
#                         -26.899256, lat),
#            long = ifelse(str_detect(address, "Erechim"),
#                          -52.907079, long))

d = d %>% 
    mutate(pop = c(14159,
                   115069,
                   2524,
                   735276,
                   2596,
                   27135,
                   1586,
                   1910,
                   4275,
                   2563,
                   3584,
                   7357,
                   17502))



write_csv(d, path = "talian/IIA_map.csv")

iia = read_csv("talian/IIA_map.csv")

iia

leaflet(data = iia, width = "100%", height = 600, 
        options = leafletOptions(minZoom = 5, maxZoom = 10, zoomControl = FALSE)) %>% 
    addProviderTiles("OpenStreetMap.Mapnik") %>%
    addCircles(lat = -28.95, lng = -51.54, 
               radius = 55000, color = "black",
               label = "Italian Immigration Area - IIA") %>% 
    setView(zoom = 6, lat = -28.9, lng = -51.542461) %>% 
    addCircleMarkers(lng = iia$long, lat = iia$lat, stroke = F, 
                     radius = log(iia$pop),
                     color = "FireBrick", fillOpacity = 0.5,
                     label = str_c(iia$address, 
                                   " (Pop: ", format(round(as.numeric(iia$pop), 1), 
                                                     nsmall=0, big.mark=","), ")")) 
