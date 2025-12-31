# Filter a CDS

This function provides a pipe-friendly method to filter cds objects.

## Usage

``` r
filter_cds(cds, cells = "all", genes = "all")
```

## Arguments

- cds:

  The CDS to filter.

- cells:

  Optional: a tibble of cell metadata for the cells you wish to keep.
  Use bb_cellmeta(). Default: 'all'

- genes:

  Optional: a tibble of gene metadata for the genes you wish to keep.
  Use bb_rowmeta(). Default: 'all'

## Value

A filtered CDS
