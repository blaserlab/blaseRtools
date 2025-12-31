# Set the Trace Data Slot of a GRanges Object

Set the Trace Data Slot of a GRanges Object

## Usage

``` r
Trace.setData(trace, gr)
```

## Arguments

- trace:

  A trace object

- gr:

  A GRanges object. This object will become the new trace_data. If the
  range is smaller, it will trim the other slots to match. Usually this
  is used to change range metadata only.
