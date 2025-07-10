#!/bin/bash

# loop over gfa files from Cuttlefish (all in same folder)
# output : fichier gfa_noeuds_lens.tsv with individual node lengths
# 4 colums : filename / Cuttlefish k value / nodeId / node length

# extraction et compilation les longeurs des noeuds dans un fichier gfa_noeuds_lens.tsv
# Exemple de fichier gfa : 
#...
#S	26	GAG
#S	27	CCCGAGAGGGGATGTCACGGTAAAGAGCATTGGAACGTCGGAGA
#S	28	AACT
#S	29	ACTCCCAAGAAG
#S	30	AG
#S	31	G
#S	32	C
#S	33	A


# entête avec 4 colonnes : nom du fichier - valeur de k - numero du noeud - longeur
echo -e "file\tk\tid_noeud\tlen_noeud" > gfa_noeuds_lens.tsv

# boucle sur les .gfa dans le repertoire courant
for file in *.gfa; do

  k_val=$(echo "$file" | sed -E 's/^cuttlefish_k([0-9]+)\.gfa$/\1/')

  # extraction valeurs de chaque ligne
  awk -v fname="$file" -v k="$k_val" '$1 == "S" { print fname "\t" k "\t" $2 "\t" length($3) }' "$file" >> gfa_noeuds_lens.tsv
done





