# A Function To Add Tibble Columns To Cell Metadata

A Function To Add Tibble Columns To Cell Metadata

## Usage

``` r
bb_tbl_to_coldata(obj, min_tbl, join_col = "cell_id", cds = NULL)
```

## Arguments

- obj:

  A Seurat or cell data set object

- min_tbl:

  A tibble containing only the columns you want to add plus one column
  for joining. Cell IDs may not be duplicated but missing cells are ok;
  values will be replaced by NA.

- join_col:

  The column in min_tbl containing the join information for the cds
  rowData. Defaults to "cell_id".

- cds:

  Retained for backwards compatibility. If supplied, will generate a
  warning and pass argument to obj. Default = NULL

## Value

An object of the same class
