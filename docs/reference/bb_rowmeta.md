# Get Feature/Gene Metadata

Take a cell_data_set or Seurat object and return the gene/feature
metadata in the form of a tibble. RNA is used as the default assay.

## Usage

``` r
bb_rowmeta(
  obj,
  row_name = "feature_id",
  experiment_type = "Gene Expression",
  assay = "RNA",
  cds = NULL
)
```

## Arguments

- obj:

  A cell_data_set or Seurat object

- row_name:

  Optional name to provide for feature unique identifier, Default:
  'feature_id'

- experiment_type:

  The experiment type to display. Applies only to cds objects. Commonly
  will be either "Gene Expression" or "Antibody Capture", Default: 'Gene
  Expression'

- assay:

  For a Seurat object, th feature assay to return. CDS objects with
  alternative experiments are not supported, Default: 'RNA'

- cds:

  Provided for compatibility with prior versions, Default: NULL

## Value

At tibble.

## Details

If a value is supplied for cds, a warning will be issued and the
function will pass the value of cds to obj.
