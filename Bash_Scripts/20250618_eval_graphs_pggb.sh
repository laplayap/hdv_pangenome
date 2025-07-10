#!/bin/bash

# stage M1 Laura Playa Pariente mai-juillet 2025
# évaluation graphes de pangenome construits avec Pangenome Graph Builder (pggb)

# usage : ./20250618_eval_graphs_pggb.sh <fichier_fasta_ref> <fichier_fasta_val>

# <fichier_fasta_ref> et <fichier_fasta_ref> contienent les séquences que pgge aligne contre le graph

# output : .tsv file eval_pgge_results_sp_full.tsv with pgge alignment metrics

# Check input file is given
if [ -z "$1" ]; then
  echo "Usage: $0 <input_fasta_file>"
  exit 1
fi

input_file_ref="$1"
input_file_val="$2"

# contruction de l'index (prerequis PGGB)
samtools faidx "$input_file_ref"

# PARAMETRES s ET p
# usage de la commande seq
#seq [OPTION]... LAST
#seq [OPTION]... FIRST LAST
#seq [OPTION]... FIRST INCREMENT LAST

# sensibilité aux paramètres s et p

#for s in $(seq 100 100 2000); do
#  for p in $(seq 65 5 95); do

for s in $(seq 220 40 460); do
  for p in $(seq 64 2 82); do

      # run pggb
      echo "Running PGGB for s=$s, p=$p..."
      singularity run docker://ghcr.io/pangenome/pggb:20250604232107f3aa15 \
        pggb -i "$input_file_ref" -o pggb_out_s${s}_p${p} \
        -n 22 -s${s} -p${p} -k0 -N -G 900 1800 -m

      # copie/renomage du fichier .gfa 
      echo "Copying .gfa file..."
      cp ./pggb_out_s${s}_p${p}/*.gfa pggb_s${s}_p${p}.gfa

      # run pgge avec séquences de référence
      echo "Running PGGE evaluation - séquences de référence..."
      singularity exec docker://ghcr.io/pangenome/pgge:20210412155923c4f8f1 \
        bash -c "pgge -g pggb_s${s}_p${p}.gfa -f '$input_file_ref' -r beehave.R -o eval_pggb_s${s}_p${p}"

      # Ajout de colonnes avec les paramètres utilisés dans le .tsv en sortie de pgge    
      awk -v s="$s" -v p="$p" 'BEGIN{OFS="\t"} NR==1 {print $0, "s", "p", "seq" ; next} {print $0, s, p, "ref"}' \
  eval_pggb_s${s}_p${p}/*.tsv > pgge_s${s}_p${p}.tsv

      # run pgge avec séquences de validation (Attention, nom du fichier avec nvlles séquences en dur)
      echo "Running PGGE evaluation - séquences de validation ..."
      singularity exec docker://ghcr.io/pangenome/pgge:20210412155923c4f8f1 \
        bash -c "pgge -g pggb_s${s}_p${p}.gfa -f '$input_file_val' -r beehave.R -o eval_pggb_s${s}_p${p}_seqval"

      # Ajout de colonnes avec les paramètres utilisés dans le .tsv en sortie de pgge    
      awk -v s="$s" -v p="$p" 'BEGIN{OFS="\t"} NR==1 {print $0, "s", "p", "seq"; next} {print $0, s, p, "val"}' \
  eval_pggb_s${s}_p${p}_seqval/*.tsv > pgge_s${s}_p${p}_val.tsv

      echo "Done for s=$s, p=$p"
      echo "--------------------------------------------"

  done
done

# concatenation de tous les .tsv
head -n 1 -q pgge_s*_p*.tsv | head -n 1 > eval_pgge_results_sp_full.tsv
tail -n +2 -q pgge_s*_p*.tsv >> eval_pgge_results_sp_full.tsv

'''
##############################################################

# PARAMETRE l

# l (=s, =2*s, default)
# s = 100 500 1000
# p = 65 80

for s in 100 500 1000; do
  for p in 65 80; do
    for l in $s $((2 * s)) $((5 * s)); do

# run pggb
      echo "Running PGGB for s=$s, l=$l, p=$p..."
      singularity run docker://ghcr.io/pangenome/pggb:20250604232107f3aa15 \
        pggb -i "$input_file" -o pggb_out_s${s}_l${l}_p${p} \
        -n 22 -s${s} -l${l} -p${p} -k0 -N -G 900 1800 -m

# copie/renomage du fichier .gfa 
      echo "Copying .gfa file..."
      cp ./pggb_out_s${s}_l${l}_p${p}/*.gfa pggb_s${s}_l${l}_p${p}.gfa

# run pgge
      echo "Running PGGE evaluation..."
      singularity exec docker://ghcr.io/pangenome/pgge:20210412155923c4f8f1 \
        bash -c "pgge -g pggb_s${s}_l${l}_p${p}.gfa -f '$input_file' -r beehave.R -l 1000 -s 1000 -o eval_pggb_s${s}_l${l}_p${p}"

# Ajout de colonnes avec les paramètres utilisés dans le .tsv en sortie de pgge    
      awk -v s="$s" -v l="$l" -v p="$p" 'BEGIN{OFS="\t"} NR==1 {print $0, "s", "l", "p"; next} {print $0, s, l, p}' \
  eval_pggb_s${s}_l${l}_p${p}/*.tsv > pgge_s${s}_l${l}_p${p}.tsv
    
      echo "Done for s=$s, l=$l, p=$p"
      echo "--------------------------------------------"

    done
  done
done

# concatenation de tous les .tsv
head -n 1 -q pgge_s*_l*_p*.tsv | head -n 1 > eval_pgge_results.tsv
tail -n +2 -q pgge_s*_l*_p*.tsv >> eval_pgge_results.tsv

'''







