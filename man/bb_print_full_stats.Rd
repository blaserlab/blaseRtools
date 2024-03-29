% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_print_full_stats.R
\name{bb_print_full_stats}
\alias{bb_print_full_stats}
\title{Print out a stats report}
\usage{
bb_print_full_stats(
  data,
  classification_variable,
  numeric_variable,
  test_type = c("Student", "Welch", "Wilcox"),
  output = NULL
)
}
\arguments{
\item{data}{A Tibble in tidy data format.  Must contain or be filtered to contain only 2 levels in "classification_variable" for comparisons.}

\item{classification_variable}{Column containing the class variable}

\item{numeric_variable}{The column containing the numeric values to summarize and compare}

\item{test_type}{Must be one of "Student", "Welch", and "Wilcox"}

\item{output}{Output file; if null prints to screen.}
}
\value{
A text file
}
\description{
Print out a stats report
}
