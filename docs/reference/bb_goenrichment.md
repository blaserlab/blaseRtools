# Go Term Enrichment

A function to find enriched go terms from a query list of gene names
relative to a reference list of gene names.

## Usage

``` r
bb_goenrichment(
  query,
  reference,
  group_pval = 0.01,
  go_db = c("org.Hs.eg.db", "org.Dr.eg.db", "org.Mm.eg.db")
)
```

## Arguments

- query:

  A vector of gene names

- reference:

  The background gene list. Usually will be
  as_tibble(rowData(cds_main)).

- group_pval:

  P value to determine enrichment. Default: 0.01.

- go_db:

  GO term database Default: c("org.Hs.eg.db", "org.Dr.eg.db",
  "org.Mm.eg.db")

## Value

A list of items including the enrichment results.
