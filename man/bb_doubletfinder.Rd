% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_doubletfinder.R
\name{bb_doubletfinder}
\alias{bb_doubletfinder}
\title{Use doubletfinder to model and mark doublets}
\usage{
bb_doubletfinder(cds, doublet_prediction, qc_table, ncores = 1)
}
\arguments{
\item{cds}{A cell data set object}

\item{doublet_prediction}{Predicted proportion of doublets fom 0 to 1}

\item{qc_table}{A table of qc calls from the blaseRtools qc function}
}
\value{
A tibble of low- and high-confidence doublet calls by barcode
}
\description{
Use doubletfinder to model and mark doublets
}
