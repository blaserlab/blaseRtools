#' Run Multifactor Pseudobulk Analysis using Deseq2
#'
#' @description Use this function to perform Pseudbulk DGE analysis.
#' @param cds The cell data set object subset to analyze
#' @param pseudosample_table A tibble indicating the sample groupings for analysis.  This should include 1.) Unique sample identifiers 2.) Any sample-level cell metadata you wish to include in the regression model and 3.) Any Cell-level metadata you may wish to include such as clusters or partitions.  Values will be coerced to factors.
#' @param design_formula The regression-style formula for the analysis.  In the form of "~ variable1 + variable2 + ... final_variable". The default behavior is to calculate results according to the final_variable in the design_formula with preceding variables as co-variates.  The reference class is chosen according to alphabetical order.  This behavior can be modified by specifying the result_recipe argument.
#' @param count_filter The minimum number of counts required across all pseudosamples in order to keep a gene in the analysis.
#' @param result_recipe See above for the default recipe.  Alternatively, supply a 3-element vector in the form of c("variable", "experimental_level","reference_or_control_level")
#' @return A list of results from pseudobulk analysis
#' @export
#' @import tidyverse pheatmap Matrix.utils monocle3
bb_pseudobulk_mf <- function(cds,
                             pseudosample_table,
                             design_formula,
                             count_filter = 10,
                             result_recipe = "default") {
  # sanitize the result_recipe argument
  result_recipe <- str_replace_all(result_recipe, "[^[:alnum:]]", "_")

  # sanitize the pseudosample table to remove unusable characters and create a dummy variable called pseudosample
  pseudosample_table <-
    pseudosample_table %>%
    ungroup() %>%
    mutate(across(.cols = everything(), ~ str_replace_all(., "[^[:alnum:]]", "_"))) %>%
    mutate(ps_id = paste0("pseudosample_", row_number())) %>%
    mutate(across(.cols = everything(), as.factor)) %>%
    relocate(ps_id)

  # convert to data frame
  pseudosample_df <- pseudosample_table %>%
    column_to_rownames(var = "ps_id")

  # clean the cell metadata
  cellmeta <- bb_cellmeta(cds) %>%
    select(matches(colnames(pseudosample_df))) %>%
    mutate(across(.cols = everything(), ~ str_replace_all(., "[^[:alnum:]]", "_"))) %>%
    mutate(across(.cols = everything(), as.factor))

  # join the pseudosample id onto the cell metadata to generate groupings

  groups <-
    left_join(cellmeta, pseudosample_table) %>% select(ps_id)

  # get the aggregate counts
  aggregate_counts <-
    aggregate.Matrix(t(as.matrix(exprs(cds))), groupings = groups, fun = "sum")
  counts_matrix <- as.matrix(t(as.matrix(aggregate_counts)))

  # filter the count matrix
  counts_matrix <- counts_matrix[rowSums(counts_matrix) >= 10, ]

  # check that rownames == colnames
  stopifnot("Rownames and colnames are mismatched." = all(rownames(pseudosample_df) == colnames(counts_matrix)))

  # make the deseq object
  dds <- DESeq2::DESeqDataSetFromMatrix(
    countData = counts_matrix,
    colData = pseudosample_df,
    design = as.formula(design_formula)
  )

  # do the thing
  dds <- DESeq2::DESeq(dds)
  if (result_recipe == "default") {
    res <- DESeq2::results(dds)
  } else {
    res <- DESeq2::results(dds, contrast = result_recipe)
  }

  # shrink the l2fc for visualization and ranking

  shrnk <- DESeq2::lfcShrink(dds = dds, res = res, type = "ashr")
  res_tbl <-
    as.data.frame(res)  %>%
    rownames_to_column(var = "id") %>%
    as_tibble() %>%
    left_join(., as_tibble(rowData(cds)[, c("id", "gene_short_name")])) %>%
    relocate(gene_short_name, .after = id)

  shrnk_tbl <-
    as.data.frame(shrnk)  %>%
    rownames_to_column(var = "id") %>%
    as_tibble() %>%
    left_join(., as_tibble(rowData(cds)[, c("id", "gene_short_name")])) %>%
    relocate(gene_short_name, .after = id)

  #qc
  rld <- DESeq2::rlog(dds, blind = T)
  intgroups <- colnames(colData(dds))
  intgroups <- intgroups[intgroups != "sizeFactor"]
  pcas <- map(
    .x = intgroups,
    .f = function(x, data = rld) {
      pca_plot <- DESeq2::plotPCA(object = data, intgroup = x)
      return(pca_plot)
    }
  )
  # Extract the rlog matrix from the object and compute pairwise correlation values
  rld_mat <- assay(rld)
  rld_cor <- cor(rld_mat)

  # Plot heatmap
  heatmap <-
    pheatmap::pheatmap(rld_cor,
                       annotation_row = pseudosample_df,
                       annotation_col = pseudosample_df)

  # plot dispersion
  plot.new()
  DESeq2::plotDispEsts(dds)
  dispersion <- recordPlot()
  dev.off()

  return_list <-
    list(
      "Header" = res@elementMetadata@listData[["description"]],
      "Result" = res_tbl,
      "Shrunk Result" = shrnk_tbl,
      "PCAs" = pcas,
      "Heatmap" = heatmap,
      "Dispersion" = dispersion
    )
  return(return_list)
}