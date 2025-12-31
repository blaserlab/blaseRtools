# Plot a Heatmap Row Dendrogram

Takes in a SummarizedHeatmap object and returns a ggplot of the
rowDendro slot. This can be positioned with the side parameter. Default
is to position it on the left. If flipping the heatmap so that the rows
run vertically, you will need to change the side argument to top or
bottom.

If row order is set explicitly when creating this object, the dendrogram
slot will be NULL and this function will abort.

## Usage

``` r
bb_plot_heatmap_rowDendro(
  obj,
  side = c("left", "right", "top", "bottom"),
  linewidth = 0.5
)
```

## Arguments

- obj:

  a Summarized Heatmap

- side:

  Orientation/side of the heatmap to plot, Default: c("left", "right",
  "top", "bottom")

- linewidth:

  Weight of the lines for the dendrogram, Default: 0.5

## Value

A ggplot
