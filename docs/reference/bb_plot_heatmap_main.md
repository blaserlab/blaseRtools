# Plot the Body of Heatmap

Takes in a Summarized Heatmap object and returns a ggplot of the matrix
data.

## Usage

``` r
bb_plot_heatmap_main(
  obj,
  tile_color = "white",
  high = "red3",
  mid = "white",
  low = "blue4",
  flip = FALSE
)
```

## Arguments

- obj:

  A SummarizedHeatmap

- tile_color:

  Outline of the color tiles, Default: 'white'

- high:

  Color for high values, applied to scale_fill_gradient_2, Default:
  'red3'

- mid:

  Color for mid values, applied to scale_fill_gradient_2, Default:
  'white'

- low:

  Color for low values, applied to scale_fill_gradient_2, Default:
  'blue4'

- flip:

  Whether to transpose the matrix, i.e. plot the rows as columns and
  columns as rows, Default: FALSE

## Value

a ggplot
