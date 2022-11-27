library('eurlex')
library(dplyr)
content <- elx_make_query(resource_type = "any", 
                          directory = "16", # 16 Science, information, education and culture
                          include_citations = T,  # references (links) to other legal documents
                          include_force = T) %>% # boolean in_force
  elx_run_query() %>% filter(force == "true") %>% 
  select(celex, citationcelex) 
content

elx_fetch_data(
  url = "31977L0486",
  type = c("ids"))

elx_fetch_data(
  url = "http://publications.europa.eu/resource/celex/32000L0031", 
  type = c("ids"))

?elx_make_query
