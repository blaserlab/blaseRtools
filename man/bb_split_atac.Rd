% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/atac.R
\name{bb_split_atac}
\alias{bb_split_atac}
\title{Split Out Peaks Data}
\usage{
bb_split_atac(cds)
}
\arguments{
\item{cds}{CDS to split the Peaks data from}
}
\value{
A cell data set
}
\description{
Extracts Peaks data from 10X counts matrix and feature metadata and saves it as an alternate experiment in the assigned CDS.
}
