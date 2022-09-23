library(tidyverse)
library(sf)
library(rsvg)
library(gganimate)
# =========================================
#system('inkscape --version', intern = TRUE)
library(inkscaper)
url <- 'team.blue/logo.svg'
#browseURL(url)

logo <- url %>%
  inx_extension(inkscape_extension_name = "dxf12_outlines.py", ext =".dxf") %>%
  st_read()  %>% st_union() %>% st_polygonize() %>%
  first()
logo %>% ggplot() +
  geom_sf()

logo %>% nth(1) %>% ggplot() +
  geom_sf()

collection <- st_sfc() %>% st_sf()
for (i in c(1:13)) {
  collection <- collection %>% bind_rows((logo %>% nth(i) %>% st_sfc() %>% st_sf() %>% 
                                            mutate(element = i))) %>%
    mutate(colour = ifelse(element == 9, "#17ace3",  "#1c3f6e"))
}

collection %>% ggplot() +
  geom_sf() + 
  aes(fill = colour) +
  scale_fill_identity()

collection <- collection %>% filter(element == 1) %>% 
  bind_rows(collection %>% filter(element == 4)) %>%
  bind_rows(collection %>% filter(element == 10)) %>%
  bind_rows(collection %>% filter(element == 8)) %>%
  bind_rows(collection %>% filter(element == 9)) %>%  
  bind_rows(collection %>% filter(element == 12)) %>%  
  bind_rows(collection %>% filter(element == 3)) %>%  
  bind_rows(collection %>% filter(element == 2)) %>%
  bind_rows(collection %>% filter(element == 6)) %>% 
  mutate(element = row_number())

collection <- collection %>% 
  mutate(geometry = ifelse(element == 2, geometry + c(-35, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 3, geometry + c(-72, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 4, geometry + c(-115, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 5, geometry + c(-165, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 6, geometry + c(-165, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 7, geometry + c(-195, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 8, geometry + c(-215, 0), geometry)) %>% st_sf() %>%
  mutate(geometry = ifelse(element == 9, geometry + c(-255, 0), geometry)) %>% st_sf() 
collection %>%
  ggplot() +
  geom_sf() 

p <- collection %>% ggplot() +
  geom_sf() + 
  aes(fill = colour) +
  scale_fill_identity() +
  transition_time(element) +
  theme_void() +
  enter_fade() + 
  exit_shrink() +
  ease_aes('sine-in-out')

anim_save("team.blue/logo.gif", p)

#+  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()
