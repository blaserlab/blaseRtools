devtools::load_all()
vignette_cds

bb_gene_umap(vignette_cds, "CD3E")

bb_cellmeta(vignette_cds)

pseudosamples <- bb_cellmeta(vignette_cds) |> group_by(sample, leiden_assignment) |> summarise()
pseudosamples

res <- bb_pseudobulk_mf(vignette_cds, pseudosample_table = pseudosamples, design_formula = "~leiden_assignment", result_recipe = c("leiden_assignment", "B", "T/NK"))

res$Result |> arrange(padj)


