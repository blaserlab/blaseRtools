% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_load_tenx.R
\name{bb_load_tenx_targz}
\alias{bb_load_tenx_targz}
\title{Load 10X Data Into CDS}
\usage{
bb_load_tenx_targz(targz_file, umi_cutoff = 100, sample_metadata_tbl = NULL)
}
\arguments{
\item{targz_file}{A character string of the file path to the multi pipestance directory}

\item{umi_cutoff}{Don't import cells with fewer UMIs than this value.  Defaults to 100.}

\item{sample_metadata_tbl}{A tibble in wide format with one line.  Col names indicate metadata variables to add.}
}
\value{
A cell data set object.
}
\description{
Load 10X Data Into CDS
}
