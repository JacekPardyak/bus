library(tidyverse)
library(visNetwork)

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
all_stops <- unique(c(routes$from, routes$to))

nodes <- data.frame(
  id = 1:length(all_stops),
  label = all_stops,
  title = paste("Stop:", all_stops), # Tooltip on hover
  group = "Bus Stop" # All stops are in the same group
)

# 2. Add an ID lookup column to make creating edges faster
nodes_id_lookup <- nodes %>% select(id, label)

# 3. Create Edges using the Node IDs
# We map the text names in your table to the numeric IDs visNetwork requires
network_edges <- routes %>%
  left_join(nodes_id_lookup, by = c("from" = "label")) %>%
  rename(from_id = id) %>%
  left_join(nodes_id_lookup, by = c("to" = "label")) %>%
  rename(to_id = id) %>%
  
  # Clean up and prepare columns specifically for visNetwork
  mutate(
    # Unpack the list into a comma-separated string for the tooltip
    lines_label = map_chr(line, ~ paste(.x, collapse = ", ")),
    title = paste("Routes:", lines_label), # Tooltip when you hover
    
    # Optional: Count how many distinct lines use this edge
    route_count = map_int(line, ~ length(unique(.x)))
  ) %>%
  
  # Select the required columns for the edges
  select(from = from_id, to = to_id, title, route_count)

# 4. Generate the Interactive Visualization
visNetwork(nodes, network_edges, main = "GVB Comprehensive Network Graph") %>%
  
  # Standardize Node looks
  visNodes(shape = "dot", size = 25, font = list(size = 18)) %>%
  
  # Standardize Edge looks (light gray, semi-transparent)
  visEdges(
    color = list(color = "#rgba(120, 120, 120, 0.4)", highlight = "#FFD700"), # Gold highlight on click
    arrows = "to" # Directed graph (bus routes are distinct)
  ) %>%
  
  # Added features: search dropdown, highlight neighbors, navigation buttons
  visOptions(
    highlightNearest = TRUE, 
    nodesIdSelection = list(enabled = TRUE, main = "Find a Stop")
  ) %>%
  
  visInteraction(navigationButtons = TRUE, multiselect = TRUE) %>%
  
  # Define the layout algorithm (ForceAtlas2 is great for transport maps)
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -80))
