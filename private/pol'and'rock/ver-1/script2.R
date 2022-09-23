library(tidyverse)
library(sf)
library(gganimate)
# =========================================
url <- "pol'and'rock/ver-1/PNR.dxf"
logo <- url %>% st_read()
logo %>% ggplot() +
  geom_sf()

logo <- url %>% st_read() %>% st_union() %>% st_polygonize() %>%
  first()

logo %>% nth(14) %>% ggplot() +
  geom_sf()

collection <- st_sfc() %>% st_sf()
for (i in c(1:length(logo))) {
  collection <- collection %>% bind_rows(logo %>% nth(i) %>% st_sfc() %>% st_sf() %>% 
                                            mutate(element = i))
}

polygon_pos <- collection %>% filter(element %in% c(1, 3, 6, 7, 10, 14, 16:21, 23:24)) %>% 
  st_union() %>% st_sfc() %>% st_sf() %>% mutate(colour = "#FFFFFF")
polygon_neg <- collection %>% filter(!element %in% c(1, 3, 6, 7, 10, 14, 16:21, 23:24)) %>% 
  st_union() %>% st_sfc() %>% st_sf() %>% mutate(colour = "#000000")

collection_t <- st_sample(polygon_pos, 2000) %>% st_union() %>% st_sfc() %>% st_sf() %>% mutate(facet = 1) %>%
  bind_rows(st_sample(polygon_neg, 2000) %>% st_union() %>% st_sfc() %>% st_sf() %>% 
              mutate(facet = 2))

p <- collection_t %>% ggplot() +
  geom_sf() + 
#  aes(fill = colour) +
#  scale_fill_identity() +
  transition_time(facet) +
  theme_void()

anim_save("pol'and'rock/ver-1/PNR.gif", p)

