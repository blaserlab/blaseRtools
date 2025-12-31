# Aggregate Single Cell Gene Expression

Generates a matrix of counts aggregated by gene and/or cell group.

## Usage

``` r
bb_aggregate(
  obj,
  assay = "RNA",
  experiment_type = "Gene Expression",
  gene_group_df = NULL,
  cell_group_df = NULL,
  norm_method = c("log", "binary", "size_only"),
  pseudocount = 1,
  scale_agg_values = TRUE,
  max_agg_value = 3,
  min_agg_value = -3,
  binary_min = 0,
  exclude.na = TRUE
)
```

## Arguments

- obj:

  A Seurat or cell data set object

- assay:

  Gene expression assay to use for aggregation; currently only applies
  to Seurat objects, Default: 'RNA'

- gene_group_df:

  A 2-column dataframe with gene names or ids and gene groupings,
  Default: NULL

- cell_group_df:

  A 2-coumn dataframe with cell ids and gene groupings, Default: NULL

- norm_method:

  Gene normalization method, Default: c("log", "binary", "size_only")

- pseudocount:

  Pseudocount, Default: 1

- scale_agg_values:

  Whether to scale the aggregated values, Default: TRUE

- max_agg_value:

  If scaling, make this the maximum aggregated value, Default: 3

- min_agg_value:

  If scaling, make this the minimum aggregated value, Default: -3

- binary_min:

  Minimum value below which a cell is considered not to express a
  feature, Default: 0

- exclude.na:

  Exclude NA?, Default: TRUE

## Value

A dense or sparse matrix.

## Details

The best way to group genes or cells is by using bb\_\*meta and then
select cell_id or feature_id plus one metadata column with your group
labels.

## See also

[`cli_div`](https://cli.r-lib.org/reference/cli_div.html),
[`cli_alert`](https://cli.r-lib.org/reference/cli_alert.html)
[`normalized_counts`](https://rdrr.io/pkg/monocle3/man/normalized_counts.html),
`my.aggregate.Matrix` `character(0)`
