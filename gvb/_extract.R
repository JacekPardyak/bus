library(stringr)
library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(DiagrammeR)

dot <- read_file("./gvb/cen.gv")
grViz(dot)

nodes <- dot %>%
  str_split("\n") %>%
  unlist() %>%
  str_trim() %>%
  
  # keep only node definitions (start with number, no arrow)
  .[str_detect(., "^\\d+\\s*\\[") & !str_detect(., "->")] %>%
  
  tibble(raw = .) %>%
  
  mutate(
    id = str_extract(raw, "^\\d+"),
    pos = str_extract(raw, 'pos\\s*=\\s*"[^"]+"'),
    label = str_extract(raw, 'label\\s*=\\s*"[^"]+"')
  ) %>%
  
  mutate(
    pos = str_remove_all(pos, 'pos\\s*=\\s*"|!"'),
    label = str_remove_all(label, 'label\\s*=\\s*"|"')
  ) %>%
  
  separate(pos, into = c("x", "y"), sep = ",") %>%
  
  mutate(
    id = as.numeric(id),
    x = as.numeric(str_trim(x)),
    y = as.numeric(str_trim(y)),
    label = replace_na(label, "")
  ) %>%
  
  select(id, x, y, label)

edges <- dot %>%
  str_split("\n") %>%
  unlist() %>%
  str_trim() %>%
  
  # keep only edge lines
  .[str_detect(., "->")] %>%
  
  tibble(raw = .)%>%
  
  mutate(
    from = str_match(raw, "^(\\d+)\\s*->")[,2],
    to   = str_match(raw, "->\\s*(\\d+)")[,2],
    label = str_match(raw, 'label\\s*=\\s*"([^"]*)"')[,2]
  )  %>%
  
  mutate(
    from = as.numeric(from),
    to = as.numeric(to),
    label = str_remove_all(label, 'label\\s*=\\s*"|"')
  ) %>%
  
  select(from, to, label)

  readODS::write_ods(
    list(
      nodes = nodes,
      edges = edges
    ),
    "./gvb/extract.ods"
  )
  
