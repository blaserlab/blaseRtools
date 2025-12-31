# Plot The Feature Data From A Trace Object

A function to generate a feature plot from tracklike genomic data.

## Usage

``` r
bb_plot_trace_feature(trace, type_to_plot)
```

## Arguments

- trace:

  A Trace object. Should have a metadata column in the features slot
  named "type".

- type_to_plot:

  Value of the type variable to plot. This will be come the Y-axis
  label.
