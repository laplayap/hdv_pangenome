#!/usr/bin/env Rscript

require(tidyverse)
require(ggrepel)
require(gridExtra)

input.pgge <- read.table("250721_compil_all.csv", sep = ';', header = T)
output.png <- "image_beehave.png"

aln.id <- ggplot(input.pgge, aes(x = as.factor(outil), y = aln.id, label = sample.name, fill = outil)) +
  geom_violin() +
  geom_point(aes(color = seq)) +
  geom_text_repel(aes(label = sample.name, color = seq),box.padding = 0.1, max.overlaps = 5, size = 2) +
  xlab("aln.id") +
  theme(
    text = element_text(size = 16),
    legend.position = "none"
    ) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 0)) +
  scale_color_manual(values = c("ref" = "black", "val" = "blue3"))


qsc <- ggplot(input.pgge, aes(x = as.factor(outil), y = qsc, label = sample.name, fill = outil)) +
  geom_violin() +
  geom_point(aes(color = seq)) +
  geom_text_repel(box.padding = 0.1, max.overlaps = 5, size = 2) +
  xlab("qsc") +
  theme(text = element_text(size = 16), legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 0)) +
  scale_color_manual(values = c("ref" = "black", "val" = "blue3"))

uniq <- ggplot(input.pgge, aes(x = as.factor(outil), y = uniq, label = sample.name, fill = outil)) +
  geom_violin() +
  geom_point(aes(color = seq)) +
  geom_text_repel(box.padding = 0.1, max.overlaps = 5, size = 2) +
  xlab("uniq") +
  theme(text = element_text(size = 16), legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 0)) +
  scale_color_manual(values = c("ref" = "black", "val" = "blue3"))

multi <- ggplot(input.pgge, aes(x = as.factor(outil), y = multi, label = sample.name, fill = outil)) +
  geom_violin() +
  geom_point(aes(color = seq)) +
  geom_text_repel(box.padding = 0.1, max.overlaps = 5, size = 2) +
  xlab("multi") +
  theme(text = element_text(size = 16), legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  scale_x_discrete(guide = guide_axis(angle = 0)) +
  scale_color_manual(values = c("ref" = "black", "val" = "blue3"))

nonaln <- ggplot(input.pgge, aes(x = as.factor(outil), y = nonaln, label = sample.name, fill = outil)) +
  geom_violin() +
  geom_point(aes(color = seq)) +
  geom_text_repel(box.padding = 0.1, max.overlaps = 5, size = 2) +
  xlab("nonaln") +
  theme(text = element_text(size = 16),legend.position = "none") +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001))+
  scale_x_discrete(guide = guide_axis(angle = 0)) +
  scale_color_manual(values = c("ref" = "black", "val" = "blue3"))

#png(output.png, width = 2000, height = 500, pointsize = 25)
g <- grid.arrange(aln.id, qsc, uniq, multi, nonaln, nrow = 2, ncol = 3)
#dev.off()
