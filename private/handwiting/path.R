library(tidyverse)
library(sf)
library(rsvg)
library(gganimate)
# =========================================
system('inkscape --version', intern = TRUE)
library(inkscaper)
url <- 'handwiting/tekening.svg'
browseURL(url)

logo <- url %>%
  inx_extension(inkscape_extension_name = "dxf12_outlines.py", ext =".dxf") %>%
  st_read() 
logo %>% ggplot() +
  geom_sf()

tbl <- st_sfc() %>% st_sf()
for (i in c(1:nrow(logo))) {
  tbl <- tbl %>% bind_rows(
    logo %>% slice(1:i) %>% st_union() %>% st_sfc() %>% st_sf() %>% mutate(facet = i))
}

tbl %>% filter(facet == nrow(logo)) %>% ggplot() +
  geom_sf()

tbl %>% filter(facet = nrow(logo)) ggplot() +
  geom_sf()  + 
  transition_states(facet)


#+  geom_sf_label(aes(label = facet)) #+ scale_colour_identity() + scale_fill_identity()
