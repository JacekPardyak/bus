library(tidyverse)
library(sparklyr)
sc <- spark_connect(master = "local")

connection_is_open(sc)

iris %>% head() 
iris_tbl <- iris %>% 
  copy_to(sc, df = ., overwrite = TRUE) %>%
  sdf_with_sequential_id(id = "id", from = 1L)

iris_tbl %>% show()


# each numeric column is transformed into a discretized column, with breaks specified through the splits parameter.
# Each class is {0, 1, 2} 


iris_tbl <- iris_tbl %>%
  ft_bucketizer(
    input_col = "Sepal_Length",
    output_col = "Sepal_Length_",
    splits = c(4.3, 5.5, 6.7, 7.9)
  ) %>%
  ft_bucketizer(
    input_col = "Sepal_Width",
    output_col = "Sepal_Width_",
    splits = c(2, 2.8, 3.6, 4.4)
  ) %>%
  ft_bucketizer(
    input_col = "Petal_Length",
    output_col = "Petal_Length_",
    splits = c(0.994, 2.97, 4.93, 6.91)
  ) %>%
  ft_bucketizer(
    input_col = "Petal_Width",
    output_col = "Petal_Width_",
    splits = c(0.0976, 0.9, 1.7, 2.5)
  ) %>%
  select(id, Sepal_Length_, Sepal_Width_, Petal_Length_, Petal_Width_, Species) %>%
  rename(Sepal_Length = Sepal_Length_) %>%
  rename(Sepal_Width = Sepal_Width_) %>%
  rename(Petal_Length = Petal_Length_) %>%
  rename(Petal_Width = Petal_Width_) %>%
  mutate(Sepal_Length = if_else(Sepal_Length == 0, "low", if_else(Sepal_Length == 1, "medium", "high"))) %>%
  mutate(Sepal_Width = if_else(Sepal_Width == 0, "low", if_else(Sepal_Width == 1, "medium", "high"))) %>%
  mutate(Petal_Length = if_else(Petal_Length == 0, "low", if_else(Petal_Length == 1, "medium", "high"))) %>%
  mutate(Petal_Width = if_else(Petal_Width == 0, "low", if_else(Petal_Width == 1, "medium", "high"))) %>%
  pivot_longer(!id) %>% 
  mutate(item = paste(name, "=", value)) %>% 
  group_by(id) %>%
  summarise(items = collect_list(item))


iris_tbl %>% show()
iris_tbl %>% filter(id == 1) %>% select(items) %>% pull() %>% unlist()

fp_growth_model <- ml_fpgrowth(x = iris_tbl,
                               min_confidence = 0.8,
                               min_support = 0.3)

arules <- ml_association_rules(fp_growth_model) %>% collect() %>% rowwise() %>%
  mutate(antecedent = paste(unlist(antecedent), collapse = ", ")) %>%
  rowwise() %>% mutate(consequent = unlist(consequent))
arules

fitems <- ml_freq_itemsets(fp_growth_model) %>% collect()

arules
