# Plots expression for one or more genes as a function of pseudotime

Plots expression for one or more genes as a function of pseudotime

## Usage

``` r
bb_plot_genes_in_pseudotime(
  cds,
  gene_or_genes,
  pseudotime_dim,
  min_expr = NULL,
  cell_size = 0.75,
  nrow = NULL,
  ncol = 1,
  panel_order = NULL,
  color_cells_by = pseudotime_dim,
  trend_formula_df = 3,
  label_by_short_name = TRUE,
  vertical_jitter = NULL,
  horizontal_jitter = NULL,
  legend_title = NULL
)
```

## Arguments

- cds:

  Cell data set to plot.

- gene_or_genes:

  Gene or genes for which to plot pseudotime.

- pseudotime_dim:

  The column holding the pseudotime dimension to plot along.

- min_expr:

  the minimum (untransformed) expression level to plot.

- cell_size:

  the size (in points) of each cell used in the plot.

- nrow:

  the number of rows used when laying out the panels for each gene's
  expression.

- ncol:

  the number of columns used when laying out the panels for each gene's
  expression

- panel_order:

  vector of gene names indicating the order in which genes should be
  laid out (left-to-right, top-to-bottom). If
  `label_by_short_name = TRUE`, use gene_short_name values, otherwise
  use feature IDs.

- color_cells_by:

  the cell attribute (e.g. the column of colData(cds)) to be used to
  color each cell. Defaults to the value provided for pseudotime_dim.

- trend_formula_df:

  degrees of freedom for the model formula used to fit the expression
  trend over pseudotime. The formulat takes the form of "~
  splines::ns(pseudotime_dim, df = trend_formula_df)".

- label_by_short_name:

  label figure panels by gene_short_name (TRUE) or feature ID (FALSE).

- vertical_jitter:

  A value passed to ggplot to jitter the points in the vertical
  dimension. Prevents overplotting, and is particularly helpful for
  rounded transcript count data.

- horizontal_jitter:

  A value passed to ggplot to jitter the points in the horizontal
  dimension. Prevents overplotting, and is particularly helpful for
  rounded transcript count data.

## Value

a ggplot2 plot object
