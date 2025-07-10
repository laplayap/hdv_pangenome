#!/bin/bash

# Builds pangenome graphs with minigraph cactus
# output : .gfa files for different values of L and MinId parameters


TEMPLATE="cactus_config_template_L_id.xml"
IMG="docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.9"

for L in 2 4 8 12 16 20 30 40 50; do
  for mid in 0.3 0.4 0.5 0.6 0.7 0.8; do

      CONFIG="config_L${L}_mid${mid}.xml"
      sed "s|\${VARLEN}|$L|g; s|\${MINID}|$mid|g" $TEMPLATE > $CONFIG
      
      singularity run $IMG cactus-pangenome ./js_L${L}_mid${mid} seqFile_hdv.txt \
        --outDir mgcactus_out_L${L}_mid${mid} \
        --outName "hdv_ref" \
        --reference AJ000558 \
        --noSplit --permissiveContigFilter --gfa full \
        --configFile "$CONFIG"

      # Extraction/copie/renomage du .gfa.gz
      GFA_GZ="mgcactus_out_L${L}_mid${mid}/hdv_ref.full.gfa.gz"
      DEST_GFA="./hdv_ref_L${L}_mid${mid}.gfa"

      if [[ -f "$GFA_GZ" ]]; then
          gunzip -c "$GFA_GZ" > "$DEST_GFA"
          echo "Saved: $DEST_GFA"
                    
      else
          echo "Warning: $GFA_GZ not found!"
      fi

  done
done


