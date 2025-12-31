# Plot The Gene Model From A Trace Object

A function to generate a plot of the underlying gene model. The genes to
be plotted are automatically selected according to the genome build and
the plot range. The function automatically picks the longest principle
transcript to show. Optionally, alternative transcripts can be shown by
specifying the select_transcript argument. This must be an ensembl
transcript identifier lying within the plot range.

## Usage

``` r
bb_plot_trace_model(
  trace,
  font_face = "italic",
  select_transcript = NULL,
  icon_fill = "cornsilk",
  debug = FALSE
)
```

## Arguments

- trace:

  A Trace object.

- font_face:

  Font face option to use. Default = "italic".

- select_transcript:

  Optional selected transcript(s) to plot.

- icon_fill:

  The color to make the exon boxes.

- debug:

  Boolean. Option to show the transcript ID on the final plot to confirm
  you have the right one. Default = FALSE.
