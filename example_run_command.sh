# Example script
nextflow run main.nf \
--samples "$PWD/tests/samples.csv" \
--star_indexdir "$PWD/tests/star_ref_index" \
--reference "$PWD/tests/chr22_transcripts.fa" \
--gtf "$PWD/tests/chr22_genes.gtf" \
--bed "$PWD/tests/chr22.genes.bed" 

