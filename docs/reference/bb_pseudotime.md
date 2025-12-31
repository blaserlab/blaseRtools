# Learn Graph and Calculate Pseudotime

This function determines a gene expression trajectory using
`learn_graph` from monocle3 and then calculates pseudotime dimensions
along this trajectory using `order_cells`. So it is 2 functions wrapped
into 1. Usually we will not adjust the parameters for learn_graph with
the possible exception of `close_loop` and `use_partition` which are
also available in this function with the same defaults. If you need to
fine-tune the trajectory, use
[`monocle3::learn_graph`](https://rdrr.io/pkg/monocle3/man/learn_graph.html)
on the cds object first and then run this function to calculate
pseudotime. The graph learning will not be repeated on an object unless
`force_graph` is set to `TRUE`.

If you just want to look at the trajectory graph and not calculate
pseudotime, change `calculate_pseudotime` to FALSE, or run
[`monocle3::learn_graph`](https://rdrr.io/pkg/monocle3/man/learn_graph.html).

After the pseudotime values are calculated, they are handled differently
than in monocle3. In this function, they are copied from the hidden CDS
slot and made an explicit cell metadata column. Pseudotime needs a
starting point or anchor. There is no interactive option here as in
monocle3. To identify this starting point, you identify a cell metadata
variable and provide it to `cluster_variable`. This should identify a
cohesive group of cells in UMAP space such as a leiden cluster, louvain
cluster or partition. Then provide a value corresponding to the cluster
of interest to `cluster_value`. The function will start pseudotime at
the cell closest to the graph node in that cluster. The pseudotime value
column will be named automatically as a composite of the
`cluster_variable` and `cluster_value` parameters.

## Usage

``` r
bb_pseudotime(
  cds,
  calculate_pseudotime = TRUE,
  cluster_variable,
  cluster_value,
  use_partition = TRUE,
  close_loop = TRUE,
  force_graph = FALSE
)
```

## Arguments

- cds:

  The cell data set object to calculate pseudotime upon. Does not yet
  accept seurat objects.

- calculate_pseudotime:

  Logical, whether to calculate the pseudotime dimension. If false, will
  only run learn_graph, Default: TRUE

- cluster_variable:

  The cell metadata column from which the pseudotime = 0 cell will be
  selected.

- cluster_value:

  The value of cluster_variable that identifies a cluster. The cell
  closest to the root node closest to the center of this cluster will
  have pseudotime of 0.

- use_partition:

  Logical; If TRUE, learn_graph will construct trajectories within
  partitions. If FALSE, it will connect partitions, Default: TRUE

- close_loop:

  Logical; Whether learn_graph will close looping trajectories, Default:
  TRUE

- force_graph:

  Logical; If TRUE, the function will recalculate the graph., Default:
  FALSE

## Value

A cell data set

## See also

[`cli_div`](https://cli.r-lib.org/reference/cli_div.html),
[`cli_alert`](https://cli.r-lib.org/reference/cli_alert.html)
[`learn_graph`](https://rdrr.io/pkg/monocle3/man/learn_graph.html),
[`order_cells`](https://rdrr.io/pkg/monocle3/man/order_cells.html),
[`pseudotime`](https://rdrr.io/pkg/monocle3/man/pseudotime.html)
[`SummarizedExperiment-class`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
