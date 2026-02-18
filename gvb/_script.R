g <- "
graph G {
  layout=neato
  splines=true

  A [pos=\"0,0!\"]
  B [pos=\"2,0!\"]
  A -- B [pos=\"e,2,0 1,1 0,0\"]
}
"
g |> writeLines("test.gv")

g |> DiagrammeR::grViz() |>
  DiagrammeRsvg::export_svg() |>
  writeLines("test.svg")

ig <- read_graph("test.gv")

# 4. Export to GraphML
write_graph(ig, file = "my_graph.graphml", format = "graphml")


?DiagrammeR

library(igraph)

ig <- to_igraph(NRD)
write_graph(ig, "NRD.graphml", format = "graphml")
