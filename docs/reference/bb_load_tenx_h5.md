# Load a 10X Genomics H5 File and Return a CDS

This function reads a 10X Genomics H5 file and returns a cell_data_set
or CDS. The option to split citeseq data .

## Usage

``` r
bb_load_tenx_h5(filename, sample_metadata_tbl = NULL, split_citeseq = FALSE)
```

## Arguments

- filename:

  Path to the h5 file.

- sample_metadata_tbl:

  A single row data frame with sample metadata. Usually this will be
  filtered from an experiment config file.

- split_citeseq:

  Option to retain citeseq data within the main experiment slot or split
  it out to an alternate slot.

## Value

A cell data set.
