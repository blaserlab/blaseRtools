# Plot a UMAP Showing Cite-Seq Antibody Binding

Requires a cds with an alt experiment established. Use bb_split_citeseq
to generate this and to normalize binding data using the CLR method.
Returns a ggplot.

## Usage

``` r
bb_cite_umap(
  cds,
  antibody,
  assay = "CLR_counts",
  cell_size = 1,
  alpha = 1,
  alt_dim_x = NULL,
  alt_dim_y = NULL,
  plot_title = NULL,
  color_legend_title = NULL,
  order = TRUE,
  rescale = NULL,
  ncol = NULL
)
```

## Arguments

- cds:

  The cds with an "Antibody Capture" alt experiment to plot.

- antibody:

  The name of the antibody to plot. Equivalent to gene_short_name.
  Accepts a character vector.

- assay:

  The binding assay to use, Default: "CLR_counts"

- cell_size:

  Size of points to plot, Default: 1

- alpha:

  Alpha for the plotted points, Default: 1

- alt_dim_x:

  Alternate/reference dimensions to plot by.

- alt_dim_y:

  Alternate/reference dimensions to plot by.

- plot_title:

  Optional title for the plot, Default: NULL

- color_legend_title:

  Optional title for the color scale., Default: NULL

- order:

  Whether or not to order cells by gene expression. When ordered,
  non-expressing cells are plotted first, i.e. on the bottom. Default:
  TRUE

- rescale:

  Optional redefinition of the color scale, Default: NULL

- ncol:

  If specified, the number of columns for facet_wrap, Default: NULL

## Value

a ggplot

## See also

[`reducedDims`](https://rdrr.io/pkg/SingleCellExperiment/man/reducedDims.html)
