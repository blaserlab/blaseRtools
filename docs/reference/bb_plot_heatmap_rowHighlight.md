# Plot a Row Highlight

Plots a selected row name from a SummarizedHeatmap object. Useful when
there are too many to highlight so you can't alter the plot axis.

## Usage

``` r
bb_plot_heatmap_rowHighlight(
  obj,
  highlights = character(0),
  side = c("right", "left", "top", "bottom"),
  ...
)
```

## Arguments

- obj:

  A summarized Heatmap object

- highlights:

  A vector of rows to highlight, Default: character(0)

- side:

  Side on which to plot the highlight, Default: c("top", "bottom",
  "right", "left")

- ...:

  Other arguments to pass to geom_text_repel

## Value

a ggplot
