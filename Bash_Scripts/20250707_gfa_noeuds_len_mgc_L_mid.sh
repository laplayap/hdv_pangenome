#!/bin/bash

# loop over gfa files from Mini-graph Cactus
# output : gfa_noeuds_lens.tsv file with individual node lengths
# E colums : filename / L parameter / min identity parameter / nodeId / node length

# boucle sur des fichiers gfa issus de Minigraph Cactus
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


# entête avec 4 colonnes : nom du fichier - valeur de L / mid - numero du noeud - longeur
echo -e "file\tL\tmid\tid_noeud\tlen_noeud" > gfa_noeuds_lens.tsv

# boucle sur les .gfa dans le repertoire courant
for file in *.gfa; do

L_val=$(echo "$file" | sed -n 's/^hdv_ref_L\([0-9]\+\)_mid[0-9.]\+\.gfa$/\1/p')
mid_val=$(echo "$file" | sed -n 's/^hdv_ref_L[0-9]\+_mid\([0-9.]\+\)\.gfa$/\1/p')


  # extraction valeurs de chaque ligne
  awk -v fname="$file" -v L="$L_val" -v mid="$mid_val" '$1 == "S" { print fname "\t" L "\t" mid "\t" $2 "\t" length($3) }' "$file" >> gfa_noeuds_lens.tsv
done


