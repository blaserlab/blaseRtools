% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metafeature_funcs.R
\name{bb_metafeature}
\alias{bb_metafeature}
\title{A Function to Generate Data For Making MetaPlots}
\usage{
bb_metafeature(
  query,
  targets,
  select_hits = TRUE,
  width = 2000,
  binwidth = 10,
  sample_id = NULL
)
}
\arguments{
\item{query}{A GRanges object.  This should be from a bam file so you can plot read coverage across the metagene.}

\item{targets}{A GRanges object.  The targets you want to plot around.}

\item{select_hits}{Do you want to plot only the targets that have overlappign query reads?  Defaults to true.}

\item{width}{The width of the analysis in bp.}

\item{binwidth}{The binwidth in bp.  Width must be evenly divided by binwidth.}

\item{sample_id}{An optional sample id if you want to join this matrix up with another one.}
}
\value{
A list including a matrix and a tibble.
}
\description{
Use this function to generate data for making TSS enrichment plots or other metafeature plots that are centered on a single genomic locus.  This function returns the data you need for the plot.  Use the tibble element that is returned to plot the enrichment plot and the matrix for the heatmap.  The problem currently is that the binwidths for the enrichment plot need to be smaller than the binwidths for the heatmap to look good.  If you use good binwidths for the enrichment plot, the heatmap will crash.  So either reduce the size of the heatmap matrix before plotting that or rerun the function with a different bin size.  This function allows sample names to be added, so several samples can be column-bound together for comparison.  Each gene is normalized to its own outer flanks so this should account for differences in sequencing depth to some degree.  You also have the option to include all possible TSS in the plot (i.e. including zeros) which you may want to do if comparing several samples.  To do this, set select_hits to FALSE.
}
