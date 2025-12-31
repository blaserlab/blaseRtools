# Clean Up Your GRanges Object

This function does several things. It removes ranges with non-standard
chromosomes and drops their levels. It will optionally set the genome to
the user-provided value. Typically we would use "hg38" or "danRer11".
This is the exported version because it is so useful.

## Usage

``` r
bb_buff_granges(x, gen)
```

## Arguments

- x:

  A Granges object to buff.

- gen:

  An optional genome name to provide. Recommend "hg38" or "danRer11".

## Value

A GRanges object
