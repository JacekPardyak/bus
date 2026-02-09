DiagrammeR::grViz("
graph G {
  layout=neato
  splines=true

  A [pos=\"0,0!\"]
  B [pos=\"2,0!\"]
  A -- B [pos=\"e,2,0 1,1 0,0\"]
}
") %>%
  DiagrammeRsvg::export_svg() %>% writeLines("test.svg")