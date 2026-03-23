library(pdftools)
library(tidyverse)

Centraal_Station = c(18, 21, 43, 48)
Station_Noord = c(34, 37)
Olof_Palmeplein = c(38, 39)
Amstelstation = c(40, 65)
Station_Bijlmer_ArenA = c(49, 66, 360)
Station_Holendrecht = c(41, 44, 47)
Station_Lelylaan = c(62, 63)
Station_Sloterdijk = c(15, 22, 36, 61, 369)

lines = c(Centraal_Station, 
          Station_Noord, 
          Olof_Palmeplein, 
          Amstelstation, 
          Station_Bijlmer_ArenA, 
          Station_Holendrecht,
          Station_Lelylaan, 
          Station_Sloterdijk)

lines <- c(62, 63) #18, 21, 43, 48, # Centraal     34, 37 # Noord  )

paths <- list.files(path = "./network/data/", 
                    pattern = "\\.pdf$", 
                    full.names = TRUE)
result <- list()

for (path in paths){
  line <- str_extract(path, "(?<=lineNumber=)\\d+")
  if (line %in% lines){
    print(line)
    stops <- path %>%
      pdf_text() %>%
      str_split("\n") %>%             # Split string into a list of lines
      unlist() %>%                    # Flatten to a vector
      as_tibble() %>%
      mutate(
        value = str_replace_all(value, "[^\x01-\x7F]+", ""),
        value = str_remove_all(value, "[0-9]"),
        value = str_squish(value)
      ) %>%
      filter(!str_detect(value, "^Bus\\s")) %>%
      filter(!str_detect(value, "^Informatie\\s")) %>%
      filter(!str_detect(value, "^Vertrektijden\\s")) %>%
      filter(!str_detect(value, "^Lijnen\\s")) %>%
      filter(!str_detect(value, "^en\\s")) %>%
      filter(!str_detect(value, "^\\(Gebruikelijke\\s")) %>%
      filter(!str_detect(value, "^Maandag\\s")) %>%
      mutate(
        value = str_replace(value, "Lumirestraat", "Lumièrestraat"),
        value = str_replace(value, "Plein ' - '", "Plein '40 - '45"),
        value = str_replace(value, "Atatrk", "Atatürk"),
        value = str_replace(value, "Burgemeester Rellstraat", "Burgemeester Röellstraat"),
        value = str_replace(value, "Belgiplein", "Belgiëplein"),
      ) %>%
      filter(value != "") %>% select(value) %>% distinct() %>% pull()
    
    result[[length(result) + 1]] <- tibble(
      line = line,
      stops = list(stops)
    )
  }
}

result <- bind_rows(result)

result %>% jsonlite::write_json("./network/routes.json", pretty = T)


