library(tidyverse)
library(tidygeocoder)
library(sf)
library(leaflet)

edges <- tribble(
~label, ~from, ~to,
"15", "Station Sloterdijk", "Station Zuid",
"18", "Centraal Station", "Slotervaart",
"21", "Centraal Station", "Geuzenveld De Sav. Lohmanstraat",
"22", "Station Sloterdijk", "Centraal Station",
"34", "Station Noord", "Vogelbuurt Zuid",
"35", "Station Noord", "Molenwijk",
"36", "Station Sloterdijk", "Olof Palmeplein",
"37", "Station Noord", "Amstelstation",
"38", "Olof Palmeplein", "Buiksloterham",
"39", "Olof Palmeplein", "Molenwijk",
"40", "Amstelstation", "Muiderpoortstation",
"41", "Station Holendrecht", "Amstelstation",
"42", "Centraal Station", "Cruquius-eiland",
"43", "Centraal Station", "Borneo Eiland",
"44", "Station Bijlmer ArenA", "Diemen Noord",
"47", "Station Holendrecht", "Station Bijlmer ArenA",
"48", "Centraal Station", "Houthavens",
"49", "Station Bijlmer ArenA", "IJburg Strandeiland",
"61", "Station Sloterdijk", "Osdorpplein Noord",
"62", "Station Lelylaan", "Amstelstation",
"63", "Station Lelylaan", "Osdorp De Aker",
"65", "Amstelstation", "KNSM-laan",
"66", "Station Bijlmer ArenA", "IJburg",
"68", "Henk Sneevlietweg", "John M. Keynesplein",
"73", "OLVG West", "Slotermeerlaan",
"75", "Station Zuid", "A.J. Ernststraat",
"N81", "Centraal Station", "Station Sloterdijk",
"N82", "Centraal Station", "Geuzenveld",
"N83", "Centraal Station", "Osdorp De Aker",
"N84", "Centraal Station", "Amstelveen station",
"N85", "Centraal Station", "Gein",
"N86", "Centraal Station", "Station Bijlmer ArenA",
"N87", "Centraal Station", "Station Bijlmer ArenA",
"N88", "Centraal Station", "Nieuw Sloten",
"N89", "Centraal Station", "IJburg Strandeiland",
"N91", "Centraal Station", "Nieuwendam",
"N93", "Centraal Station", "Molenwijk",
"218", "Schiphol Airport/Plaza", "Nieuwe Meer",
"231", "Station Sloterdijk", "Abberdaan",
"233", "Station Sloterdijk", "Sicilieweg",
"245", "Oostzanerdijk", "Schiphol Airport/Plaza",
"246", "Borneolaan", "Schiphol Airport/Plaza",
"247", "Bos en Lommerplein", "Schiphol Airport/Plaza",
"267", "Anderlechtlaan", "Anderlechtlaan",
"360", "Station Bijlmer ArenA", "IJburg Strandeiland",
"369", "Station Sloterdijk", "Schiphol Airport/Plaza",
"461", "Gelderlandplein", "Zuidas",
"463", "Gelderlandplein", "Bolestein",
"464", "Gelderlandplein", "Vivaldi") %>%
  filter(!label %in% c("N81", "N82", "N83", "N84", "N85", "N86", "N87", "N88", "N89", "N91", "N93", 
                       "461", "463", "464", 
                       "218", "231", "233", "245", "246", "247", "267",
                       "73", "75"
                       ))



nodes <- edges %>%
  select(from, to) %>%
  pivot_longer(cols = everything()) %>%
  distinct(value) %>%
  geocode(value, method = "osm", lat = lat, long = lon)

corrections <- tribble(
  ~value, ~lat, ~lon,
"Geuzenveld De Sav. Lohmanstraat", 52.37546463533089, 4.800718360571635,
"Station Noord", 52.40252015799567, 4.932042192109901,
"Molenwijk", 52.4179721788107, 4.8937832288237795, 
"Vogelbuurt Zuid", 52.38310150163629, 4.913282242225676,
"Osdorp De Aker", 52.35441447736492, 4.774580050984977)


nodes <- nodes %>% filter(!value %in%  corrections$value) %>%
  bind_rows(corrections)

edges <- edges %>%
  left_join(nodes, by = c("from" = "value")) %>%
  rename(from_lat = lat, from_lon = lon) %>%
  left_join(nodes, by = c("to" = "value")) %>%
  rename(to_lat = lat, to_lon = lon) %>%
  mutate(
    geometry = pmap(
      list(from_lon, from_lat, to_lon, to_lat),
      ~ st_linestring(matrix(c(..1, ..2, ..3, ..4), ncol = 2, byrow = TRUE))
    )
  ) %>%
  st_as_sf(crs = 4326)

nodes <- st_as_sf(nodes, coords = c("lon","lat"), crs = 4326)

leaflet() %>%
  addTiles() %>%
  addPolylines(data = edges, label = ~label) %>%
  addCircleMarkers(data = nodes, label = ~value)

