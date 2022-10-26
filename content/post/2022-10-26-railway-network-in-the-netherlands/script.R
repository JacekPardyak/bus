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
read_csv("./content/post/2022-10-26-railway-network-in-the-netherlands/network.csv") %>%
  graph_from_data_frame() %>%
  toVisNetworkData() -> df
visNetwork(nodes = df$nodes, edges = df$edges) 
