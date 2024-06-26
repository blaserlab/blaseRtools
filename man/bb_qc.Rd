% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bb_qc.R
\name{bb_qc}
\alias{bb_qc}
\title{A function to run qc tests on cds objects.}
\usage{
bb_qc(
  cds,
  cds_name,
  genome = c("human", "mouse", "zfish"),
  nmad_mito = 2,
  nmad_detected = 2,
  max_mito = NULL,
  min_log_detected = NULL
)
}
\arguments{
\item{cds}{A cell data set object to run qc functions on}

\item{cds_name}{The name of the cds}

\item{genome}{The species to use for identifying mitochondrial genes. Choose from "human", "mouse", "zfish", "human_mouse" for pdx.}

\item{max_mito}{Manual cutoff for mitochondrial percentage.  May be more strict, i.e. lower, than the automated cutoff but not less strict,  Default: NULL}

\item{min_log_detected}{Manual cutoff for log detected features.  May be more strict, i.e. higher, than the automated cutoff not not less strict, Default: NULL}
}
\value{
A list of qc objects
}
\description{
A function to run qc tests on cds objects.
}
