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

A list with three items:

- simMatrix:

  The GO term semantic similarity matrix from
  [`calculateSimMatrix`](https://rdrr.io/pkg/rrvgo/man/calculateSimMatrix.html).

- scores:

  A named numeric vector, one entry per GO term in `x$res_table`, giving
  `-log10(classicFisher)` for that term's enrichment p-value (from
  `x$res_table$classicFisher`). Higher values indicate stronger
  enrichment.

- reducedTerms:

  The term-reduction result from
  [`reduceSimMatrix`](https://rdrr.io/pkg/rrvgo/man/reduceSimMatrix.html),
  whose `score` column is this same `-log10(classicFisher)` value for
  each retained term.
