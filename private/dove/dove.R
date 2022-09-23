library(tidyverse)
library(sf)
library(rsvg)
library(gganimate)
# =========================================
#system('inkscape --version', intern = TRUE)
library(inkscaper)
url <- 'dove/download.svg'
#browseURL(url)

logo <- url %>%
  inx_extension(inkscape_extension_name = "dxf12_outlines.py", ext =".dxf") %>%
  st_read()  %>% st_union() %>% st_polygonize() %>%
  first()
logo %>% ggplot() +
  geom_sf()

logo %>% nth(4) %>% ggplot() +
  geom_sf()


collection <- st_sfc() %>% st_sf()
for (i in c(1,3,4)) {
  collection <- collection %>% bind_rows((logo %>% nth(i) %>% st_sfc() %>% st_sf() %>% 
                                mutate(element = i))) %>%
    mutate(colour = "#000000")
}
collection <- collection %>% mutate(element = row_number())
collection_1 <- collection %>% mutate(facet = 1)
collection_1 %>% ggplot() +
  geom_sf() 

collection_2 <- collection %>% mutate(facet = 2) %>% 
  mutate(geometry = ifelse(element == 3, geometry + c(5, -5), geometry))  %>% 
  st_sf() %>% 
  mutate(geometry = ifelse(element == 1, geometry + c(5, -5), geometry)) %>% 
  st_sf()
collection_2 %>% ggplot() +
  geom_sf() 

collection_1 %>% bind_rows(collection_2) %>% ggplot() +
  geom_sf()  + 
  aes(fill = colour) +
  scale_fill_identity() +
  transition_states(facet) +
  theme_void()



#+  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()
