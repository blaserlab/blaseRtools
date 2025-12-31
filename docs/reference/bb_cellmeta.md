# Get Cell Metadata

Take a cell_data_set object or a Seurat object and return the cell
metadata in the form of a tibble. The unique cell identifier column is
labeled cell_id by default. Prior versions of this function would only
accept a cell_data_set. The input argument has been changed from cds to
obj to reflect the fact that Seurat objects are now also accepted.

## Usage

``` r
bb_cellmeta(obj, row_name = "cell_id", cds = NULL)
```

## Arguments

- obj:

  A cell_data_set or Seurat object.

- row_name:

  Optional name to provide for cell unique identifier, Default:
  'cell_id'

- cds:

  Provided for compatibility with prior versions, Default: NULL

## Value

A tibble

## Details

If a value is supplied for cds, a warning will be issued and the
function will pass the value of cds to obj.
