# This script generates .gfa files with PGGB, Mini-graph Cactus and Cuttlefish
# from 2 sets of input genomes (as found in genbank or rotated)

### PGGB

# input : multifasta file (sequence ids in PanSN format recommended but not mandatory)
# here :  hdv_refseq_set_typeId.fa / hdv_ref_rotated_1GGTCGGACC.fa

# command : 

samtools faidx hdv_refseq_set_typeId.fa

singularity run docker://ghcr.io/pangenome/pggb:20250604232107f3aa15 pggb -i hdv_refseq_set_typeId.fa -o pggb_out_ref_s500 -n 22 -s 500 -p 70 -N


samtools faidx hdv_ref_rotated_1GGTCGGACC.fa

singularity run docker://ghcr.io/pangenome/pggb:20250604232107f3aa15 pggb -i hdv_ref_rotated_1GGTCGGACC.fa -o pggb_out_rot_s500 -n 22 -s 500 -p 70 -N


### MGCACTUS

# input : config file and seqFile (two-column mapping sample names to fasta paths)

# command :

singularity run docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.9 cactus-pangenome ./js seqFile_hdv_refseq_set_typeId.txt \
        --outDir mgcactus_out_ref \
        --outName "hdv_ref" \
        --reference REF_AJ000558 \
        --noSplit --permissiveContigFilter --gfa full \
        --configFile config_L50_mid0.5.xml

gunzip gunzip hdv_ref.full.gfa.gz

singularity run docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.9 cactus-pangenome ./js seqFile_hdv_1GGTCGGACC.txt \
        --outDir mgcactus_out_rot \
        --outName "hdv_rot" \
        --reference REF_AJ000558_1GGTCGGACC \
        --noSplit --permissiveContigFilter --gfa full \
        --configFile config_L50_mid0.5.xml

gunzip hdv_rot.full.gfa.gz

### CUTTLEFISH

# install en dur (mettre lien et version)

# input : multifasta file
# command :

./cuttlefish/build/src/cuttlefish build -s hdv_refseq_set_typeId.fa -k 13 -o cuttlefish_ref -f 1


./cuttlefish/build/src/cuttlefish build -s hdv_ref_rotated_1GGTCGGACC.fa -k 13 -o cuttlefish_rot -f 1


