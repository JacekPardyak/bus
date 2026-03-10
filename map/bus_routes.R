library(tidyverse)
library(sf)
library(leaflet)

nodes <- tribble(
  ~lat, ~lon, ~label, ~extras, 
  52.356290021297845, 4.834362397338657, "LLL", NA,
  52.35621378065894, 4.827406428432659, NA, NA,
  52.359172320110495, 4.8272431776692875, NA, NA,
  52.35914098299916, 4.821353845991882, NA, NA,
  52.35612658065249, 4.82137119400388, NA, NA,
  52.354264165541885, 4.810538183139382, NA, NA,
  52.36066527230617, 4.8070654648377324, NA, NA,
  52.3633231747922, 4.805733610117212, NA, NA,
  52.35990994665253, 4.789099705400813, NA, NA,
  52.362878058390464, 4.787501023699259, NA, NA,
  52.35723703792655, 4.777267512574908, NA, NA,
  
  52.35441447736492, 4.774580050984977, "MTH", NA,
  52.34690253730106, 4.827532274746933, NA, NA,
  52.346767590054334, 4.84640500757313, NA, NA,
  52.35127880312832, 4.849889024501056, NA, NA,
  52.35149292117285, 4.85658492812348, NA, NA,
  52.34518449415211, 4.85780174317118, NA, NA,
  52.346390522320846, 4.867122860779968, NA, NA,
  52.34063447656023, 4.868503174175615, NA, NA,
  52.340948869805004, 4.876895481938097, NA, NA,
  52.32480415729521, 4.8795529089167955, NA, NA,
  52.32504384377594, 4.890133318078224, NA, NA,
  52.34086488767244, 4.892298176564393, NA, NA,
  52.34041654629789, 4.901747871461794, NA, NA,
  52.34453443343013, 4.900808960779816, NA, NA,
  52.348229720923044, 4.918530356125096, NA, NA,
  52.345776341991325, 4.920004869627574, NA, NA,
  52.345249392534456, 4.919130940903276, "ASA", NA,
  
  52.31024369951967, 4.945738057163296, "BMR", NA,
  52.31045567839911, 4.951845883588449, NA, NA, #30
  52.30763366864346, 4.954405803257643, NA, NA,
  52.3165559998885, 4.9803969987347525, NA, NA,
  52.31237527149358, 4.986106113725575, NA, NA,
  52.31539960567921, 4.995542602345003, NA, NA,
  52.302355661235616, 5.036641900728093, NA, NA,
  52.31022946753296, 5.0349035952547565, NA, NA,
  52.31236720955433, 5.039381556644639, NA, NA,
  52.31028205274051, 5.043959275395764, NA, NA,
  
  52.31214010339056, 4.967629405134317, NA, NA,
  52.30672185619508, 4.973427252179521, NA, NA,
  52.33514218025501, 5.0006534568641205, NA, NA,
  52.33527729854737, 5.004685871056478, NA, NA,
  52.35299221812229, 5.010573990876841, NA, NA,
  
  52.35543357530146, 5.018445113903125, "BEDL", NA,
  
  52.32588596797865, 5.061832369048145, NA, NA,
  
  52.314039668610775, 4.9485002732695635, NA, NA, #46
  52.322621943022796, 4.973617445597756, NA, NA,
  52.32619111873464, 4.97002097251265, NA, NA,
  52.33386750860413, 4.977472824499223, NA, NA,
  52.33338682583368, 4.983907480517859, NA, NA,
  52.33840585547189, 4.9899438892710135, NA, NA,
  52.35947679534132, 4.987330771929268, "VPS", NA,
  
  52.34758448429936, 4.9293081627734745, NA, NA,
  52.354616985294804, 4.941409358298744, NA, NA,
  52.35594767990255, 4.9371563570512444, NA, NA,
  52.35897111416731, 4.940780590812693, NA, NA, # 56
  52.36165966939739, 4.939760600202866, NA, NA,
  52.368645695739374, 4.945100881118256, NA, NA,
  52.368729151862645, 4.938533810650472, NA, NA,
  52.373562005477055, 4.938457919429645, NA, NA,
  52.374169160156576, 4.944200680305432, NA, NA, # 61
  52.37699582120713, 4.937326239230404, NA, NA,
  52.377083436952766, 4.94600030565225, "KML", NA,
  
  52.34431792690979, 4.934476334771396, NA, NA,
  52.35431371244947, 4.951188377913554, NA, NA,
  52.35712733857892, 4.956038442611292, NA, "height=0.01",
  52.35612731087991, 4.960568459262354, NA, "height=0.01",
  52.353332554860074, 4.955928428330975, NA, NA, # 68
  52.36133169712008, 4.932868606216436, "MPS", NA,
  
  52.297784954422525, 4.959024733169506, "HLD", NA,
  52.30040069488222, 4.96662370932069, NA, NA,
  52.29810137598009, 4.968795572444898, NA, "height=0.01",
  52.298614485200865, 4.9728012692726224, NA, NA,
  52.2929344561892, 4.974598185816913, NA, NA,
  52.293038418946026, 4.988559755097683, NA, "height=0.01",
  52.30154909077672, 4.98922167111293, NA, NA,
  52.30160032697295, 4.9787088821979255, NA, NA,
  52.31808985388998, 4.98472239882742, NA, "height=0.01",
  52.32407771582726, 4.97894210184978, NA, "height=0.01",
  52.32086409220627, 4.968575272276806, NA, NA,
  52.31533054382924, 4.952192298452712, NA, NA,
  
  52.320579218200834, 4.947517127710878, NA, NA,
  
  52.30911030807881, 4.958691194478647, NA, NA,
  52.314516185994464, 4.974415024349532, NA, NA,
  52.32510188893704, 4.942957559341208, NA, NA,
  52.32225442606666, 4.940483656286097, NA, NA, #86
  52.324301808917355, 4.930670269535861, NA, NA,
  52.32729736957257, 4.939152728170801, NA, NA,
  52.33558598532866, 4.941956104953411, NA, NA,
  52.33414037122369, 4.946128141253588, NA, NA,
  52.33810254742133, 4.947197618449262, NA, "height=0.01",
  52.343375478557746, 4.933234481774547, NA, "height=0.01",
  52.325512347263256, 4.961727582415391, NA, NA,
  52.33378782908754, 4.95406457925766, NA, "height=0.01",
  52.33845059445377, 4.960579199137827, NA, NA,
  52.33699458891407, 4.967735138115503, NA, NA,
  
  52.33976624003793, 4.968236628701249, NA, NA,
  52.34097415744785, 4.963306655273816, NA, NA,
  52.34866388732473, 4.971287881181525, NA, NA,
  52.34818254245616, 4.973047355601351, NA, NA,
  52.35232393073274, 4.9760989292025, NA, NA,
  52.347235392127565, 4.985646094678235, "DMN", NA,
  52.35077379647647, 4.968918593652475, NA, NA,
  
#  52.360355881174286, 4.805275948110664 # osdorpplein lijn 18
) %>%
  mutate(id = row_number())

