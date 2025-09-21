library(readr)
library(tidyr)
library(ggplot2)
library(tidyverse)

# Lire les données
data <- read_delim("topo_metrics_comp_nolongest.csv", delim = ";")

# Mettre en format long
data_long <- pivot_longer(data,
                          cols = c(node_count, total_length, dead_ends),
                          names_to = "metric",
                          values_to = "value") %>%
  mutate(metric = factor(metric,
                         levels = c("node_count", "total_length", "dead_ends"),
                         labels = c("Nombre de nœuds", "Longueur totale", "Extremités libres")))

# plot avec facettes
ggplot(data_long, aes(x = Outil, y = value, fill = Outil)) +
  geom_col(position = "dodge") +
  facet_wrap(~ metric, scales = "free_y", nrow = 1) +
  labs(x = "", y = "", fill = "",
       title = "") +
  theme_minimal() +
  theme(text = element_text(size = 18),
        strip.text = element_text(face = "bold"),
        plot.title = element_text(hjust = 0.5))
