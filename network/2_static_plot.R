library(tidyverse)
library(igraph)
library(ggraph)
library(tidygraph)

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

graph <- routes %>%
  as_tbl_graph(directed = FALSE)

ggraph(graph, layout = "fr") +
  geom_edge_link(alpha = 0.2) +
  geom_node_point(size = 2) +
  geom_node_text(aes(label = name), size = 5, repel = TRUE) +
  geom_edge_link(aes(color = line), alpha = 0.6) +
  theme_void()


