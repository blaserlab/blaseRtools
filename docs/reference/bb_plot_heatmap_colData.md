# Plot SummarizedHeatmap colData

Will generate a ggplot from the colData of a SummarizedHeatmap object.
Typically this will be placed at the top or bottom of a plot. If
flipped, use the side argument to put the colData on the left or right.

## Usage

``` r
bb_plot_heatmap_colData(
  obj,
  tile_color = "white",
  vars = colnames(colData(obj)),
  side = c("top", "bottom", "right", "left"),
  manual_pal = NULL
)
```

## Arguments

- obj:

  a SummarizedHeatmap object

- tile_color:

  Outline color for the tiles, Default: 'white'

- vars:

  Variables to plot. Supply a named vector to change the axis text and
  legend titles for each variable, Default: colnames(colData(obj))

- side:

  Side on which to plot, Default: c("top", "bottom", "right", "left")

- manual_pal:

  a color palette, preferably a named vector corresponding to values of
  colData, Default: NULL

## Value

a ggplot
