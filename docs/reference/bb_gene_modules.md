# A function to generate gene modules and add them to the Gene Metadata

Based on Monocle3's gene module functions. Implemented with default
values. Will convert a Seurat object to a cell data set using
SeuratWrappers and then calculate modules. The function returns an
object of the same type.

## Usage

``` r
bb_gene_modules(obj, n_cores = 8, cds = NULL)
```

## Arguments

- obj:

  A single cell object of type Seurat or cell_data_set.

- n_cores:

  Number of processor cores to use for the analysis, Default: 8

- cds:

  Provided for backward compatibility. If a value is supplied, it will
  return a warning and transfer to the obj argument., Default: NULL

## Value

An object of the same type: Seurat or cell_data_set

## Details

see
https://cole-trapnell-lab.github.io/monocle3/docs/differential/#gene-modules

## See also

[`graph_test`](https://rdrr.io/pkg/monocle3/man/graph_test.html),
[`find_gene_modules`](https://rdrr.io/pkg/monocle3/man/find_gene_modules.html)
[`rename`](https://dplyr.tidyverse.org/reference/rename.html),
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html),
[`select`](https://dplyr.tidyverse.org/reference/select.html)
[`fct_shift`](https://forcats.tidyverse.org/reference/fct_shift.html)