edges <- tribble(
  ~from, ~to, ~lines, ~label, ~extras,
  1, 2, "62,63", "Pieter Calandlaan", NA,
  2, 3, "63", "Johan Huizingalaan", NA,
  3, 4, "63", "Comeniusstraat", NA,
  4, 5, "63", "Hemsterhuisstraat \n Luis Bouwmeesterstraat", NA,
  5, 6, "63", "Pieter Calandlaan", NA,
  6, 7, "63", "Meer en Vaart", NA,
  7, 8, "63", "Meer en Vaart", NA,
  8, 9, "63", "Osdorper Ban", NA,
  9, 10, "63", "Baden Powellweg", NA,
  10, 11, "63", "Ookmeerweg", NA,
  11, 12, "63", "Baldwinstraat", NA,
  2, 13, "62", "Johan Huizingalaan", NA,
  13, 14, "62", "Aletta Jacobslaan \n Vlaardingenlaan \n (via St. Henk Sneevlietweg)", NA,
  14, 15, "62", "Aalsmeer-plein \n –weg", NA,
  15, 16, "62", "Hoofddorp-plein \n -weg \n Zeil-brug \n –straat", NA,
  16, 17, "62", "Amstelveenseweg \n (via Haarlemmermeerstation)", NA,
  17, 18, "62", "Stadionweg \n Olympiaplein", NA,
  18, 19, "62", "Parnassusweg", NA,
  19, 20, "62", "Strawinskylaan \n (via St. Zuid)", NA,
  20, 21, "62", "Beethovenstraat \n Van Leijenberghlaan", NA,
  21, 22, "62", "Van Boshuizenstraat", NA,
  22, 23, "62", "Europaboulevard \n (via St. RAI) \n Europaplein", NA,
  23, 24, "62", "President Kennedylaan", NA,
  24, 25, "62", "Waalstraat", NA,
  25, 26, "62", "Rooseveltlaan \n Victorieplein \n Vrijheidslaan \n Berlagebrug \n Mr. Treublaan \n Prins Bernhardplein", NA,
  26, 27, "62", "Julianaplein", NA,
  27, 28, "40,41,62,65", "Overzichtweg", NA,
  
  29, 30, "44,47,49,66,360", "Hoogoorddreef", NA,
  30, 31, "49,360", "Foppingadreef", NA,
  31, 83, "49,360", "Karspeldreef", NA,
  83, 39, "41,49,360", "Karspeldreef", NA,
  39, 84, "41,49", "Karspeldreef", NA,
  
  84, 32, "49", "Karspeldreef", NA,
  32, 33, "47,49", "Kromwijkdreef \n (via St. Kraaiennest)", NA,
  33, 34, "49", "Loosdrechtdreef", NA,
  34, 35, "49", "Provincialeweg \n Weesperbrug \n Gooilandseweg", NA,
  35, 36, "49", "C.J. van Houtenlaan \n Prinses Irenelaan \n Casparuslaan", NA,
  36, 37, "49", "Plataanlaan \n Herensingel \n Jan Tooropstraat", NA,
  37, 38, "49", "M. Nijfoffstraat \n Herensingel \n (via St. Weesp)", NA,
  
  39, 40, "360", "Gooiseweg", NA,
  40, 33, "47,360", "Langbroekdreef \n (via St. Gaasperplas)", NA,
  33, 41, "360", "[A9] \n [A1]: Zaanstad \n (1a): IJburg", NA,
  41, 42, "66,360", "Diemerpolderweg \n (via Diemerknoop)", NA,
  42, 43, "49,66,360", "Fortdiemerdamweg \n (via Uyllanderbrug \n Benno Premselabrug) \n Muiderlaan", NA,
  43, 44, "49,360", "Pampuslaan", NA,
  38, 45, "49", "Stationsweg \n Korte Muiderweg \n Weesperweg", NA,
  45, 42, "49", "Mariahoeveweg \n (via P+R Muiden) \n Busbaan \n Maxisweg \n Diemerpolderweg \n (via Muiderbrug)", NA,

  30, 46, "44,47,66", "Foppingadreef", NA,
  46, 81, "44,47,66", "Bijlmerdreef", NA,
  81, 80, "41,47,66", "Bijlmerdreef", NA,
  80, 47, "47,66", "Bijlmerdreef", NA,
  47, 48, "66", "Elsrijkdreef \n (via St. Ganzenhoef)", NA,
  48, 49, "66", "Provincialeweg", NA,
  49, 50, "66", "Muiderstraatweg", NA,
  50, 51, "66", "Weteringweg", NA,
  51, 41, "66", "Diemerpolderweg", NA,
  43, 52, "66", "Pampuslaan \n IJburglaan", NA,
  
  27, 53, "40,41,65", "Hugo de Vrieslaan", NA,
  53, 54, "65", "Hugo de Vrieslaan \n Wethouder Frankeweg \n Galileïplantsoen", NA,
  54, 55, "65", "Archimedesweg", NA,
  55, 56, "65", "Molukkenstraat", NA,
  56, 57, "40,65", "Molukkenstraat", NA,
  57, 58, "65", "Molukkenstraat \n Veelaan \n (via Veebrug & Slachthuisbrug)", NA,
  58, 59, "65", "Cruquiusweg", NA,
  59, 60, "65", "C. van Eesterenlaan", NA,
  60, 61, "65", "J.F. Van Hengelstraat", NA,
  61, 62, "65", "Verbindingsdam \n Azartplein", NA,
  62, 63, "65", "KNSM-Laan", NA,
  
  53, 64, "40,41", "Maxwellstraat", NA,
  64, 65, "40", "Kruislaan", NA,
  65, 66, "40", "Science Park", NA,
  66, 67, "40", "", NA,
  67, 68, "40", "", NA,
  68, 65, "40", "Carolina MacGillavrylaan", NA,
  65, 56, "40", "Carolina MacGillavrylaan", NA,
  57, 69, "40", "Insulindeweg", NA,
  
  70, 71, "41,47", "Meibergdreef \n Holendrechtdreef", NA,
  71, 72, "47", "Meerkerkdreef", NA,
  72, 73, "47", "", NA,
  73, 74, "47", "Reigersbosdreef \n (via St. Reigersbos)", NA,
  74, 75, "47", "Schoonhovendreef", NA,
  75, 76, "47", "Wageningendreef \n (via St. Gein)", NA,
  76, 77, "47", "Valburgdreef", NA,
  77, 40, "47", "Langbroekdreef", NA,
  32, 78, "47", "Karspeldreef", NA,
  78, 79, "47", "`s-Gravendijkdreef", NA,
  79, 47, "47", "Bijlmerdreef", NA,
  81, 82, "41,44", "Dolingadreef", NA,
  82, 85, "41", "Dolingadreef", NA,
  71, 83, "41", "Meerkerkdreef", NA,
  84, 80, "41", "Groesbeekdreef", NA,
  85, 86, "41", "Busbaan", NA,
  86, 87, "41", "Pablo Nerudalaan \n Stationsweg \n (via St. Duivendrecht)", NA,
  87, 88, "41", "Busbaan", NA,
  88, 89, "41", "Rijksstraatweg", NA,
  89, 90, "41", "Randweg", NA,
  90, 91, "41", "Rozenburglaan", NA,
  91, 92, "41", "Rozenburglaan", NA,
  92, 64, "41", "Kruislaan", NA,
  82, 93, "44", "Daalwijkdreef", NA,
  93, 94, "44", "Bergwijkdreef \n (via St. Diemen Zuid) \n Boven Rijkersloot \n Beneden R.", NA,
  94, 95, "44", "Beneden R. \n Boven R. \n Beukenhorst", NA,
  95, 96, "44", "Hartveldseweg \n Muiderstraatweg", NA,
  96, 97, "44", "Prins Bernhardlaan", NA,
  97, 98, "44", "Prinses Beatrixlaan", NA,
  98, 99, "44", "Ouddiemerlaan \n (via St. Diemen)", NA,
  99, 100, "44", "Diemerpolderweg", NA,
  100, 101, "44", "Vogelweg \n Tureluurweg \n Rietzangerweg", NA,
  101, 102, "44", "Meerkoet \n Fregat \n Hermelijnvlinder", NA,
  101, 103, "44", "Oude Waelweg", "style = dashed",
  103, 100, "44", "Buytenweg", "style = dashed",
  
)  %>% rowwise() %>%
  mutate(label = glue::glue("{label} \n [{lines}]")) %>%
  mutate(label = htmltools::HTML(gsub("\n", "<br>", label))) %>%
  ungroup()

