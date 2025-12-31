# Format a GRanges Object as a Character Vector For Inclusion in Genebank File

This function takes a GRanges object and returns a character vector.
Only 4 metadata fields from the GRanges object will be included:
locus_tag, type, fwdcolor and revcolor. Locus_tag must be unique. This
will be checked by the Ape constructor. This function should mostly be
used internally in the construction and FEATURE-setting of instances of
the Ape class.

## Usage

``` r
granges_to_features(gr)
```

## Arguments

- gr:

  A GRanges object.

## Value

A character vector.
