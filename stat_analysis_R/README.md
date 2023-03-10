# Statistical analysis of mycobiome data using R
All statistical analyses were based on the physeq object, and were performed using the Phyloseq package (McMurdie and Holmes, 2013) in R [version 4.2.0](https://cran.r-project.org/bin/windows/base/).

## Setup
Load libraries, setup paths, prepare environment
```
library(ape);packageVersion("ape")
```
[1] ‘5.6.2’
```
library(Biostrings);packageVersion("Biostrings")
```
[1] ‘2.64.0’
```
library(biomformat);packageVersion("biomformat")
```
[1] ‘1.24.0’
```
library(phyloseq);packageVersion("phyloseq")
```
[1] ‘1.40.0’
```
library(Hmisc);packageVersion("Hmisc")
```
[1] ‘4.7.0’
```
library(yaml);packageVersion("yaml")
```
[1] ‘2.3.5’
```
library(tidyr);packageVersion("tidyr")
```
[1] ‘1.2.0’
```
library(dplyr);packageVersion("dplyr")
```
[1] ‘1.0.9’
```
library(stats);packageVersion("stats")
```
[1] ‘4.2.0’
```
library(utils);packageVersion("utils")
```
[1] ‘4.2.0’
```
library(qiime2R);packageVersion("qiime2R")
```
[1] ‘0.99.6’
```
library(tidyverse);packageVersion("tidyverse")
```
[1] ‘1.3.1’
```
library(ggplot2);packageVersion("ggplot2")
```
[1] ‘3.3.6’
```
library(gridExtra);packageVersion("gridExtra")
```
[1] ‘2.3’
```
library(vegan); packageVersion("vegan") 
```
[1] ‘2.6.2’
```
library("MicEco");packageVersion("MicEco")
```
[1] ‘0.9.17’


### import data

Physeq object was created in R by importing table.qza, sample-metadata.txt, rooted-tree.qza and taxonomy.qza and using qza_to_phyloseq function in [qiime2R package](https://github.com/jbisanz/qiime2R) .
```
physeq<-qza_to_phyloseq(
  features="C:/Users/User/Desktop/a8/table.qza",
  tree="C:/Users/User/Desktop/a8/rooted-tree.qza",
  "C:/Users/User/Desktop/a8/taxonomy.qza",
  metadata = "C:/Users/User/Desktop/a8/sample-metadata.tsv"
)
physeq
```
### Alpha diversity measures

All alpha diversity estimation measures (observed species count, Chao 1, Simpson index, Shannon's diversity index, ACE, InvSimpson index and Fisher) were calculated and visualized using the Phyloseq plot_richness function on different samples.
```
plot_richness(physeq, x = "sample", color="plant.condition")+geom_point(size = 4)
```
### Beta diversity measures

For assessing beta diversity, a Principal coordinate analysis (PCoA) was conducted by calculating bray distances between samples and ordination plots were generated using Phyloseq distance and ordinate functions. NMDS was conducted by calculating bray distances between samples and ordination plots were generated using Phyloseq distance and ordinate function. The ASV read counts for all the samples were aggregated using the Phyloseq taxa_sums function to calculate the total read count for each ASV across samples and were normalised by transforming into relative abundances using the Phyloseq transform_sample_counts function.

Beta diversity

variance stabilize the data with a log transform, the perform PCoA using bray’s distances
```
logt  = transform_sample_counts(physeq, function(x) log(1 + x) )
out.pcoa.logt <- ordinate(logt, method = "PCoA", distance = "bray")
evals <- out.pcoa.logt$values$Eigenvalues
plot_ordination(logt, out.pcoa.logt, type = "sample", 
                color = "plant.condition", shape = "plant.site",title = "PCoA Plot Using Bray-Curtis Distance Matrix") + labs(col = "sample") +
  geom_point(size = 5)+
  coord_fixed(sqrt(evals[2] / evals[1]))
physeq.hell <- physeq
otu_table(physeq.hell) <-otu_table(decostand(otu_table(physeq.hell), method = "hellinger"), taxa_are_rows=TRUE)
v4.hell.ord <- ordinate(physeq.hell, "NMDS", "bray")
plot_ordination(physeq.hell, v4.hell.ord, type="sample", color="plant.condition",shape = "plant.site", title="NMDS Plot Using Bray-Curtis Distances")+geom_point(size = 5)
```

to get relative abundance
```
sample_variables(physeq)
colnames(tax_table(physeq)) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus","Species")

sort(phyloseq::sample_sums(physeq))
```
Get count of phyla
```
table(phyloseq::tax_table(physeq)[, "Phylum"])
#Convert to relative abundance
ps_rel_abund = phyloseq::transform_sample_counts(physeq, function(x){x / sum(x)})
phyloseq::otu_table(physeq)
```
relative abundance of taxa
```
phyloseq::otu_table(ps_rel_abund)
```
plot
```
P=phyloseq::plot_bar(ps_rel_abund, fill = "Phylum", title = "(A) Relative Abundance Of Phyla In Different Samples") +
  geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack") +
  labs(x = "", y = "Relative Abundance\n") +
  facet_wrap(~ sample, scales = "free") +
  theme(panel.background = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
```

Plot
```
C=phyloseq::plot_bar(ps_rel_abund, fill = "Class", title = "(B) Relative Abundance Of Classes In Different Samples") +
  geom_bar(aes(color = Class, fill = Class), stat = "identity", position = "stack") +
  labs(x = "", y = "Relative Abundance\n") +
  facet_wrap(~ sample, scales = "free") +
  theme(panel.background = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
grid.arrange(ncol=2,P,C)
```


Then, the data set was filtered using the Phyloseq subset_taxa function to keep only three different phyla (Ascomycota, Basidiomycota, Mucoromycota) to study abundance and distribution with filled with families across samples. 

Subset dataset by phylum
```
physeq_asco = subset_taxa(physeq, Phylum=="Ascomycota")
physeq_basi = subset_taxa(physeq, Phylum=="Basidiomycota")
physeq_muco = subset_taxa(physeq, Phylum=="Mucoromycota")
#Convert to relative abundance
ps_rel_abund_asco = phyloseq::transform_sample_counts(physeq_asco, function(x){x / sum(x)})
ps_rel_abund_basi = phyloseq::transform_sample_counts(physeq_basi, function(x){x / sum(x)})
ps_rel_abund_muco = phyloseq::transform_sample_counts(physeq_muco, function(x){x / sum(x)})
ps_rel_abund_asco
phyloseq::otu_table(ps_rel_abund_asco)
title = "(A) Bar Plot Ascomycota Phylum With Associated Species"
A=plot_bar(ps_rel_abund_asco, "sample", "Abundance", "Species", title=title)
title = "(B) Bar Plot Basidiomycota Phylum With Associated Species"
B=plot_bar(ps_rel_abund_basi, "sample", "Abundance", "Species", title=title)
title = "(C) Bar Plot Mucoromycota Phylum With Associated Species"
C=plot_bar(ps_rel_abund_muco, "sample", "Abundance", "Species", title=title)
grid.arrange(ncol=3,A,B,C)
```

Then, heatmap was constructed PCoA method with bray distance. 

to get heatmap

```
plot_heatmap(physeq, "PCoA", distance="bray", sample.label="sample", 
             taxa.label="Genus", low="#FFFFCC", high="#000033", na.value="white",title = "Heatmap")
```

Furthermore, ASV read count distributions were compared between samples to study microbial composition changes. Venn diagram was created using ps_venn function in MicEco package.
to make venn diagram
```
sample_data(physeq)
ps_venn(
  physeq,
  group = "sample",
  fraction = 0,
  weight = FALSE,
  relative = TRUE,
  plot = TRUE
)
```
 Using ps_venn function in MicEco package, unique taxa for each sample was found and listed.
to get unique taxa
```
list_uniqe=ps_venn(
  physeq,
  group = "sample",
  fraction = 0,
  weight = FALSE,
  relative = TRUE,
  plot = FALSE
)
head(list_uniqe)
cat(capture.output(print(list_uniqe), file="test.txt"))
```

 Then, using Phyloseq plot_tree function the phylogenetic tree was created with representation of size in abundance, representation of color in different samples and representation of shape in plant condition.
to bulid the tree
```
plot_tree(physeq, nodelabf=nodeplotboot(), ladderize="left", color="sample", shape="plant.condition",label.tips="taxa_names",size = "abundance",title = "Rooted Tree")
```

