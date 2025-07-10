#!/bin/bash

# évaluation graphes de pangenome construits avec Minigraph Cactus
# loops over .gfa files generated with mini-graph cactus for different L and minId parameters values

# usage : ./202500703_eval_graphs_mgcactus.sh <fichier_fasta_ref> <fichier_fasta_val>

# <fichier_fasta_ref> et <fichier_fasta_ref> contienent les séquences que pgge aligne contre le graph

# output : 2 tsv files
# gfa_stats.tsv avec nombre de noeuds et longeur totale des noeuds
# eval_mgcactus_Lmid.tsv
# 	- en lignes chaque séquence alignée sur le graph
# 	- en colonnes : les metriques pgge, valeurs L et minId et type de séquence (ref ou val) 

# Check input file is given
if [ -z "$1" ]; then
  echo "Usage: $0 <input_fasta_file>"
  exit 1
fi

input_file_ref="$1"
input_file_val="$2"

# préparation entête fichier gfa_stats.tsv
echo -e "filename\tL\tmid\tn_segments\ttotal_segment_length" > gfa_stats.tsv

for L in 2 4 8 12 16 20 30 40 50; do
  for mid in 0.3 0.4 0.5 0.6 0.7 0.8; do
  
  # calcul de statistiques avec gfatools - extraction du nombre de noeuds et longeur totale	
    stats=$(./gfatools/gfatools stat "hdv_ref_L${L}_mid${mid}.gfa")

    n_segments=$(echo "$stats" | grep "Number of segments" | awk '{print $4}')
    total_length=$(echo "$stats" | grep "Total segment length" | awk '{print $4}')

    # Ajout d'une ligne au fichiert gfa_stats.tsv
    echo -e "hdv_ref_L${L}_mid${mid}.gfa\t$L\t$mid\t$n_segments\t$total_length" >> gfa_stats.tsv

# run pgge avec séquences de référence
      echo "Running PGGE avec séquences de référence..."
      singularity exec docker://ghcr.io/pangenome/pgge:20210412155923c4f8f1 \
        bash -c "pgge -g hdv_ref_L${L}_mid${mid}.gfa -f '$input_file_ref' -r beehave.R -o eval_mgcactus_L${L}_mid${mid}_seqref"

  # Ajout de colonnes avec paramètres et type de séquence   
      awk -v L="$L" -v mid="$mid" 'BEGIN{OFS="\t"} NR==1 {print $0, "L", "mid", "seq"; next} {print $0, L, mid, "ref"}' \
  eval_mgcactus_L${L}_mid${mid}_seqref/*.tsv > mgcactus_L${L}_mid${mid}_ref.tsv
  
# run pgge avec séquences de validation
      echo "Running PGGE avec séquences de validation..."
      singularity exec docker://ghcr.io/pangenome/pgge:20210412155923c4f8f1 \
        bash -c "pgge -g hdv_ref_L${L}_mid${mid}.gfa -f '$input_file_val' -r beehave.R -o eval_mgcactus_L${L}_mid${mid}_seqval"

  # Ajout de colonnes avec paramètres et type de séquence   
      awk -v L="$L" -v mid="$mid" 'BEGIN{OFS="\t"} NR==1 {print $0, "L", "mid", "seq"; next} {print $0, L, mid, "val"}' \
  eval_mgcactus_L${L}_mid${mid}_seqval/*.tsv > mgcactus_L${L}_mid${mid}_val.tsv

  done
done

# concatenation .tsv
head -n 1 -q mgcactus*.tsv | head -n 1 > eval_mgcactus_Lmid.tsv
tail -n +2 -q mgcactus*.tsv >> eval_mgcactus_Lmid.tsv


