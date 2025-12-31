# Plot The Link Data From A Trace Object

A function to generate a link plot from tracklike genomic data. Links
will automatically be trimmed to lie entirely within the plot range. An
additional, optional score cutoff can be provided.

## Usage

``` r
bb_plot_trace_links(
  trace,
  cutoff = 0,
  link_low_color = "grey80",
  link_high_color = "red3",
  link_range = c(0, 1)
)
```

## Arguments

- trace:

  A Trace object containing a valid links slot.

- cutoff:

  Score cutoff for link plotting. Defaults to 0.

- link_low_color:

  The color of a link with value of 0, default = grey80

- link_high_color:

  The color of a link with value of 1, default = red3

- link_range:

  The range of the color scale in terms of link values, default = c(0,1)
