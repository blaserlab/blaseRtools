# Calculate Differential Abundance Using DAseq

This function takes a cell data set object and a cell metadata variable
as input. The latter is specified as a named list. The name is the cell
metadata variable name and each element must be a character vector of
length 2 specifying the levels of that variable to compare. For example,
for a column named "genotype" with levels "WT", "heterozygote", and
"homozygote", you would compare differential abundance between WT and
homozygote like this: list(genotype = c("WT", "homozygote")). Cells with
these classifications will get a differential abundance score. Negative
values will be assigned to the first element (WT in this example) and
positive values to the second element (homozygote in this example).
Cells with other values for this variable ("heterozygote" in this
example) will get an NA. Multiple comparisons can be performed for
different levels within the same variable or for different variables
altogether by providing additional elements to the list. E.g.
list(genotype = c("WT", "heterozygote), genotype = c("WT",
"homozygote")). For each comparison, a new cell metadata column will be
added in the form of da_score_name_level1_level2. E.g.
da_score_genotype_WT_homozygote.

## Usage

``` r
bb_daseq(obj, comparison_list, sample_var = "sample")
```

## Arguments

- obj:

  a cell data set object

- comparison_list:

  a named list as specified in description

- sample_var:

  the cell metadata variable holding biological sample information,
  Default: 'sample'

## Value

a cell data set

## See also

[`cli_div`](https://cli.r-lib.org/reference/cli_div.html),
[`cli_alert`](https://cli.r-lib.org/reference/cli_alert.html)
[`map2`](https://purrr.tidyverse.org/reference/map2.html),
[`reexports`](https://purrr.tidyverse.org/reference/reexports.html),
[`pmap`](https://purrr.tidyverse.org/reference/pmap.html),
[`reduce`](https://purrr.tidyverse.org/reference/reduce.html)
[`filter`](https://dplyr.tidyverse.org/reference/filter.html),
[`pull`](https://dplyr.tidyverse.org/reference/pull.html),
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`join_by`](https://dplyr.tidyverse.org/reference/join_by.html),
[`rename`](https://dplyr.tidyverse.org/reference/rename.html)
[`reducedDims`](https://rdrr.io/pkg/SingleCellExperiment/man/reducedDims.html)
[`getDAcells`](https://rdrr.io/pkg/DAseq/man/getDAcells.html)
[`as_tibble`](https://tibble.tidyverse.org/reference/as_tibble.html)
