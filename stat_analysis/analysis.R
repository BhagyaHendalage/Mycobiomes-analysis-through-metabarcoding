#to load the library
library(ape)
library(Biostrings)
library(biomformat)
library(phyloseq)
library(Hmisc)
library(yaml)
library(tidyr)
library(dplyr)
library(stats)
library(utils)
library(qiime2R)
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(vegan)
library(MicEco)
#import data
physeq<-qza_to_phyloseq(
  features="C:/Users/User/Desktop/a8/table.qza",
  tree="C:/Users/User/Desktop/a8/rooted-tree.qza",
  "C:/Users/User/Desktop/a8/taxonomy.qza",
  metadata = "C:/Users/User/Desktop/a8/sample-metadata.tsv"
)
physeq

# alpha diversity measures
plot_richness(physeq, x = "sample", color="plant.condition")+geom_point(size = 4)

# Beta diversity
#variance stabilize the data with a log transform, the perform PCoA using bray’s distances
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

#to get relative abundance
sample_variables(physeq)
colnames(tax_table(physeq)) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus","Species")

sort(phyloseq::sample_sums(physeq))
#Get count of phyla
table(phyloseq::tax_table(physeq)[, "Phylum"])
#Convert to relative abundance
ps_rel_abund = phyloseq::transform_sample_counts(physeq, function(x){x / sum(x)})
phyloseq::otu_table(physeq)
#relative abundance of taxa
phyloseq::otu_table(ps_rel_abund)
#plot
P=phyloseq::plot_bar(ps_rel_abund, fill = "Phylum", title = "(A) Relative Abundance Of Phyla In Different Samples") +
  geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack") +
  labs(x = "", y = "Relative Abundance\n") +
  facet_wrap(~ sample, scales = "free") +
  theme(panel.background = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

#Plot
C=phyloseq::plot_bar(ps_rel_abund, fill = "Class", title = "(B) Relative Abundance Of Classes In Different Samples") +
  geom_bar(aes(color = Class, fill = Class), stat = "identity", position = "stack") +
  labs(x = "", y = "Relative Abundance\n") +
  facet_wrap(~ sample, scales = "free") +
  theme(panel.background = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
grid.arrange(ncol=2,P,C)


# Subset dataset by phylum
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


#to get heatmap
plot_heatmap(physeq, "PCoA", distance="bray", sample.label="sample", 
             taxa.label="Genus", low="#FFFFCC", high="#000033", na.value="white",title = "Heatmap")

#to make venn diagram
sample_data(physeq)
ps_venn(
  physeq,
  group = "sample",
  fraction = 0,
  weight = FALSE,
  relative = TRUE,
  plot = TRUE
)
#to get unique taxa
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

#to bulid the tree
plot_tree(physeq, nodelabf=nodeplotboot(), ladderize="left", color="sample", shape="plant.condition",label.tips="taxa_names",size = "abundance",title = "Rooted Tree")
