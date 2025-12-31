# Plot a SummarizedHeatmap rowData

Use this function to create a plot annotating SummarizedHeatmap rowDAta

## Usage

``` r
bb_plot_heatmap_rowData(
  obj,
  tile_color = "white",
  vars = colnames(rowData(obj)),
  side = c("right", "left", "top", "bottom"),
  manual_pal = NULL
)
```

## Arguments

- obj:

  A SummarizedHeatmap objectr

- tile_color:

  Color for the tile outlines, Default: 'white'

- vars:

  rowData variables to plot. Supply a named vector to change the names
  shown on the axis and legend, Default: colnames(rowData(obj))

- side:

  Side on which to plotj, Default: c("right", "left", "top", "bottom")

- manual_pal:

  Color palette for filling the tiles, preferably a named vector,
  Default: NULL

## Value

a ggplot
