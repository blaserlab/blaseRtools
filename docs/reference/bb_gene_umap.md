# Make a Plot of Gene Expression in UMAP Form

Takes in a Seurat or cell_dat_set object, extracts UMAP dimensions and
gene expression values. For Seurat, default assay is "RNA"; can be
changed to if necessary. For cell_data_set, the assay parameter does
nothing; the function extracts log and size-factor normalized counts
which are similar but not identical to the Seurat "RNA" assay. If a
vector of genes is supplied to gene_or_genes, a faceted plot will be
generated. If a dataframe is supplied, an aggregated plot will be
generated with a facet for each gene group. The dataframe must be of 2
colums: the first containing feature ids and the second containing
grouping information. This is best generated using bb_rowmeta.

## Usage

``` r
bb_gene_umap(
  obj,
  gene_or_genes,
  assay = "RNA",
  order = TRUE,
  cell_size = 1,
  alpha = 1,
  ncol = NULL,
  plot_title = NULL,
  color_legend_title = "Expression",
  max_expr_val = NULL,
  alt_dim_x = NULL,
  alt_dim_y = NULL,
  rasterize = FALSE,
  raster_dpi = 300,
  cds = NULL
)
```

## Arguments

- obj:

  A Seurat or cell_data_set object.

- gene_or_genes:

  Individual gene or genes or aggregated genes to plot. Supply a
  character string for a single gene, a vector for multiple genes or a
  dataframe for aggregated genes. See description.

- assay:

  For Seurat objects only: the gene expression assay to get expression
  data from, Default: 'RNA'

- order:

  Whether or not to order cells by gene expression. When ordered,
  non-expressing cells are plotted first, i.e. on the bottom. Caution:
  when many cells are overplotted it may lead to a misleading
  presentation. Generally bb_genebubbles is a better way to present,
  Default: TRUE

- cell_size:

  Size of the points, Default: 1

- alpha:

  Transparency of the points, Default: 1

- ncol:

  Specify the number of columns if faceting, Default: NULL

- plot_title:

  Optional title for the plot, Default: NULL

- color_legend_title:

  Option to change the color scale title, Default: 'Expression'

- max_expr_val:

  Maximum expression value to cap the color scale, Default: NULL

- alt_dim_x:

  Alternate/reference dimensions to plot by.

- alt_dim_y:

  Alternate/reference dimensions to plot by.

- rasterize:

  Whether to render the graphical layer as a raster image. Default is
  FALSE.

- raster_dpi:

  If rasterize then this is the DPI used. Default = 300.

- cds:

  Provided for backward compatibility. If a value is supplied a warning
  will be emitted., Default: NULL

## Value

A ggplot

## See also

[`normalized_counts`](https://rdrr.io/pkg/monocle3/man/normalized_counts.html)
[`as_tibble`](https://tibble.tidyverse.org/reference/as_tibble.html)
[`pivot_longer`](https://tidyr.tidyverse.org/reference/pivot_longer.html)
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html),
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`arrange`](https://dplyr.tidyverse.org/reference/arrange.html)
[`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html),
[`aes`](https://ggplot2.tidyverse.org/reference/aes.html),
[`geom_point`](https://ggplot2.tidyverse.org/reference/geom_point.html),
[`scale_colour_viridis_d`](https://ggplot2.tidyverse.org/reference/scale_viridis.html),
[`labs`](https://ggplot2.tidyverse.org/reference/labs.html),
[`facet_wrap`](https://ggplot2.tidyverse.org/reference/facet_wrap.html),
[`vars`](https://ggplot2.tidyverse.org/reference/vars.html),
[`theme`](https://ggplot2.tidyverse.org/reference/theme.html),
[`margin`](https://ggplot2.tidyverse.org/reference/element.html)
