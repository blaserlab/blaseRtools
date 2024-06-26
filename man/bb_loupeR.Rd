% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_loupeR.R
\name{bb_loupeR}
\alias{bb_loupeR}
\title{Create a Loupe File from a Cell Data Set}
\usage{
bb_loupeR(cds, output_dir = ".", output_file = "loupe")
}
\arguments{
\item{cds}{Input cds.  Only works on cell data set objects.  For seurat objects, use built in loupeR functions}

\item{output_dir}{Output directory, Default: '.'}

\item{output_file}{Name of the loupe file.  .cloupe will be appended for compatibility, Default: 'loupe'}
}
\value{
Nothing
}
\description{
Converts a cell data set into a loupe file.
}
\seealso{
\code{\link[cli]{cli_abort}}, \code{\link[cli]{cli_alert}}
\code{\link[fs]{create}}
\code{\link[dplyr]{select}}, \code{\link[dplyr]{mutate}}, \code{\link[dplyr]{across}}, \code{\link[dplyr]{reexports}}
\code{\link[tidyselect]{starts_with}}
\code{\link[SingleCellExperiment]{reducedDims}}
\code{\link[monocle3]{exprs}}
\code{\link[waldo]{compare}}
\code{\link[loupeR]{create_loupe}}
}
