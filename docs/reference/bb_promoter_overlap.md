# Calculate The Overlap Between Peaks and Promoters

For a given GRanges object containing peaks, determine how many peaks
overlap promoters, how many promoters are overlapped by peaks and the
significance of enrichment of query peaks relative to promoters.

## Usage

``` r
bb_promoter_overlap(query, tss = c("hg38_tss", "dr11_tss"), width = 200)
```

## Arguments

- query:

  A GRanges object containing peaks

- tss:

  The tss data base to use. Must be one of "hg38_tss" or "dr11_tss"

- width:

  The width around the tss to evaluate. Defaults to 200 bp.

## Value

A list including overlap information and binomal test results.
