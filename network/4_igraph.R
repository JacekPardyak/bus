library(tidyverse)
library(tidygraph)
library(igraph)

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

graph <- routes %>% as_tbl_graph(directed = FALSE) %>% as.igraph()

graph

path <- shortest_paths(
  graph, 
  from = "Station Lelylaan", 
  to = "Amstelstation", 
  mode = "out"
)

# Extract names of stops in the path
V(graph)[path$vpath[[1]]]$name

# diameter

# 2. Calculate the Diameter (number of edges/segments)
network_diameter <- diameter(graph, directed = FALSE, weights = NA)

# 3. Find WHICH stops make up this longest path
diam_path <- get_diameter(graph, directed = FALSE, weights = NA)

# 4. Print the results
cat("The network diameter is:", network_diameter, "stops.\n")
cat("The longest path is:\n")
print(V(graph)[diam_path]$name)

g_diam <- induced_subgraph(graph, vids = diam_path)

ggraph(g_diam, layout = "fr") +
  geom_edge_link(alpha = 0.2) +
  geom_node_point(size = 2) +
  geom_node_text(aes(label = name), size = 3, repel = TRUE) +
  geom_edge_link(aes(color = line), alpha = 0.6) +
  theme_void()

