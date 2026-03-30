library(tidyverse)

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

# 1. Create unique Nodes (Stops) from the edges data
stops <- unique(c(routes$from, routes$to)) %>% 
  as_tibble()  

tmp <- read_csv("./network/data/stops.txt") %>%
  filter(str_starts(stop_name, "Amsterdam,")) %>%
  mutate(stop_name = gsub("Amsterdam, ", "", stop_name)) %>% 
  group_by(stop_name) %>%
  slice(1) %>%
  ungroup() %>%
  select(stop_name, stop_lat, stop_lon) %>%
  rename(value = stop_name, lat = stop_lat, lon = stop_lon)

stops <- stops %>%
  left_join(tmp)

stops %>% jsonlite::write_json("./network/stops.json", pretty = T)

