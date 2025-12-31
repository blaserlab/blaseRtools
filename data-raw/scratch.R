devtools::load_all()
bb_make_ape_genomic("CXCL1", genome = "hg38")
vignette_cds

bb_gene_umap(vignette_cds, "CD3E")

bb_cellmeta(vignette_cds)

pseudosamples <- bb_cellmeta(vignette_cds) |> group_by(sample, leiden_assignment) |> summarise()
pseudosamples

res <- bb_pseudobulk_mf(vignette_cds, pseudosample_table = pseudosamples, design_formula = "~leiden_assignment", result_recipe = c("leiden_assignment", "B", "T/NK"))

res$Result |> arrange(padj)

blaseRtools::project_data("/network/X/Labs/Blaser/share/resources/datapkg/ficla_aml/")
library(blaseRtools)
save_monocle_disk(vignette_cds, data_directory = fs::path_temp(), extdata_directory = fs::path_temp())