edges <- edges %>%
  left_join(nodes %>% select(-c("label", "extras")), by = c("from" = "id")) %>%
  rename(from_lat = lat, from_lon = lon) %>%
  left_join(nodes %>%  select(-c("label", "extras")), by = c("to" = "id")) %>%
  rename(to_lat = lat, to_lon = lon) %>%
  mutate(
    geometry = pmap(
      list(from_lon, from_lat, to_lon, to_lat),
      ~ st_linestring(matrix(c(..1, ..2, ..3, ..4), ncol = 2, byrow = TRUE))
    )
  ) %>%
  st_as_sf(crs = 4326)

nodes <- st_as_sf(nodes, coords = c("lon","lat"), crs = 4326)

leaflet() %>%
  addTiles() %>%
  addPolylines(data = edges, 
               label = ~label,
               labelOptions = labelOptions(noHide = TRUE)) %>%
  addCircleMarkers(data = nodes, label = ~ifelse(is.na(label), id, label))

#
# select lines
selected_lines <- as.character(c(40,65)) # 40, 41, 44, 47, 49, 62, 63, 65, 66, 360
cell_size <- 300

all_edges <- edges %>% st_drop_geometry() %>% select(c("from", "to", "label", "lines", "extras")) %>%
  mutate(label = gsub("<br>", "\n", label)) %>% mutate(lines = strsplit(lines, ","))

