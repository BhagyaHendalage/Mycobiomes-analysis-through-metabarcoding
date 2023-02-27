### Importing dataset

```
unzip -q data.zip
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path pe-33-manifest \
  --output-path paired-end-demux.qza \
  --input-format PairedEndFastqManifestPhred33V2
 ```

### Summary of demultiplexed results

```
qiime demux summarize \
  --i-data paired-end-demux.qza \
  --o-visualization paired-end-demux.qzv
```


Remove the adapters in demultiplexed paired-end sequences
qiime cutadapt trim-paired \
  --i-demultiplexed-sequences paired-end-demux.qza \
  --p-adapter-f GCATCGATGAAGAACGCAGC \
  --p-front-f GGAAGTAAAAGTCGTAACAAGG \
  --p-adapter-r CCTTGTTACGACTTTTACTTCC \
  --p-front-r GCTGCGTTCTTCATCGATGC \
  --o-trimmed-sequences demux-trimmed.qza

Summary of trimmed results
qiime demux summarize \
 --i-data demux-trimmed.qza \
 --o-visualization demux-trimmed.qzv

Denoising and feature table construction
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux-trimmed.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 222 \
  --p-trunc-len-r 224 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza

Feature table and feature data summarizing
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv


Classifier training
qiime tools import \
 --type FeatureData[Sequence] \
 --input-path developer/sh_refs_qiime_ver7_99_01.12.2017_dev_uppercase.fasta \
 --output-path unite-ver7-99-seqs-01.12.2017.qza

qiime tools import \
 --type FeatureData[Taxonomy] \
 --input-path developer/sh_taxonomy_qiime_ver7_99_01.12.2017_dev.txt \
 --output-path unite-ver7-99-tax-01.12.2017.qza \
 --input-format HeaderlessTSVTaxonomyFormat

qiime feature-classifier fit-classifier-naive-bayes \
 --i-reference-reads unite-ver7-99-seqs-01.12.2017.qza \
 --i-reference-taxonomy unite-ver7-99-tax-01.12.2017.qza \
 --o-classifier unite-ver7-99-classifier-01.12.2017.qza

Assign taxonomy
qiime feature-classifier classify-sklearn \
  --i-classifier unite-ver7-99-classifier-01.12.2017.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

Visualization of taxonomy
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

Phylogenetic tree building
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

Diversity analysis
Alpha diversity
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1395 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/shannon_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/shannon-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/observed_features_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/observed_features-group-significance.qzv

Beta diversity
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-site \
  --o-visualization core-metrics-results/unweighted-unifrac-plant-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-condition \
  --o-visualization core-metrics-results/unweighted-unifrac-plant-condition-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-site \
  --o-visualization core-metrics-results/bray_curtis-plant-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-condition \
  --o-visualization core-metrics-results/bray_curtis-plant-condition-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-site \
  --o-visualization core-metrics-results/jaccard-plant-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/jaccard_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-condition \
  --o-visualization core-metrics-results/jaccard-plant-condition-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-site \
  --o-visualization core-metrics-results/weighted_unifrac-plant-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column plant-condition \
  --o-visualization core-metrics-results/weighted_unifrac-plant-condition-significance.qzv \
  --p-pairwise
