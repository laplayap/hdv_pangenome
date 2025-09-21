library(ggplot2)
library(readr)
library(dplyr)

# Plot du nombre de noeuds et de la longeur totale à partir du gfa_stats.tsv
# pour *** PGGB ***

# Load data
gfa_stats <- read_tsv("gfa_stats.tsv")

############ Paramètres s et p
# Plot number of segments vs p for each s
ggplot(gfa_stats, aes(x = p, y = n_segments, color = factor(s), group = s)) +
  geom_line() + geom_point() +
  labs(title = "Number of Segments per (p, s)",
       x = "p",
       y = "Number of Segments",
       color = "s")

# Plot total segment length vs L for each mid
ggplot(gfa_stats, aes(x = p, y = total_segment_length, color = factor(s), group = s)) +
  geom_line() + geom_point() +
  labs(title = "Total segment length per (p, s)",
       x = "p",
       y = "Number of Segments",
       color = "s")

# filtre par s
ggplot(gfa_stats %>% filter(s == 420), aes(x = p, y = total_segment_length, color = factor(s), group = s)) +
  geom_line() + geom_point() +
  labs(title = "Total segment length per (p, s)",
       x = "p",
       y = "Number of Segments",
       color = "s")
