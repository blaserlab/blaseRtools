% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_meta.R
\name{bb_cellmeta}
\alias{bb_cellmeta}
\title{Get Cell Metadata}
\usage{
bb_cellmeta(obj, row_name = "cell_id", cds = NULL)
}
\arguments{
\item{obj}{A cell_data_set or Seurat object.}

\item{row_name}{Optional name to provide for cell unique identifier, Default: 'cell_id'}

\item{cds}{Provided for compatibility with prior versions, Default: NULL}
}
\value{
A tibble
}
\description{
Take a cell_data_set object or a Seurat object and return the cell metadata in the form of a tibble.  The unique cell identifier column is labeled cell_id by default.  Prior versions of this function would only accept a cell_data_set.  The input argument has been changed from cds to obj to reflect the fact that Seurat objects are now also accepted.
}
\details{
If a value is supplied for cds, a warning will be issued and the function will pass the value of cds to obj.
}
