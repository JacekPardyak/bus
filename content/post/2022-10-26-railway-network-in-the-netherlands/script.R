library(tidyverse)
library(igraph)
library(visNetwork)

# prepare list of stations
df <- "https://en.wikipedia.org/wiki/Railway_stations_in_the_Netherlands" %>%
  polite::bow() %>%
  polite::scrape() %>%  # scrape web page
  rvest::html_nodes("table.wikitable") %>% # pull out specific table
  rvest::html_table(fill = TRUE) %>%
  first() %>% select(Station)
#df <- df %>% bind_cols(df) %>% rename(from = "Station...1", to = "Station...2") %>%
#  write_csv("./content/post/2022-10-26-railway-network-in-the-netherlands/network.csv")

# make visNetwork
graph <- read_csv("./content/post/2022-10-26-railway-network-in-the-netherlands/network.csv",
         comment = "#") %>%
  graph_from_data_frame()
graph %>%
  toVisNetworkData() -> df
visNetwork(nodes = (df$nodes %>% 
                      arrange(id) ),
           edges = df$edges) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)



?forceNetwork
library(ggnetwork)
ggplot(ggnetwork(graph), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_edges() +
  theme_blank()

ggnetwork(graph) -> n

ggplot(n, aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_edges(color = "black") +
  geom_nodelabel(aes(label = name), fontface = "bold") +
  theme_blank()

library(tidygraph)
nodes <- tibble(name = c("Hadley", "David", "Romain", "Julia"))
edges <- data.frame(from = c(1, 1, 1, 2, 3, 3, 4, 4, 4),
                    to = c(2, 3, 4, 1, 1, 2, 1, 2, 3))
network <- tbl_graph(nodes = nodes, edges = edges, directed = F)
network

tidy_net <- as_tbl_graph(graph)
plot(tidy_net)


library(ggraph)
tidy_net %>%
  ggraph(layout = "kk") +
  geom_node_point() +
  geom_edge_link()  + 
  geom_node_text(aes(label = name), repel = TRUE, size = 7)
