# Convert single cell experiment to Seurat

Convert single cell experiment to Seurat

## Usage

``` r
# S3 method for class 'cell_data_set'
as.Seurat(
  x,
  counts = "counts",
  data = NULL,
  assay = "RNA",
  project = "cell_data_set",
  loadings = NULL,
  clusters = NULL,
  ...
)
```

## Arguments

- loadings:

  Name of dimensional reduction to save loadings to, if present;
  defaults to first dimensional reduction present (eg.
  `SingleCellExperiment::reducedDimNames(x)[1]`); pass `NA` to suppress
  transfer of loadings

- clusters:

  Name of clustering method to use for setting identity classes

## Details

The `cell_data_set` method for
[`as.Seurat`](https://satijalab.github.io/seurat-object/reference/as.Seurat.html)
utilizes the `SingleCellExperiment` method of
[`as.Seurat`](https://satijalab.github.io/seurat-object/reference/as.Seurat.html)
to handle moving over expression data, cell embeddings, and cell-level
metadata. The following additional information will also be transfered
over:

- Feature loadings from `cds@reduce_dim_aux$gene_loadings` will be added
  to the dimensional reduction specified by `loadings` or the name of
  the first dimensional reduction that contains "pca" (case-insensitive)
  if `loadings` is not set

- Monocle 3 clustering will be set as the default identity class. In
  addition, the Monocle 3 clustering will be added to cell-level
  metadata as “monocle3_clusters”, if present

- Monocle 3 partitions will be added to cell-level metadata as
  “monocle3_partitions”, if present

- Monocle 3 pseudotime calculations will be added to
  “monocle3_pseudotime”, if present

- The nearest-neighbor graph, if present, will be converted to a `Graph`
  object, and stored as “`assay`\_monocle3_graph”

## See also

[`as.Seurat.SingleCellExperiment`](https://satijalab.org/seurat/reference/as.Seurat.html)
