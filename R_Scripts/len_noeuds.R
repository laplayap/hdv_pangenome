library(ggplot2)
library(dplyr)

df_noeuds <- read.table("gfa_noeuds_lens.tsv", header = TRUE, sep = "\t")

# statistiques de base

node_stats <- df_noeuds %>%
  group_by(file, s, p) %>%
  summarise(
    n_nodes = n(),
    total_length = sum(len_noeud),
    mean_length = mean(len_noeud),
    median_length = median(len_noeud),
    min_length = min(len_noeud),
    max_length = max(len_noeud),
    .groups = "drop"
  )

# View results
print(node_stats)

######### PLOTS ################
# 1 histogramme par fichier (facets)
ggplot(df_noeuds, aes(x = len_noeud)) +
  geom_histogram(binwidth = 10, fill = "darkgreen", color = "red") +
  facet_wrap(~ outil, scales = "free_y") +
  labs(title = "Segment Length Distribution per GFA File",
       x = "Segment Length", y = "Count") +
  scale_y_log10()


ggplot(df_noeuds, aes(y = len_noeud)) +
  geom_boxplot() +
  facet_wrap(~ outil) +
  labs(title = "Segment Length Distribution per GFA File",
       x = "Segment Length", y = "Count") +
  scale_y_log10()

# tous sur le même plot
ggplot(df_noeuds %>% filter(s == 420), aes(x = len_noeud, fill = file)) +
  geom_histogram(binwidth = 10) +
  labs(title = "Segment Lengths by File",
       x = "Segment Length", y = "Count") +
  xlim(0, 1000) +
  scale_y_log10()


###########################################
### Boxplot des longeurs de noeuds

# Plot
ggplot(df_noeuds %>% filter(s == 420), aes(x = factor(p), y = len_noeud)) +
  geom_boxplot(fill = "lightblue", outlier.color = "red") +
  labs(title = "Longeurs des noeuds par p",
       x = "p",
       y = "Longeur Noeud") +
  theme_minimal() +
  scale_y_log10()

# variations
# echelle log 
ggplot(df_noeuds %>% filter(s == 420), aes(x = factor(p), y = len_noeud)) +
  geom_boxplot(fill = "lightblue", outlier.color = "red") +
  labs(title = "Longeurs des noeuds par p",
       x = "p",
       y = "Longeur Noeud") +
  theme_minimal() +
  scale_y_log10()

# rotation des labels x
ggplot(df_noeuds %>% filter(s == 420), aes(x = factor(p), y = len_noeud)) +
  geom_boxplot(fill = "lightblue", outlier.color = "red") +
  labs(title = "Longeurs des noeuds par p",
       x = "p",
       y = "Longeur Noeud") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# avec tous les points, sans outliers
ggplot(df_noeuds %>% filter(s == 420), aes(x = factor(p), y = len_noeud)) +
geom_boxplot(outlier.shape = NA, fill = "lightblue", alpha = 0.6) + 
  geom_jitter(width = 0.2, size = 0.2, alpha = 0.5, color = "black") +
  labs(title = "Segment Lengths per p",
       x = "p value",
       y = "Segment Length") +
  theme_minimal() +
  scale_y_log10()

