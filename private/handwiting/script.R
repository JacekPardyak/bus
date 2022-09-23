library(tidyverse)
library(sf)
library(rsvg)
library(gganimate)
# =========================================
system('inkscape --version', intern = TRUE)
library(inkscaper)
url <- 'handwiting/drawing.svg'
browseURL(url)

tmp <- url %>% inx_actions(actions = list('select-all', 'object-to-path'), ext = ".svg") %>%
  inx_extension(inkscape_extension_name = "dxf12_outlines.py", ext =".dxf") %>%
  st_read() %>% select(geometry) %>% st_union() %>%  st_polygonize() %>%
  first() 
result <- st_sfc() %>% st_sf()
for (row in c(1: length(tmp))) {
  result <- result %>% bind_rows((tmp %>% nth(row) %>% st_sfc() %>% st_sf() %>% 
                                    mutate(facet = row)))
}
tmp <- result %>% filter(!facet %in% c(4, 10, 13)) %>% st_union() # , 2, 5, 8, 10, 11, 13 
tmp1 <- tmp %>% slice(1) %>% select(geometry) %>% first() %>% first()
tmp1
tmp2 <- tmp %>% slice(2) %>% select(geometry) %>% first() %>% first()

#%>% select(geometry) %>% st_union()
tmp %>% ggplot() +
  geom_sf() #+  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()

#tmp <- result %>% filter(!facet %in% c(4, 2, 5, 10)) %>% st_union() %>% st_sfc() %>% st_sf()
#tmp
#tmp %>% ggplot() +
#  geom_sf() +
#  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()

collection <- st_sfc() %>% st_sf()
for (i in c(1:100)) {
  collection <- collection %>% bind_rows(
    tmp %>% mutate(colour = rainbow(100)[[i]]) %>% mutate(facet = i)
  )
}


#layer1 <- tmp %>% mutate(colour = '#FF0000') %>% mutate(facet = 1)
#layer2 <- tmp %>% mutate(colour = '#00FF00') %>% mutate(facet = 2)
#layer3 <- tmp %>% mutate(colour = '#0000FF') %>% mutate(facet = 3)
#collection <- layer1 %>% bind_rows(layer2) %>% bind_rows(layer3)
#
#collection %>% ggplot() +
#  geom_sf(aes(colour = colour)) +
#  scale_color_identity()


anim <- collection %>% ggplot() +
  geom_sf(aes(colour = colour, fill = colour)) +
  scale_color_identity() +
  scale_fill_identity() +
  transition_time(facet) + 
  theme_void()
anim

animate(anim, renderer = gifski_renderer("handwiting/drawing.gif"))#, fps = 1, duration = 60)
