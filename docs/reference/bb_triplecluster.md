# A function to generate clusters from scRNA-seq data

Based on Monocle3's Partitions, Leiden, and Louvain clustering methods.
Implemented mostly with default values. Seurat objects will be converted
to cell_data_set objects for the clustering. The function produces a
list of top markers for each cluster type and returns these assignments
to the original object as new cell metadata columnts.

## Usage

``` r
bb_triplecluster(
  obj,
  n_top_markers = 50,
  outfile = NULL,
  n_cores = 8,
  cds = NULL
)
```

## Arguments

- obj:

  A Seurat or cell_data_set object

- n_top_markers:

  Number of top markers to identify per cell group, Default: 50

- outfile:

  Name of a csv file to hold the top marker results. If null, will place
  "top_markers.csv" in the working directory, Default: NULL

- n_cores:

  Number of processor cores to use, Default: 8

- cds:

  Provided for backwards compatibility for existing code. If a value is
  supplied it will be transferred to obj and a warning message will be
  emitted, Default: NULL

## Value

A modified Seurat or cell_data_set object
