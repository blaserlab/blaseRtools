# Read Bam Files

This function reads a single sorted, dedupliated paired end bam file and
returns either a GRanges object or a GenomicAlignmentPairs object. The
former requires much less memory but a the cost of retaining the outer
boundaries of each read. If read 1 has start S1 and end E1 and read 2
has start S2 and end S2, the Granges object spans S1-E2.

## Usage

``` r
bb_read_bam(
  sortedBam,
  genome = c("hg38", "danRer11"),
  return_type = c("GenomicAlignmentPairs", "GRanges")
)
```

## Arguments

- sortedBam:

  File path to the bam file to load.

- genome:

  One of "hg38" or "danRer11". This is used to clean up the granges
  object if necessary.

- return_type:

  Type of object to return. GRanges is smaller. GenomicAlignmentPairs
  retains read pair data.

## Value

An object according to return_type.
