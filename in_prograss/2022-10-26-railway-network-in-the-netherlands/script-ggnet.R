library(GGally)
library(network)
library(sna)
library(ggplot2)  
net = rgraph(10, mode = "graph", tprob = 0.5)

x <- read_csv("./content/post/2022-10-26-railway-network-in-the-netherlands/network.csv",
                  comment = "#") %>%
  distinct() %>% filter(from != to)

net = network(x, directed = FALSE, loops = F)

ggnet2(net, label = TRUE) +
  coord_equal()

?network


  