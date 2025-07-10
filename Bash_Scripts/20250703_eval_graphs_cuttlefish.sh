#!/bin/bash

# stage M1 Laura Playa Pariente mai-juillet 2025
# évaluation graphes de pangenome construits avec Cuttlefish
# avec l'outil pgge (calcul de metriques d'alignement de sequences sur pangenome)

# usage : ./202500703_eval_graphs_cuttlefish.sh <fichier_fasta_ref> <fichier_fasta_val>

# <fichier_fasta_ref> et <fichier_fasta_ref> contienent les séquences que pgge aligne contre le graph

# output : 2 tsv files 
# gfa_stats.tsv (nombre de noeuds / longeur totale des noeuds)
# eval_cuttlefish_k.tsv
# 	- en lignes chaque séquence alignée sur le graph
# 	- en colonnes : les metriques pgge, valeur de k et type de séquence (ref ou val) 

# Check input file is given
if [ -z "$1" ]; then
  echo "Usage: $0 <input_fasta_file>"
  exit 1
fi

input_file_ref="$1"
input_file_val="$2"

# préparation du fichier avec nombre de noeuds / longeur totale des noeuds
echo -e "filename\tk\tn_segments\ttotal_segment_length" > gfa_stats.tsv

# construction des graphes pour valeurs de k entre 1 et 45 (valeur par default dans l'outil 27)

for k in $(seq 1 2 45); do 

    # construction du graphe	
    # ./cuttlefish/build/src/cuttlefish build -s hdv_refseq_set_typeId.fa -k $k -o cuttlefish_k$k -f 1
    # mv cuttlefish_k$k.gfa1 cuttlefish_k$k.gfa
	
    # calcul de statistiques avec gfatools - extraction du nombre de noeuds et longeur totale	
    stats=$(./gfatools/gfatools stat "cuttlefish_k${k}.gfa1")

    # Extract number of segments and total segment length
    n_segments=$(echo "$stats" | grep "Number of segments" | awk '{print $4}')
    total_length=$(echo "$stats" | grep "Total segment length" | awk '{print $4}')

    # Output one row per file
    echo -e "cuttlefish_k${k}.gfa1\t$k\t$n_segments\t$total_length" >> gfa_stats.tsv	
	
    # run pgge avec séquences de référence
      echo "Running PGGE avec séquences de référence..."
      singularity exec docker://ghcr.io/pangenome/pgge:latest \
        bash -c "pgge -g cuttlefish_k${k}.gfa -f '$input_file_ref' -r beehave.R -o eval_cuttlefish_k${k}_seqref"
        
    # Ajout de colonnes avec k et tag "ref" sur le .tsv en sortie de pgge    
      awk -v k="$k" 'BEGIN{OFS="\t"} NR==1 {print $0, "k", "seq"; next} 
         {print $0, k, "ref"}' \
  eval_cuttlefish_k${k}_seqref/*.tsv > cuttlefish_k${k}_ref.tsv         
	
    # run pgge avec séquences de validation
      echo "Running PGGE avec séquences de validation..."
      singularity exec docker://ghcr.io/pangenome/pgge:latest \
        bash -c "pgge -g cuttlefish_k${k}.gfa -f '$input_file_val' -r beehave.R -o eval_cuttlefish_k${k}_seqval"

    # Ajout de colonnes avec k et tag "val" sur le .tsv en sortie de pgge    
      awk -v k="$k" 'BEGIN{OFS="\t"} NR==1 {print $0, "k", "seq"; next} 
         {print $0, k, "val"}' \
  eval_cuttlefish_k${k}_seqval/*.tsv > cuttlefish_k${k}_val.tsv 

done

# concatenation de tous les .tsv
head -n 1 -q cuttlefish_k*.tsv | head -n 1 > eval_cuttlefish_k.tsv
tail -n +2 -q cuttlefish_k*.tsv >> eval_cuttlefish_k.tsv









