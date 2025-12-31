# Plot motif footprinting results

Plot motif footprinting results

## Usage

``` r
bb_plotfootprint(
  object,
  features,
  alt_main_title = NULL,
  alt_color_title = NULL,
  legend_pos = "right",
  colorscale = NULL,
  assay = NULL,
  group.by = NULL,
  idents = NULL,
  label = TRUE,
  repel = TRUE,
  show.expected = TRUE,
  normalization = "subtract",
  label.top = 3,
  label.idents = NULL,
  fontsize = 14,
  linesize = 0.2
)
```

## Arguments

- object:

  A Seurat object

- features:

  A vector of features to plot

- alt_main_title:

  Alternative title for the main plot. Accepts markdown.

- alt_color_title:

  Alternative title for the color scale

- legend_pos:

  Position to place the legend

- colorscale:

  Named vector of colors to apply to the top plot.

- assay:

  Name of assay to use

- group.by:

  A grouping variable

- idents:

  Set of identities to include in the plot

- label:

  TRUE/FALSE value to control whether groups are labeled.

- repel:

  Repel labels from each other

- show.expected:

  Plot the expected Tn5 integration frequency below the main footprint
  plot

- normalization:

  Method to normalize for Tn5 DNA sequence bias. Options are "subtract",
  "divide", or NULL to perform no bias correction.

- label.top:

  Number of groups to label based on highest accessibility in motif
  flanking region.

- label.idents:

  Vector of identities to label. If supplied,

- fontsize:

  Theme font size

- linesize:

  Size to draw the footprint lines `label.top` will be ignored.
