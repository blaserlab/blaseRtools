# Plot The Trace Data From A Trace Object

A function to generate a line plot from tracklike genomic data. This
pulls data from the Trace object trace_data slot. Check what numeric and
categorical variables are available for plotting using Trace.data.

## Usage

``` r
bb_plot_trace_data(
  trace,
  yvar = "coverage",
  yvar_label = "Coverage",
  facet_var = "group",
  color_var = "group",
  pal = NULL,
  legend_pos = "none",
  group_filter = NULL,
  group_variable = "group"
)
```

## Arguments

- trace:

  A Trace object

- yvar:

  The trace_data metadata variable that will become the y axis. Defaults
  to "coverage". Must be numeric.

- yvar_label:

  The y-axis label for the coverage track. Defaults to "Coverage".

- facet_var:

  The trace_data metadata variable describing data facets. Each will be
  placed as a separate horizontal track with the value printed to the
  left. Optional but recommended. Defaults to "group".

- color_var:

  The variable to color groups of traces by. Optional but recommended.
  Defaults to "group".

- pal:

  A color palette. Can also be added after the fact.

- legend_pos:

  Color legend position. Can also be added after the fact. Defaults to
  "none".

- group_filter:

  Optional value to filter the trace data by. Should be a value from the
  "group" metadata variable in the trace object.

- group_variable:

  Optional metadatavariable to filter trace data by. When imported from
  signac/seurat objects, this value defaults to "group", so that is the
  default here. However if constructed manually, you may wish to apply
  filtering to another variable. If so, apply it to this parameter.