all_nodes <- nodes%>% st_transform(28992)
coords <- st_coordinates(all_nodes)

all_nodes$x <- coords[,1]
all_nodes$y <- coords[,2]

all_nodes <- all_nodes %>% st_drop_geometry() 

all_nodes$x <- floor((all_nodes$x - min(all_nodes$x)) / cell_size) + 1
all_nodes$y <- floor((all_nodes$y - min(all_nodes$y)) / cell_size) + 1


# 1. Filter Edges
edges <- all_edges %>%
  filter(map_lgl(lines, ~ any(.x %in% selected_lines)))

# 2. Filter Nodes (based on the filtered edges)
active_nodes <- unique(c(edges$from, edges$to))

nodes <- all_nodes %>%
  filter(id %in% active_nodes)


node_lines <- glue::glue(
  '{nodes$id} [pos="{nodes$x},{nodes$y}!" , label = "{ifelse(is.na(nodes$label), "", nodes$label)}" {ifelse(is.na(nodes$extras), "", paste0(", ", nodes$extras))}]'
)

edge_lines <- glue::glue(
  '{edges$from} -> {edges$to} [label = "{ifelse(is.na(edges$label), "", edges$label)}" {ifelse(is.na(edges$extras), "", paste0(", ", edges$extras))}]'
)


graph_code <- glue::glue('
digraph {{
  layout = neato
  node [shape = circle, style = filled, fillcolor = lightgray, color = gray, height=0.1, label = "", fontsize = 10, fontname = "Arial"]
  edge [color = gray, fontsize = 10, fontname = "Arial", dir = none]
  
  {paste(node_lines, collapse = "\n")}
  
  {paste(edge_lines, collapse = "\n")}
}}
')

graph_code
#graph_code %>% writeLines("map/test.gv")

grViz(graph_code)
