# Align a CDS object according to a metadata variable

Align a CDS object according to a metadata variable

## Usage

``` r
bb_align(cds, align_by, n_cores = 8)
```

## Arguments

- cds:

  A cell data set object to align

- align_by:

  A metadata column to align by

- n_cores:

  Number of cores to reduce dimensions by.

## Value

A modified cell data set object with aligned dimensions and new metadata
columns holding prealignment umap coordinates.
