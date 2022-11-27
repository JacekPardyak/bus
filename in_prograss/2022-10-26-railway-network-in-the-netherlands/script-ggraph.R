library(plotly)
library(igraph)
library(dplyr)


edgelist <- read_csv("./content/post/2022-10-26-railway-network-in-the-netherlands/network.csv",
                  comment = "#") %>%
  distinct() #%>% filter(from != to)


moneyNetwork <- graph_from_data_frame(edgelist)

graph <- graph_from_data_frame(edgelist)
L <- layout_nicely(graph)
vs <- V(graph)
es <- as.data.frame(get.edgelist(graph))
Ne <- length(es[1]$V1)
Xn <- L[,1]
Yn <- L[,2]

network <- plot_ly(type = "scatter", 
                   x = Xn, 
                   y = Yn, 
                   mode = "markers+text", 
                   text = names(vs), 
)


edge_shapes <- list()
for(i in 1:Ne) {
  v0 <- es[i,]$V1
  v1 <- es[i,]$V2
  
  edge_shape = list(
    type = "line",
    line = list(color = "#030303", width = 0.3),
    x0 = Xn[match(v0,names(vs))],
    y0 = Yn[match(v0,names(vs))],
    x1 = Xn[match(v1,names(vs))],
    y1 = Yn[match(v1,names(vs))],
    opacity = 1
  )
  
  edge_shapes[[i]] <- edge_shape}

network <- layout(
  network,
  shapes = edge_shapes,
  xaxis = list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE),
  yaxis = list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE)
)

network
