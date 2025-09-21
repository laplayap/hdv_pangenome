library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)

# lecture des données
cuttle_data <- read_tsv("eval_cuttlefish_k.tsv")

cuttle_data <- cuttle_data %>%
  mutate(
    k = as.numeric(k),
    seq = factor(seq, levels = c("ref", "val"))
  )

# groupes par mid et type de séquence (ref ou val)
cuttle_summary <- cuttle_data %>%
  group_by(k, seq) %>%
  summarise(
    mean_aln_id = mean(aln.id, na.rm = TRUE),
    se = sd(aln.id, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(
    ci_low = mean_aln_id - 1.96 * se,
    ci_high = mean_aln_id + 1.96 * se
  )

###### plot lignes moyenne avec ecart type #########
ggplot(cuttle_summary, aes(x = k, y = mean_aln_id, color = seq)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high)) +
  labs(
    title = "Identité moyenne sur pangénomes Cuttlefish ± IC 95%",
    x = "Cuttlefish k",
    y = "Identité moyenne"
  ) +
  scale_color_manual(
    values = c("ref" = "black", "val" = "steelblue1"),
    labels = c("ref" = "séquences de référence", "val" = "séquences de validation")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10)),
    axis.text.x = element_text(size = 14),                  
    axis.text.y = element_text(size = 14), 
    legend.title = element_blank()  # 🔹 Supprimer le titre de la légende
  ) +
  theme(
    legend.position = c(0.95, 0.15),      # Position (x, y) dans le plot
    legend.justification = c("right", "top"), # Alignement par rapport à la boîte
    legend.background = element_rect(fill = "white", color = "gray80", size = 0.5),  # Fond lisible
    legend.text = element_text(size = 12),
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10))
  ) +
  scale_x_continuous(breaks = unique(cuttle_summary$k)) +
  scale_y_continuous(
    breaks = seq(0.80, 1, by = 0.05),
    expand = c(0, 0)
  ) +
  coord_cartesian(ylim = c(0.80, 1.01))




