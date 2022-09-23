library(tidyverse)
library(sf)
library(gganimate)
# =========================================
<<<<<<< HEAD
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
  collection <- collection %>% bind_rows((logo %>% nth(i) %>% st_sfc() %>% st_sf() %>% 
                                            mutate(element = i))) %>%
    mutate(colour = ifelse(element %in% c(1, 3, 6, 7, 10, 14, 16:21, 23:24), "#FFFFFF", "#000000"))
}

collection %>% ggplot() +
  geom_sf() + 
  aes(fill = colour) +
  scale_fill_identity() + # geom_sf_label(aes(label = element))
  theme_void()

collection_1 <- collection %>% slice(2) %>% mutate(facet = 1)
collection_2 <- collection %>% slice(2) %>%  mutate(geometry = st_buffer(geometry, -1))%>%
  mutate(facet = 2)

collection_t <- collection_1 %>% bind_rows(collection_2)  

p <- collection_t %>% ggplot() +
=======
url <- "pol'and'rock/normal.dxf"
logo <- url %>% st_read() 
logo %>% ggplot() +
  geom_sf()

collection <- st_sfc() %>% st_sf()
for (i in c(1:6)) {
  collection <- collection %>% bind_rows(
    logo %>% filter(Layer == paste('Layer', i)) %>% st_union() %>% 
  st_polygonize() %>% first() %>% st_sfc() %>% st_sf() %>%
    mutate(colour = ifelse(i %in% c(2, 4, 6), "#FFFFFF", "#000000"))
  )
  }
  
ggplot() +
  geom_sf(data = collection %>% slice(1)) + 
  geom_sf(data = collection %>% slice(2)) + 
  geom_sf(data = collection %>% slice(3)) + 
  geom_sf(data = collection %>% slice(4)) + 
  geom_sf(data = collection %>% slice(5)) + 
  geom_sf(data = collection %>% slice(6)) + 
  aes(fill = colour) +
  scale_fill_identity()


p <- collection %>% ggplot() +
>>>>>>> 2370c0077889290f4aba0738dd59481f9ecda05c
  geom_sf() + 
  aes(fill = colour) +
  scale_fill_identity() +
  transition_time(facet) +
  theme_void()

anim_save("pol'and'rock/ver-1/PNR.gif", p)

# rainbow
require(graphics)
# A Color Wheel
pie(rep(1,100), col=rainbow(7))

<<<<<<< HEAD
#+  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()

# ------------------------------
url <- "pol'and'rock/normal.dxf"
logo <- url %>% st_read() 
logo %>% ggplot() +
  geom_sf()
=======
rainbow(7)
>>>>>>> d1d8b724d0e11204de86e08b4695913b12c0f61c
