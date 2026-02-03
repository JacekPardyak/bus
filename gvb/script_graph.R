library(tidyverse)
library(tidygraph)
library(ggraph)
# library(ggrepel)


"label, from, to
Bus15, Station Sloterdijk, Station Zuid
Bus18, Centraal Station, Slotervaart
Bus21, Centraal Station, Geuzenveld De Sav. Lohmanstraat
Bus22, Station Sloterdijk, Centraal Station
Bus34, Station Noord, Vogelbuurt Zuid
Bus35, Station Noord, Molenwijk
Bus36, Station Sloterdijk, Olof Palmeplein
Bus37, Station Noord, Amstelstation
Bus38, Olof Palmeplein, Buiksloterham
Bus39, Olof Palmeplein, Molenwijk
Bus40, Amstelstation, Muiderpoortstation
Bus41, Station Holendrecht, Amstelstation
Bus42, Centraal Station, Cruquius-eiland
Bus43, Centraal Station, Borneo Eiland
Bus44, Station Bijlmer ArenA, Diemen Noord
Bus47, Station Holendrecht, Station Bijlmer ArenA
Bus48, Centraal Station, Houthavens
Bus49, Station Bijlmer ArenA, IJburg Strandeiland
Bus61, Station Sloterdijk, Osdorpplein Noord
Bus62, Station Lelylaan, Amstelstation
Bus63, Station Lelylaan, Osdorp De Aker
Bus65, Amstelstation, KNSM-laan
Bus66, Station Bijlmer ArenA, IJburg
Bus68, Henk Sneevlietweg, John M. Keynesplein
Bus73, OLVG West, Slotermeerlaan
Bus75, Station Zuid, A.J. Ernststraat
BusN81, Centraal Station, Station Sloterdijk
BusN82, Centraal Station, Geuzenveld
BusN83, Centraal Station, Osdorp De Aker
BusN84, Centraal Station, Amstelveen Busstation
BusN85, Centraal Station, Gein
BusN86, Centraal Station, Station Bijlmer ArenA
BusN87, Centraal Station, Station Bijlmer ArenA
BusN88, Centraal Station, Nieuw Sloten
BusN89, Centraal Station, IJburg Strandeiland
BusN91, Centraal Station, Nieuwendam
BusN93, Centraal Station, Molenwijk
Bus218, Schiphol Airport/Plaza, Nieuwe Meer
Bus231, Station Sloterdijk, Abberdaan
Bus233, Station Sloterdijk, Sicilieweg
Bus245, Oostzanerdijk, Schiphol Airport/Plaza
Bus246, Borneolaan, Schiphol Airport/Plaza
Bus247, Bos en Lommerplein, Schiphol Airport/Plaza
Bus267, Anderlechtlaan, Anderlechtlaan
Bus360, Station Bijlmer ArenA, IJburg Strandeiland
Bus369, Station Sloterdijk, Schiphol Airport/Plaza
Bus461, Gelderlandplein, Zuidas
Bus463, Gelderlandplein, Bolestein
Bus464, Gelderlandplein, Vivaldi" %>% 
  I() %>% 
  read_csv() %>%
  select(from, to, label) %>%
  filter(!str_detect(label, "N")) %>%
  mutate(label = label %>%
           str_remove("Bus") %>%
           as.numeric()) %>%
  mutate(
    zone = case_when(
      label %in% c(18, 21, 34, 35, 37, 38, 43, 48, 245) ~ "Noord",
      label %in% c(40, 41, 44, 47, 49, 65, 66, 246, 360)    ~ "Zuid",
      label %in% c(15, 22, 36, 61, 62, 63, 231, 247, 369) ~ "West",
      TRUE                 ~ NA_character_
    )
  ) -> edges

# noord 
edges %>% filter(zone == "Noord") %>% 
  tbl_graph(edges = .) %>%
  ggraph(layout = "fr") +   # Fruchterman–Reingold
  geom_edge_link(
    aes(label = label),
    angle_calc = "along",
    label_dodge = unit(2, "mm") 
  ) +
  geom_node_point(size = 4) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_void()

# zuid
edges %>% filter(zone == "Zuid") %>% filter(label != 49) %>%
  bind_rows(
    tibble(from = c("Station Bijlmer ArenA", "Weesp"),
           to = c("Weesp", "IJburg Strandeiland"),
           label = 49)) %>% 
  tbl_graph(edges = .) %>% 
  ggraph(layout = "fr") +   # Fruchterman–Reingold
  geom_edge_link(
    aes(label = label),
    angle_calc = "along",
    label_dodge = unit(2, "mm")
  ) +
  geom_node_point(size = 4) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_void()

# west
edges %>% filter(zone == "West") %>% 
  tbl_graph(edges = .) %>%
  ggraph(layout = "fr") +   # Fruchterman–Reingold
  geom_edge_link(
    aes(label = label),
    angle_calc = "along",
    label_dodge = unit(2, "mm") 
  ) +
  geom_node_point(size = 4) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_void()

