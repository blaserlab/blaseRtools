# Convert objects to Monocle3 `cell_data_set` objects

Convert objects to Monocle3 `cell_data_set` objects

## Usage

``` r
as.cell_data_set(x, ...)

# S3 method for class 'Seurat'
as.cell_data_set(
  x,
  assay = DefaultAssay(object = x),
  reductions = AssociatedDimReducs(object = x, assay = assay),
  default.reduction = DefaultDimReduc(object = x, assay = assay),
  graph = paste0(assay, "_snn"),
  group.by = NULL,
  ...
)
```

## Arguments

- x:

  An object

- ...:

  Arguments passed to other methods

- assay:

  Assays to convert

- reductions:

  A vector of dimensional reductions add to the `cell_data_set` object;
  defaults to all dimensional reductions calculated from `assay` and all
  [global](https://satijalab.github.io/seurat-object/reference/IsGlobal.html)
  dimensional reductions

- default.reduction:

  Name of dimensional reduction to use for clustering name

- graph:

  Name of graph to be used for clustering results

- group.by:

  Name of cell-level metadata column to use as identites; pass

## Value

A `cell_data_set` object

## Details

The
[`Seurat`](https://satijalab.org/seurat/reference/Seurat-package.html)
method utilizes
[`as.SingleCellExperiment`](https://satijalab.org/seurat/reference/as.SingleCellExperiment.html)
to transfer over expression and cell-level metadata. The following
additional information is also transferred over:

- Cell emebeddings are transferred over to the
  [`reducedDims`](https://rdrr.io/pkg/SingleCellExperiment/man/reducedDims.html)
  slot. Dimensional reduction names are converted to upper-case (eg.
  “umap” to “UMAP”) to match Monocle 3 style

- Feature loadings are transfered to `cds@reduce_dim_aux$gene_loadings`
  if present. **NOTE**: only the feature loadings of the last
  dimensional reduction are transferred over

- Standard deviations are added to `cds@reduce_dim_aux$prop_var_expl` if
  present. **NOTE**: only the standard deviations of the last
  dimensional reduction are transferred over

- Clustering information is transferred over in the following manner: if
  cell-level metadata entries “monocle3_clusters” and
  “monocle3_partitions” exist, then these will be set as the clusters
  and partitions, with no nearest neighbor graph being added to the
  object; otherwise, Seurat's nearest-neighbor graph will be converted
  to an
  [`igraph`](https://r.igraph.org/reference/aaa-igraph-package.html)
  object and added to the `cell_data_set` object along with Seurat's
  clusters. No partition information is added when using Seurat's
  clsuters

## See also

[`as.SingleCellExperiment`](https://satijalab.org/seurat/reference/as.SingleCellExperiment.html)
