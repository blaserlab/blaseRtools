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

A list with three items:

- sampleGOdata:

  The `topGOdata` object built from `query`/`reference`.

- resultFisher:

  The `topGOresult` object returned by `runTest()`.

- res_table:

  A tibble of the top 100 GO terms (by
  [`GenTable`](https://rdrr.io/pkg/topGO/man/diagnosticMethods.html)),
  with `classicFisher` replaced by the raw numeric p-values taken
  directly from `resultFisher@score` (rather than GenTable's
  character-formatted, precision-truncated values) so downstream
  consumers (e.g. [`bb_gosummary`](bb_gosummary.md)) receive a numeric
  column.
