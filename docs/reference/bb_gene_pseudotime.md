# Plot expression of a gene or genes in pseudotime.

Plot expression of a gene or genes in pseudotime.

## Usage

``` r
bb_gene_pseudotime(
  cds_subset,
  min_expr = NULL,
  cell_size = 0.75,
  nrow = NULL,
  ncol = 1,
  panel_order = NULL,
  color_cells_by = "pseudotime",
  trend_formula = "~ splines::ns(pseudotime, df=3)",
  label_by_short_name = TRUE,
  vertical_jitter = NULL,
  horizontal_jitter = NULL
)
```

## Arguments

- cds_subset:

  A cell data set object subset with only cells and genes of interest

- min_expr:

  Lower threshold of expression for plotting

- cell_size:

  Size of point for plotting

- nrow:

  Number of rows for facetting

- ncol:

  Number of columns for facetting

- panel_order:

  Character string for order of genes to plot

- color_cells_by:

  A cds colData column

- trend_formula:

  Formula for the trend line

- label_by_short_name:

  Boolean to label by gene name or ID

- vertical_jitter:

  Adjustment to vertical jitter. Optional

- horizontal_jitter:

  Adjustment to horizontal jitter. Optional

## Value

A ggplot
