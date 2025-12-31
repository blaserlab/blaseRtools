# A function to reduce go terms by semantic similarity

A function to reduce go terms by semantic similarity

## Usage

``` r
bb_gosummary(
  x,
  reduce_threshold = 0.8,
  go_db = c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db")
)
```

## Arguments

- x:

  A list go term enrichment results produced by bb_goenrichment.

- reduce_threshold:

  The degree of term reduction. 0 to 1. Higher is more reduction.

- go_db:

  The database to query. Choose from c("org.Hs.eg.db", "org.Dr.eg.db",
  "org.Mm.eg.db", ...).

## Value

A list of items for downstream plotting
