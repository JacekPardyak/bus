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



library('networkD3')

members <- rep(1, length(graph))
# Convert to object suitable for networkD3
df_d3 <- igraph_to_networkD3(graph, group = members)

# Create force directed network plot
forceNetwork(Links = df_d3$links, Nodes = df_d3$nodes, 
             Source = 'source', Target = 'target', 
             NodeID = 'name', Group = 'group', fontSize = 12)

radialNetwork(List = df_d3, fontSize = 10, opacity = 0.9)

?forceNetwork
