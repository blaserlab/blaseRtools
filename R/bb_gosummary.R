#' A function to reduce go terms by semantic similarity
#'
#' @param  x A list go term enrichment results produced by bb_goenrichment.
#' @param  reduce_threshold The degree of term reduction. 0 to 1.  Higher is more reduction.
#' @param  go_db The database to query.  Choose from c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db", ...).
#' @return A list with three items:
#' \describe{
#'   \item{simMatrix}{The GO term semantic similarity matrix from \code{\link[rrvgo]{calculateSimMatrix}}.}
#'   \item{scores}{A named numeric vector, one entry per GO term in
#'     \code{x$res_table}, giving \code{-log10(classicFisher)} for that
#'     term's enrichment p-value (from \code{x$res_table$classicFisher}).
#'     Higher values indicate stronger enrichment.}
#'   \item{reducedTerms}{The term-reduction result from
#'     \code{\link[rrvgo]{reduceSimMatrix}}, whose \code{score} column is
#'     this same \code{-log10(classicFisher)} value for each retained term.}
#' }
#' @export
#' @import rrvgo
#' @importFrom tibble as_tibble
bb_gosummary <- function(x,
			 reduce_threshold = 0.8,
			 go_db = c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db")) {
    simMatrix <-
      calculateSimMatrix(x = x[[3]]$GO.ID,
                         ont = "BP",
                         orgdb = go_db)
    scores <- setNames(-log10(x[[3]]$classicFisher), x[[3]]$GO.ID)
    reducedTerms <- reduceSimMatrix(simMatrix,
                                    scores,
                                    threshold = reduce_threshold,
                                    orgdb = go_db) |>
      as_tibble()
    returnlist <- list(simMatrix, scores, reducedTerms)
    names(returnlist) <- c("simMatrix", "scores", "reducedTerms")
    return(returnlist)
}
