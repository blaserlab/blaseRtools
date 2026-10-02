#' Go Term Enrichment
#'
#' @description A function to find enriched go terms from a query list of gene names relative to a reference list of gene names.
#' @param query A vector of gene names
#' @param reference The background gene list.  Usually will be as_tibble(rowData(cds_main)).
#' @param group_pval P value to determine enrichment.  Default: 0.01.
#' @param go_db GO term database Default: c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db")
#' @return A list with three items:
#' \describe{
#'   \item{sampleGOdata}{The \code{topGOdata} object built from \code{query}/\code{reference}.}
#'   \item{resultFisher}{The \code{topGOresult} object returned by \code{runTest()}.}
#'   \item{res_table}{A tibble of the top 100 GO terms (by \code{\link[topGO]{GenTable}}),
#'     with \code{classicFisher} replaced by the raw numeric p-values taken
#'     directly from \code{resultFisher@score} (rather than GenTable's
#'     character-formatted, precision-truncated values) so downstream
#'     consumers (e.g. \code{\link{bb_gosummary}}) receive a numeric column.}
#' }
#' @export
#' @import tidyverse topGO
#' @rdname bb_goenrichment
bb_goenrichment <- function(query,
                            reference,
                            group_pval = 0.01,
                            go_db = c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db")) {
  genes <- query
  genes_named <- reference %>%
    as_tibble() %>%
    mutate(selected = ifelse(gene_short_name %in% genes, 1, 0)) %>%
    pull(selected)
  names(genes_named) <- reference %>%
    as_tibble() %>%
    pull(gene_short_name)

  sampleGOdata <- new(
    "topGOdata",
    description = "Simple session",
    ontology = "BP",
    allGenes = genes_named,
    geneSel = selector,
    nodeSize = 10,
    annot = annFUN.org,
    mapping = go_db,
    ID = "symbol"
  )

  resultFisher <-
    runTest(sampleGOdata, algorithm = "classic", statistic = "fisher")

  resultFisher_tbl <-
    tibble(goterm = names(resultFisher@score),
           pval = resultFisher@score)

  res_table <- GenTable(
    sampleGOdata,
    classicFisher = resultFisher,
    orderBy = "classicFisher",
    ranksOf = "classicFisher",
    topNodes = 100
  ) %>%
    as_tibble(rownames = "Rank") %>%
    # GenTable formats classicFisher via format.pval(), which always returns
    # character (e.g. truncating tiny p-values at its 1e-30 floor); recover
    # the original numeric p-values from resultFisher's scores instead.
    select(-classicFisher) %>%
    left_join(resultFisher_tbl, by = c("GO.ID" = "goterm")) %>%
    rename(classicFisher = pval)

  return_list <- list(sampleGOdata, resultFisher, res_table)
  names(return_list) <- c("sampleGOdata", "resultFisher", "res_table")

  return(return_list)
}


selector <- function(theScore) {
  return (theScore == 1)
}
