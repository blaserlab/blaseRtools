# Rejoin qc and doubletfinder data to a cds object

Rejoin qc and doubletfinder data to a cds object

## Usage

``` r
bb_rejoin(cds, qc_data, doubletfinder_data)
```

## Arguments

- cds:

  A cell data set object to rejoin to

- qc_data:

  A table of cell barcodes with qc data. Can be extracted from bb_qc
  with purrr::map(qc_result, 1)

- doubletfinder_data:

  The doubletfinder result tbl

## Value

A cell data set object with qc and doubletfinder data
