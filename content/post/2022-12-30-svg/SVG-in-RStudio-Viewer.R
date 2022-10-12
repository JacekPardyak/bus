library(DiagrammeR)
library(DiagrammeRsvg)

file = "Huis_Oranje-Nassau.svg"
'digraph{a->b; c->a; c->b; c->d;}' %>%
  grViz() %>% 
  export_svg() %>%
  writeLines(file)

library(htmltools)
file %>% 
  readLines() %>%
  HTML() %>% 
  html_print()

