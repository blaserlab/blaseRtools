# Make a plot of gene expression in UMAP form

Make a plot of gene expression in UMAP form

## Usage

``` r
bb_gene_violinplot(
  cds,
  variable,
  genes_to_plot,
  experiment_type = "Gene Expression",
  pseudocount = 1,
  include_jitter = FALSE,
  ytitle = "Expression",
  plot_title = NULL,
  rows = 1,
  show_x_label = TRUE,
  legend_pos = "none",
  comparison_list = NULL,
  palette = NULL,
  violin_alpha = 1,
  jitter_alpha = 1,
  jitter_color = "black",
  jitter_fill = "transparent",
  jitter_size = 0.5,
  facet_scales = "fixed",
  order_genes = TRUE,
  jitter_match = FALSE,
  rasterize = FALSE,
  raster_dpi = 300
)
```

## Arguments

- cds:

  A cell data set object

- variable:

  Stratification variable for x-axis

- genes_to_plot:

  Either a character vector of gene short names or a tbl/df where the
  first column is gene short name and the second is the gene grouping.

- pseudocount:

  Value to add to zero-cells

- include_jitter:

  Include jitter points

- ytitle:

  Title for y axis

- plot_title:

  Main title for the plot

- rows:

  Number of rows for facetting

- show_x_label:

  Option to show x label

- legend_pos:

  Position for label

- comparison_list:

  Optional list of comparisons for ggpubr

- palette:

  Color palette to use. Viridis is default.

- violin_alpha:

  Alpha value for violin plot

- jitter_alpha:

  Alpha value for jitter plot

- jitter_color:

  Color for the jitter plot. Defaults to black and ignored if
  jitter_match == TRUE

- jitter_fill:

  Fill for the jitter plot

- jitter_size:

  Size of the jitter points

- facet_scales:

  Scale option for facetting. "Fixed" is default

- order_genes:

  If true, put genes in the same order as variable parameter

- jitter_match:

  If true, match jitter color to violin fill.

- rasterize:

  Whether to render the graphical layer as a raster image. Default is
  FALSE.

- raster_dpi:

  If rasterize then this is the DPI used. Default = 300.

## Value

A ggplot
