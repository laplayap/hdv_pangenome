# Load required packages
library(tidyverse)
library(ggrepel)
library(gridExtra)

# lecture fichier .tsv + conversion parametres => facteurs + ajout d'une colonne pour le type de sequences utilisées pour la validation
pgge_outils <- read_tsv("eval_gfa_outils.tsv") 

pgge_outils <- pgge_outils %>%
  mutate(
    aln.id = as.numeric(aln.id),
    uniq = as.numeric(uniq),
    multi = as.numeric(multi),
    nonaln = as.numeric(nonaln),
    tool = factor(tool),
    seq = factor(seq)
  )

### box plot x=tool
ggplot(pgge_outils, aes(x = tool, y = aln.id, fill = seq, label = sample.name)) +
  geom_boxplot(position = position_dodge(0.9), width = 0.6, outlier.shape = NA) +
  geom_point(position = position_dodge(0.9), size = 1, alpha = 0.7) +
  geom_text_repel(position = position_dodge(0.9), box.padding = 0.1, max.overlaps = 2, size=2.5) +
  #    xlab("tool") +
  #    ylab("aln.id") +
  theme(text = element_text(size = 12)) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 90))

### violin plot x=tool
ggplot(pgge_outils, aes(x = tool, y = aln.id, fill = seq, label = sample.name)) +
  geom_violin(position = position_dodge(0.9), width = 0.6, outlier.shape = NA) +
  geom_point(position = position_dodge(0.9), size = 1, alpha = 0.7) +
  geom_text_repel(position = position_dodge(0.9), box.padding = 0.1, max.overlaps = 2, size=2.5) +
  #    xlab("tool") +
  #    ylab("aln.id") +
  theme(text = element_text(size = 12)) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 90))

### box plot x=seq
ggplot(pgge_outils, aes(x = seq, y = aln.id, fill = tool, label = sample.name)) +
  geom_boxplot(position = position_dodge(0.9), width = 0.6, outlier.shape = NA) +
  geom_point(position = position_dodge(0.9), size = 1, alpha = 0.7) +
  geom_text_repel(position = position_dodge(0.9), box.padding = 0.1, max.overlaps = 2, size=2.5) +
  #    xlab("tool") +
  #    ylab("aln.id") +
  theme(text = element_text(size = 12)) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 90))

############# Groupes par tool, seq
# Calcul aln.id moyenne pour chaque (tool,seq)

pgge_outils_summary <- pgge_outils %>%
  group_by(tool, seq) %>%
  summarise(mean_aln_id = mean(aln.id, na.rm = TRUE), .groups = "drop")

# plot lignes ref et seq par valeur de tool
ggplot(pgge_outils_summary, aes(x = tool, y = mean_aln_id, color = seq, group = seq)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = "Mean aln.id ",
    x = "tool ",
    y = "Mean aln.id",
    color = "Sequence"
  ) +
  theme(
    text = element_text(size = 14),
    strip.text = element_text(face = "bold"),
    panel.spacing = unit(1, "lines"),
    axis.text.x = element_text(angle = 45, hjust = 1,size = 8)
  )

# plot lignes par outil (1 point ref, 1 point val)
ggplot(pgge_outils_summary, aes(x = seq, y = mean_aln_id, color = tool, group = tool)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = "Mean aln.id ",
    x = "seq ",
    y = "Mean aln.id",
    color = "Outil"
  ) +
  theme(
    text = element_text(size = 14),
    strip.text = element_text(face = "bold"),
    panel.spacing = unit(1, "lines"),
  )

#########################################################

# Plot du nombre de noeuds et de la longeur totale à partir du gfa_stats.tsv

gfa_stats <- read_tsv("gfa_stats.tsv")

# Plot number of segments
ggplot(gfa_stats, aes(x = outil, y = n_segments)) +
  geom_point() +
  labs(title = "Number of Segments",
       x = "outil",
       y = "Number of Segments",
       )

ggplot(gfa_stats, aes(x = outil, y = total_segment_length)) +
  geom_point() +
  labs(title = "Number of Segments",
       x = "outil",
       y = "Number of Segments",
  )

# Plot total segment length vs L for each mid
ggplot(gfa_stats, aes(x = p, y = total_segment_length, color = factor(s), group = s)) +
  geom_line() + geom_point() +
  labs(title = "Total segment length per (p, s)",
       x = "p",
       y = "Number of Segments",
       color = "s")





