#!/bin/bash

# This script takes a multiple alignement (gapped multifasta file)
# rotates the sequences so the position cut_pos in the multiple alignement becomes position 1
# generates output multifasta with rotated ungapped sequences

input="hdv_ref_multalin_gappedmsa.fa"
output="hdv_ref_rotated_1GGTCGGACC.fa"
cut_pos=920

tmp_rotated="rotated_gapped_tmp.fasta"
tmp_ungapped="rotated_ungapped_tmp.fasta"

# Convert to one-line FASTA (preserving gaps), then rotate at position 920
seqkit seq -w 0 "$input" |
awk -v cut="$cut_pos" '
    BEGIN { OFS="\n" }
    /^>/ { header=$0; next }
    {
        seq=$0
        left=substr(seq, 1, cut)
        right=substr(seq, cut + 1)
        rotated=right left
        print header, rotated
    }
' > "$tmp_rotated"

# Remove gaps and wrap to 80 characters per line
awk '
    /^>/ {print; next}
    {
        gsub("-", "", $0)
        seq = $0
        while (length(seq) > 0) {
            print substr(seq, 1, 80)
            seq = substr(seq, 81)
        }
    }
' "$tmp_rotated" > "$output"

# Clean up
rm "$tmp_rotated"

