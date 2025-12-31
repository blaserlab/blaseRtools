# Import Peaks from SEACR

The function reads peaks in .bed file format produced by SEACR.
Optionally add a group variable and value for later filtering or
faceting when combined with other peak files.

The function reads peak files produced by MACS. Optionally add a group
variable and value for later filtering or faceting when combined with
other peak files.

## Usage

``` r
bb_import_seacr_peaks(file, group_variable = NULL, group_value = NULL)

bb_import_macs_narrowpeaks(file, group_variable = NULL, group_value = NULL)
```

## Arguments

- file:

  file path to the MACS narrowpeak file

- group_variable:

  An optional variable name for additional group metadata.
  PARAM_DESCRIPTION, Default: NULL

- group_value:

  A value supplied to the group metadata variable. Required if
  group_variable is not NULL. PARAM_DESCRIPTION

## Value

A GRanges object

A GRanges object

## See also

[`read_delim`](https://readr.tidyverse.org/reference/read_delim.html)
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html)
[`makeGRangesFromDataFrame`](https://rdrr.io/pkg/GenomicRanges/man/makeGRangesFromDataFrame.html)

[`read_delim`](https://readr.tidyverse.org/reference/read_delim.html)
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html)
[`makeGRangesFromDataFrame`](https://rdrr.io/pkg/GenomicRanges/man/makeGRangesFromDataFrame.html)
