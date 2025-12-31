# Plot a Heatmap Column Dendrogram

Takes in a SummarizedHeatmap object and returns a ggplot of the
rowDendro slot. This can be positioned with the side parameter. Default
is to position it on the left. If flipping the heatmap so that the rows
run vertically, you will need to change the side argument to top or
bottom.

If row order is set explicitly when creating this object, the dendrogram
slot will be NULL, and this function will abort.

## Usage

``` r
bb_plot_heatmap_colDendro(
  obj,
  side = c("top", "bottom", "left", "right"),
  linewidth = 0.5
)
```

## Arguments

- obj:

  a Summarized Heatmap

- side:

  Orientation/side of the heatmap to put the dendrogram, Default:
  c("top", "bottom", "left", "right")

- linewidth:

  Weight of the dendrogram plot, Default: 0.5

## Value

a ggplot
