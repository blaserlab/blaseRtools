# Plot The peak Data From A Trace Object

A function to generate a peak plot from tracklike genomic data.

## Usage

``` r
bb_plot_trace_peaks(
  trace,
  group_filter = NULL,
  group_variable = "group",
  pal = NULL
)
```

## Arguments

- trace:

  A Trace object.

- group_filter:

  Optional value to filter the peak data by. Should be a value from the
  "group" metadata variable in the trace object.

- group_variable:

  Optional metadatavariable to filter trace data by. When imported from
  signac/seurat objects, this value defaults to "group", so that is the
  default here. However if constructed manually, you may wish to apply
  filtering to another variable. If so, apply it to this parameter.

- fill_color:

  The color to fill the peak graphics with. Defaults to grey60.
