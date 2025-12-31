# A Function To Add Tibble Columns To Feature Metadata

A Function To Add Tibble Columns To Feature Metadata

## Usage

``` r
bb_tbl_to_rowdata(
  obj,
  assay = "RNA",
  min_tbl,
  join_col = "feature_id",
  cds = NULL
)
```

## Arguments

- obj:

  A Seurat or cell data set object

- assay:

  The assay to which to add the metadata column, Default = RNA

- min_tbl:

  A tibble containing only the columns you want to add plus one column
  for joining. Features cannot be duplicated but missing features are ok
  and will be replaced by NA.

- join_col:

  The column in min_tbl containing the join information for the cds
  rowData. Defaults to "feature_id".

- cds:

  Retained for backwards compatibility. If supplied, will generate a
  warning and pass argument to obj. Default = NULL

## Value

An object of the same class
