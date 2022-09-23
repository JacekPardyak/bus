# source:
# https://en.wikipedia.org/wiki/List_of_countries_and_territories_by_land_and_maritime_borders
library(tidyverse)
library(sf)
library(rnaturalearth)

europe <- ne_countries(scale = "medium", returnclass = "sf", continent = "Europe")
cyprus <- ne_countries(scale = "medium", returnclass = "sf", country = "Cyprus")
europe <- europe %>% bind_rows(cyprus)

countries <- europe %>% 
  st_drop_geometry() %>%  
  select(sovereignt) %>% distinct() %>% arrange(sovereignt) %>% pull()


neighbours <- 
  "country, neighbour, type
Albania, Greece,
Albania, Italy, M
Albania, Montenegro,
Albania, Macedonia, L
Albania, Kosovo, L

Andorra, France, L
Andorra, Spain, L

Austria, Czech Republic, L
Austria, Germany, L
Austria, Hungary, L
Austria, Italy, L
Austria, Liechtenstein, L
Austria, Slovakia, L
Austria, Slovenia, L
Austria, Switzerland, L

Belarus, Latvia, L
Belarus, Lithuania, L
Belarus, Poland, L
Belarus, Russia, L
Belarus, Ukraine, L

Belgium, France,
Belgium, Germany, L
Belgium, Luxembourg, L
Belgium, Netherlands,
Belgium, United Kingdom, M

Bosnia and Herzegovina, Croatia,
Bosnia and Herzegovina, Montenegro, L
Bosnia and Herzegovina, Republic of Serbia, L

Bulgaria, Greece, L
Bulgaria, Macedonia, L
Bulgaria, Romania,
Bulgaria, Republic of Serbia, L
Bulgaria, Russia, M
Bulgaria, Ukraine, M

Croatia, Hungary, L
Croatia, Italy, M
Croatia, Montenegro,
Croatia, Republic of Serbia, L
Croatia, Slovenia,

Cyprus, Greece, M

Czech Republic, Germany, L
Czech Republic, Poland, L
Czech Republic, Slovakia, L

Denmark, Germany,
Denmark, Norway, M
Denmark, Poland, M
Denmark, Sweden, M
Denmark, United Kingdom, M

Estonia, Finland, M
Estonia, Latvia,
Estonia, Russia,
Estonia, Sweden, M

Finland, Norway, L
Finland, Russia,
Finland, Sweden,

France, Germany, L
France, Italy,
France, Luxembourg, L
France, Monaco,
France, Spain,
France, Switzerland, L
France, United Kingdom, M

Germany, Luxembourg, L
Germany, Netherlands,
Germany, Poland,
Germany, Sweden, M
Germany, Switzerland, L
Germany, United Kingdom, M

Greece, Italy, M
Greece, Macedonia, L

Hungary, Romania, L
Hungary, Republic of Serbia, L
Hungary, Slovakia, L
Hungary, Slovenia, L
Hungary, Ukraine, L

Iceland, Denmark, M
Iceland, Norway, M

Ireland, United Kingdom,

Italy, Malta, M
Italy, Montenegro, M
Italy, San Marino, L
Italy, Slovenia,
Italy, Spain, M
Italy, Switzerland, L
Italy, Vatican, L

Kosovo, Montenegro, L
Kosovo, Macedonia, L
Kosovo, Republic of Serbia, L

Latvia, Lithuania,
Latvia, Russia, L
Latvia, Sweden, M

Liechtenstein, Switzerland, L

Lithuania, Poland, L
Lithuania, Russia,
Lithuania, Sweden, M

Macedonia, Republic of Serbia, L

Moldova, Romania, L
Moldova, Ukraine, L

Montenegro, Republic of Serbia, L

Netherlands, United Kingdom, M

Norway, Russia, 
Norway, Sweden,
Norway, United Kingdom, M

Poland, Russia,
Poland, Slovakia, L
Poland, Sweden, M
Poland, Ukraine, L

Portugal, Spain, 

Republic of Serbia, Romania, L

Romania, Russia, M
Romania, Republic of Serbia, L
Romania, Ukraine,

Russia, Sweden, M
Russia, Ukraine,
Slovakia, Ukraine, L" %>% I() %>% read_csv()


library(jsonlite)

result <- tibble()
for (cnt in countries) {
  tmp <- neighbours %>% filter(country == cnt) %>% select(neighbour, type) 
  if(nrow(tmp) > 0) {
  row = tibble(country = cnt, neighbours = list(tmp))
  result <- result %>% bind_rows(row)}
}

result  %>% toJSON() %>% write("./cartoon/neighbours.json")

