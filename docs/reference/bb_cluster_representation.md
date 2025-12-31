# Cluster Representation By Fisher Exact Test Per Cell

Use this function to determine the differential representation of cells
in clusters. It will determine fold change in a single experimental
class over a single control or reference class. This value is normalized
to the number of cells captured in all clusters from the class.
Significance is determined using Fisher's exact test. This test may
overestimate significance in large data sets. In this case,
bb_cluster_representation2 may be more robust.

## Usage

``` r
bb_cluster_representation(
  cds,
  cluster_var,
  class_var,
  experimental_class,
  control_class,
  pseudocount = 1,
  return_value = c("table", "plot")
)
```

## Arguments

- cds:

  A cell data set object

- cluster_var:

  The CDS cell metadata column holding cluster data. There can be any
  number of clusters in this column.

- class_var:

  The CDS cell metadata column holding sample class data. There can be
  only 2 classes in this column. You may need to subset or reclass the
  samples to achieve this.

- experimental_class:

  The value from the class column indicating the experimental group.

- control_class:

  The value from the class column indicating the control or reference
  class.

- return_value:

  Option to return either a plot or a data table for plotting in a
  separate step. Must be either "plot" or "table".

## Value

A ggplot or a table of data for plotting
