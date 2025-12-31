# Plot a Column Highlight

Use geom_text_repel to selectively highlight some column names. Useful
when there are too many to highlight to be able to use the axis
directly.

## Usage

``` r
bb_plot_heatmap_colHighlight(
  obj,
  highlights = character(0),
  side = c("top", "bottom", "right", "left"),
  ...
)
```

## Arguments

- obj:

  A summarized heatmap

- highlights:

  A vector of columns to highlight, Default: character(0)

- side:

  Side on which to put the higlight, Default: c("top", "bottom",
  "right", "left")

- ...:

  Other arguments to pass to geom_text_repel

## Value

a ggplot
