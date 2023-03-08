# Mycobiomes analysis through metabarcoding

Investigating the mycobiomes of onion under biotic stress through metabarcoding


## Abstract

Welsh onion (Allium fistulosum L.) constitutes an important plant species cultivated in Taiwan due the benefits and applications in different areas. Stemphylium vesicarium causes a fungal disease called Stemphylium leaf blight disease (SLB) or stalk rot in Welsh onions. This project constitutes a preliminary metabarcoding based mycobiota study conducted to decipher any difference in the endophytic fungal communities associated with healthy and diseased SLB Welsh onion plants. Metabarcoding sequences for the study were provided by the National Taiwan University, Taiwan. We used high-throughput sequencing analysis to determine the diversity and abundances of microbes associated roots and leaves in Welsh onion under disease and healthy conditions. Sequence data of four samples; 
- leaves (HL) and roots (HR) of healthy onion plants
-  leaves (DL) and roots (DR) of diseased (suffering from (Stemphylium leaf blight disease) onion plants 

were received for the preliminary investigation The sequence data was analyzed using the 
- QIIME 2 (Quantitative insights Into Microbial Ecology) pipeline
 
- R language 


with modifications as necessary. 

An amplicon sequence variant (ASV), high-throughput analysis of maker genes always referred sequences as ASVs, which are created following erroneous sequence removal. ASVs use to classifying groups of species based on DNA sequences.The analysis revealed a total of 153 of ASVs at 97% similarity and a total of 50 sequence reads identified with taxonomic annotations from the four samples (DL, DR, HL and HR). In terms of diversity, there was no significant statistical difference in p-value (>0.05) between plant conditions (healthy and diseases) or plant part (leaves and root) for both alpha and beta diversity.According to the results of taxonomy analysis, Among the 50 different taxa, there were three phyla.

## Dataset description

Sequence data of four Welsh onion plant samples were provided by the National Taiwan University for the study. The four samples included 
- disease leaves (DL)
- disease roots (DR)
- healthy roots (HR)
- healthy leaves (HL) of Welsh onion plants. 

The disease is Stemphylium leaf blight disease of Welsh onion. Paired end, demultiplexed data (four samples are separated using unique barcodes) of four samples as DL, DR, HR, and HL in fastq.gz format with metadata file in tab separated text format (.tsv) was provided.

On 26th of October 2021 Welsh onion samples were collected from one field located in Saxing, Taiwan.Paired-end libraries (2 × 300 bp) were prepared using ITS domain I of fungal rRNA and sequenced using High Sec2500 Illumina platform (Illumina, San Diego, CA, USA). Fungal barcoded amplicon DNA sample were sent to Tri-I Biotech (New Taipei City, Taiwan)

There are several steps as,

1. Installing QIIME 2
2. Data preprocessing
3. Taxonomy assignment and taxonomy analysis
4. Phylogenetic tree building
5. Diversity analysis
6. Statistical analysis

### subtitle

fxfxf
- htyh


1. ujyu

```
fdfdgfdd
```

## Mycobiome analysis

ase [link](qiime2/README.md)


## Statistical analysis of mycobiome data

ase [link](analysis/README.md)