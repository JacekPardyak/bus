library(tidyverse)
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

# Convert your edge list into a directed graph
# Note: map_int is used to count how many lines serve each segment
graph <- as_tbl_graph(routes, directed = FALSE) %>%
  mutate(
    degree = centrality_degree(mode = "all"),        # Total connections per stop
    betweenness = centrality_betweenness(),         # "Bridge" stops between neighborhoods
    pagerank = centrality_pagerank(),               # Overall importance/influence
    community = as.factor(group_infomap())          # Clusters of stops that belong together
  )

# Add route density to the edges
#graph <- graph %>%
#  activate(edges) %>%
#  mutate(weight = map_int(line, length))

# hubs
graph %>%
  activate(nodes) %>%
  as_tibble() %>%
  arrange(desc(degree)) %>%
  head(5)

# bottleneck
graph %>%
  activate(nodes) %>%
  as_tibble() %>%
  arrange(desc(betweenness)) %>%
  select(name, betweenness) %>%
  head(5)

