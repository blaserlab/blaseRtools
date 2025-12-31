# Make a Complex Heatmap From a CellChat Object With Sensible Defaults

This will generate heatmap from a CellChat object using
ComplexHeatmap::Heatmap. Options are provided to filter for sender and
receiver cells, to generate simple marginal annotations and for
aesthetic control.

## Usage

``` r
bb_cellchat_heatmap(
  object,
  source_filter = NULL,
  target_filter = NULL,
  interaction_filter = NULL,
  interaction_threshold = 0,
  colors = c("transparent", "red3"),
  rowanno = c(NULL, "Annotation", "Pathway"),
  rowanno_colors = NULL,
  colanno = c(NULL, "Source", "Target"),
  colanno_colors = NULL,
  pval_filter = 0.05,
  heatmap_name = "Interaction\nScore",
  heatmap_show_row_dend = TRUE,
  heatmap_row_dend_width = unit(5, "mm"),
  heatmap_show_column_dend = TRUE,
  heatmap_column_dend_height = unit(5, "mm"),
  heatmap_row_names_gp = gpar(fontsize = 10),
  heatmap_column_names_gp = gpar(fontsize = 10),
  heatmap_column_names_rot = 90,
  heatmap_column_title = NULL,
  heatmap_column_title_gp = gpar(fontsize = 12, fontface = "bold"),
  col_anno_name_gp = gpar(fontsize = 10, fontface = "bold"),
  row_anno_name_gp = gpar(fontsize = 10, fontface = "bold"),
  return_value = c("heatmap", "plot", "matrix")
)
```

## Arguments

- object:

  The CellChat object to plot

- source_filter:

  Optional filter for source cell clusters from the object metadata.
  Accepts a single string or vector of cell groups., Default: NULL

- target_filter:

  Optional filter for target cell clusters from the object metadata.
  Accepts a single string or vector of cell groups., Default: NULL

- interaction_filter:

  Optional filter to include only certain interactions in the figure.

- interaction_threshold:

  Optional filter to only include interactions above a certain
  threshold.

- colors:

  Color scale endpoints, Default: c("transparent", "red3")

- rowanno:

  Options for simple row annotation; must be one of c(NULL,
  "Annotation", "Pathway")

- rowanno_colors:

  Optional colors to replace the poor color selections from Complex
  heatmap. Must be supplied as a named list with one element each for
  "Annotation" and "Pathway". Not required if not showing these
  annotations. The list should be of the form: list(Annotation =
  c("name1" = "color value1", "name2" = "color_value2")), Default: NULL

- colanno:

  Options for simple column annotation; must be one of c(NULL, "Source",
  "Target")

- colanno_colors:

  See rowanno_colors, Default: NULL

- pval_filter:

  Filter for significance of associations. CellChat returns pvalues of
  0, 0.01, and 0.05; this function will filter and retain values less
  than or equal to the provided value. Default: 0.05

- heatmap_name:

  Name for the main color scale of the heatmap, Default:
  'InteractionScore'

- heatmap_show_row_dend:

  Show row dendrograms? Default: TRUE

- heatmap_row_dend_width:

  Width of row dendrograms Default: unit(5, "mm")

- heatmap_show_column_dend:

  Show column dendrograms?' Default: TRUE

- heatmap_column_dend_height:

  Height of column dendrograms. Default: unit(5, "mm")

- heatmap_row_names_gp:

  Row name graphical params, Default: gpar(fontsize = 10)

- heatmap_column_names_gp:

  Column name graphical params, Default: gpar(fontsize = 10)

- heatmap_column_names_rot:

  Column name rotation, Default: 90

- heatmap_column_title:

  Column title, Default: NULL

- heatmap_column_title_gp:

  Column title graphical params, Default: gpar(fontsize = 12, fontface =
  "bold")

- col_anno_name_gp:

  Column annotation name graphical params, Default: gpar(fonmtsize = 10,
  fontface = "bold")

- row_anno_name_gp:

  Row annotation name graphical params, Default: gpar(fontsize = 10,
  fontface = "bold")

- return_value:

  Return a heatmap plot or a matrix.

## Value

a heatmap as a grid object; plot using cowplot::plot_grid

## Details

see github::sqjin/CellChat

## See also

[`subsetCommunication`](https://rdrr.io/pkg/CellChat/man/subsetCommunication.html)
[`as_tibble`](https://tibble.tidyverse.org/reference/as_tibble.html),`c("tibble", "tibble")`,[`rownames`](https://tibble.tidyverse.org/reference/rownames.html)
[`filter`](https://dplyr.tidyverse.org/reference/filter.html),[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html),[`select`](https://dplyr.tidyverse.org/reference/select.html),[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),[`group_by`](https://dplyr.tidyverse.org/reference/group_by.html),[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)
[`pivot_wider`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
[`rowAnnotation`](https://rdrr.io/pkg/ComplexHeatmap/man/rowAnnotation.html),[`columnAnnotation`](https://rdrr.io/pkg/ComplexHeatmap/man/columnAnnotation.html),`draw-dispatch`,[`Heatmap`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
[`colorRamp2`](https://rdrr.io/pkg/circlize/man/colorRamp2.html)
[`grid.grab`](https://rdrr.io/r/grid/grid.grab.html)
