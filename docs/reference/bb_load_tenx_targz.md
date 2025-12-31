# Load 10X Data Into CDS

Load 10X Data Into CDS

## Usage

``` r
bb_load_tenx_targz(targz_file, umi_cutoff = 100, sample_metadata_tbl = NULL)
```

## Arguments

- targz_file:

  A character string of the file path to the multi pipestance directory

- umi_cutoff:

  Don't import cells with fewer UMIs than this value. Defaults to 100.

- sample_metadata_tbl:

  A tibble in wide format with one line. Col names indicate metadata
  variables to add.

## Value

A cell data set object.
