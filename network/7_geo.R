library(tidyverse)
library(sf)
library(leaflet)

stops <- jsonlite::fromJSON("./network/stops.json")


routes <- jsonlite::fromJSON("./network/routes.json")  %>%
  unnest(stops) %>%
  group_by(line) %>%
  mutate(
    from = stops,
    to = lead(stops)
  ) %>%
  filter(!is.na(to)) %>%
  ungroup() %>%
  select(line, from, to) %>%
  group_by(from, to) %>%
  summarize(
    line = list(unique(line)),
    .groups = "drop"
  ) %>%
  mutate(line = map_chr(line, ~ paste(.x, collapse = ", ")))



routes <- routes %>%
  left_join(stops, by = c("from" = "value")) %>%
  rename(from_lat = lat, from_lon = lon) %>%
  left_join(stops, by = c("to" = "value")) %>%
  rename(to_lat = lat, to_lon = lon) %>%
  mutate(
    geometry = pmap(
      list(from_lon, from_lat, to_lon, to_lat),
      ~ st_linestring(matrix(c(..1, ..2, ..3, ..4), ncol = 2, byrow = TRUE))
    )
  ) %>%
  st_as_sf(crs = 4326)

stops <- st_as_sf(stops, coords = c("lon","lat"), crs = 4326)

leaflet() %>%
  addTiles() %>%
  addPolylines(data = routes, label = ~line) %>%
  addCircleMarkers(data = stops, label = ~value)



