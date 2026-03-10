library(dplyr)
library(glue)
library(DiagrammeR)
library(purrr)

all_edges <- readODS::read_ods("./gvb/data.ods", sheet = "edges") %>% mutate(lines = strsplit(lines, ";"))
all_nodes <- readODS::read_ods("./gvb/data.ods", sheet = "nodes")

# select lines
selected_lines <- as.character(c(15, 18, 21, 22)) # 15, 18, 22, 36, 61, 62, 63, 369, 245

# 1. Filter Edges
edges <- all_edges %>%
  filter(map_lgl(lines, ~ any(.x %in% selected_lines)))

# 2. Filter Nodes (based on the filtered edges)
active_nodes <- unique(c(edges$from, edges$to))

nodes <- all_nodes %>%
  filter(id %in% active_nodes)


node_lines <- glue(
  '{nodes$id} [pos="{nodes$x},{nodes$y}!" , label = "{ifelse(is.na(nodes$label), "", nodes$label)}" {ifelse(is.na(nodes$extras), "", paste0(", ", nodes$extras))}]'
)

edge_lines <- glue(
  '{edges$from} -> {edges$to} [label = "{ifelse(is.na(edges$label), "", edges$label)}" {ifelse(is.na(edges$extras), "", paste0(", ", edges$extras))}]'
)


graph_code <- glue('
digraph {{
  layout = neato
  node [shape = circle, style = filled, fillcolor = lightgray, color = gray, height=0.1, label = "", fontsize = 10, fontname = "Arial"]
  edge [color = gray, fontsize = 10, fontname = "Arial", dir = none]
  
  {paste(node_lines, collapse = "\n")}
  
  {paste(edge_lines, collapse = "\n")}
}}
')

graph_code

grViz(graph_code)


# ----------------
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


'id, x, y, label, extras
1, 0, 0, "BMR",
2, 1, 0,,
3, 1, 1,,
4, 1,-1,,
5, 2, 1,,
6, 2,-1,,
7, 3,-1,,
' %>%
  read_csv() -> nodes

# \\n for new line in csv

'from, to, label, lines, extras
1 , 2 , "Hoogoord-\\n-dreef", 44|49|66|360,
2 , 3, "Foppingadreef", 44|66,
2 , 4, "Foppingadreef", 49|360,
3 , 5, "Bijlmerdreef", 44|66,
4 , 6, "Karspeldreef", 49|360,
6 , 7, "Karspeldreef", 49,
' %>%
  read_csv() %>% mutate(lines = strsplit(lines, "\\|"))-> edges

tt <- edges$lines[[1]]
class(tt)

edges <- edges %>%
  mutate(lines = map_chr(lines, ~ paste(.x, collapse = "|")))

write_ods(
  list(
    nodes = nodes,
    edges = edges
  ),
  "./gvb/data.ods"
)

