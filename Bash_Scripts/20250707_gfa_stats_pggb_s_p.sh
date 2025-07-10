#!/bin/bash

# loop over .gfa files generated with pggb for differents -s -p parameters values
# output : 2 tsv files
# 	   gfa_stats.tsv : node number / total node length
# 	   gfa_noeuds_lens.tsv : individual node lengths


# Préparation des entêtes des fichiers

# nombre de noeuds et longeur totale (gfa_stats.tsv)
echo -e "filename\ts\tp\tn_segments\ttotal_segment_length" > gfa_stats.tsv

# longeurs de chacun des noeuds (gfa_noeuds_lens.tsv)
echo -e "file\ts\tp\tid_noeud\tlen_noeud" > gfa_noeuds_lens.tsv

# Boucle sur tous les fichiers gfa
for file in pggb_s*_p*.gfa; do
    # Extract s and p values from filename
    s=$(echo "$file" | sed -n 's/^pggb_s\([0-9]*\)_p[0-9]*\.gfa$/\1/p')
    p=$(echo "$file" | sed -n 's/^pggb_s[0-9]*_p\([0-9]*\)\.gfa$/\1/p')

    # gfatools
    stats=$(./gfatools/gfatools stat "$file")

    # nombre de noeuds et longeur totale
    n_segments=$(echo "$stats" | grep "Number of segments" | awk '{print $4}')
    total_length=$(echo "$stats" | grep "Total segment length" | awk '{print $4}')

    # ecriture sortie gfa_stats.tsv
    echo -e "$file\t$s\t$p\t$n_segments\t$total_length" >> gfa_stats.tsv
    
    # ecriture sortie gfa_noeuds_lens.tsv
    awk -v fname="$file" -v s="$s" -v p="$p" '$1 == "S" { print fname "\t" s "\t" p "\t" $2 "\t" length($3) }' "$file" >> gfa_noeuds_lens.tsv
      
done



