# Use doubletfinder to model and mark doublets

Use doubletfinder to model and mark doublets

## Usage

``` r
bb_doubletfinder(cds, doublet_prediction, qc_table, ncores = 1)
```

## Arguments

- cds:

  A cell data set object

- doublet_prediction:

  Predicted proportion of doublets fom 0 to 1

- qc_table:

  A table of qc calls from the blaseRtools qc function

## Value

A tibble of low- and high-confidence doublet calls by barcode
