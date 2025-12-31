# Make a Heatmap of Aggregated Gene Expressionf from a CDS

Supply a cds subset and aggregation values and get a heatmap. Plot the
return value using cowplot::plot_grid(). This function wraps several
complicated functions from ComplexHeatmap and tries to apply default
values for the most common use case: plotting top markers from a cds
with cells grouped arbitrarily (usually by cluster of some type). This
function provides the option to aggregate by genes as well in order to
plot gene modules. For cell and gene aggregation, provide a name (in the
form of a string) of the corresponding metadata column and the
aggregation will be performed. There are many aesthetic parameters for
this function and even more available for the internal
ComplexHeatmap::Heatmap() function. The best way to adjust parameters
not provided here is to scroll the popup box that appears when you type
ComplexHeatmap::Heatmap() in RStudio and pass them in via the ellipsis.
The default is to put genes in columns and cells in rows. You can flip
this behavior by setting flip_axis = TRUE. This will require adjustment
of some aesthetic parameters. Complex annotations (beyond labeling
cherry-picked genes) are not currently supported.

## Usage

``` r
bb_cds_heatmap(
  cds_subset,
  cellmeta_col = NULL,
  rowmeta_col = NULL,
  heatmap_highlights = NULL,
  three_colors = c("blue4", "ivory", "red3"),
  flip_axis = FALSE,
  name = NULL,
  heatmap_legend_param = list(title_gp = gpar(fontface = "plain", fontsize = 9),
    grid_width = unit(0.14, "in"), labels_gp = gpar(fontsize = 8)),
  row_dend_width = unit(5, "mm"),
  column_dend_height = unit(5, "mm"),
  column_dend_side = "bottom",
  show_row_names = T,
  row_names_gp = gpar(fontsize = 9),
  show_column_names = F,
  row_dend_gp = gpar(lwd = 0.5),
  column_dend_gp = gpar(lwd = 0.5),
  row_title = NULL,
  column_title = NULL,
  padding = 1.5,
  labels_rot = 45,
  ...
)
```

## Arguments

- cds_subset:

  The subset of cells and genes you want to plot as a heatmap. Best
  approach is to pipe the cds through filter_cds() and into this
  function.

- cellmeta_col:

  The name of a cell metadata column to aggregate cells by; one of
  cellmeta_col and rowmeta_col must not be NULL, Default: NULL

- rowmeta_col:

  The name of a row metadata column to aggregate cells by; one of
  cellmeta_col and rowmeta_col must not be NULL, Default: NULL

- heatmap_highlights:

  A vector of gene names to highlight using anno_mark(), Default: NULL

- three_colors:

  A vector of colors for the main color scale, Default: c("blue4",
  "ivory", "red3")

- flip_axis:

  Logical; whether to plot genes as rows (TRUE) or columns (FALSE),
  Default: FALSE

- name:

  Name of the main color scale, Default: NULL

- heatmap_legend_param:

  Graphical parameters for the main heatmap legend, Default:
  list(title_gp = gpar(fontface = "plain", fontsize = 9), grid_width =
  unit(0.14, "in"), labels_gp = gpar(fontsize = 8))

- row_dend_width:

  Row dendrogram width, Default: unit(5, "mm")

- column_dend_height:

  Column dendrogram height, Default: unit(5, "mm")

- column_dend_side:

  Side on which to plot the column dendrogram, Default: 'bottom'

- show_row_names:

  Logical; whether or not to show rownames, Default: T

- row_names_gp:

  Graphical parameters for the row names, Default: gpar(fontsize = 9)

- show_column_names:

  Logical; whether or not to show column names, Default: F

- row_dend_gp:

  Graphical parameters for the row dendrogram, Default: gpar(lwd = 0.5)

- column_dend_gp:

  Graphical parameters for teh column dendrogram, Default: gpar(lwd =
  0.5)

- row_title:

  Row title text, Default: NULL

- column_title:

  Column title text, Default: NULL

- padding:

  Padding between gene names on the heatmap highlights, Default: 1.5

- labels_rot:

  Rotation of the heatmap highlight labels, Default: 45

- ...:

  Optional arguments to pass to ComplexHeatmap::Heatmap()

## Value

A complex heatmap in the form of a gtree.
