# Make a scatter plot of GO term associations

Make a scatter plot of GO term associations

## Usage

``` r
bb_goscatter(
  simMatrix,
  reducedTerms,
  size = "score",
  addLabel = TRUE,
  labelSize = 4
)
```

## Arguments

- simMatrix:

  Take from output of bb_gosummary

- reducedTerms:

  Also take from output of bb_gosummary

- size:

  Variable to map to point size. Defaults to "score".

- addLabel:

  Boolean; whether or not to add text labels

- labelSize:

  Optional label size

## Value

A ggplot
