# Create a Loupe File from a Cell Data Set

Converts a cell data set into a loupe file.

## Usage

``` r
bb_loupeR(cds, output_dir = ".", output_file = "loupe")
```

## Arguments

- cds:

  Input cds. Only works on cell data set objects. For seurat objects,
  use built in loupeR functions

- output_dir:

  Output directory, Default: '.'

- output_file:

  Name of the loupe file. .cloupe will be appended for compatibility,
  Default: 'loupe'

## Value

Nothing

## See also

[`cli_abort`](https://cli.r-lib.org/reference/cli_abort.html),
[`cli_alert`](https://cli.r-lib.org/reference/cli_alert.html)
[`create`](https://fs.r-lib.org/reference/create.html)
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html),
[`across`](https://dplyr.tidyverse.org/reference/across.html),
[`reexports`](https://dplyr.tidyverse.org/reference/reexports.html)
[`starts_with`](https://tidyselect.r-lib.org/reference/starts_with.html)
[`reducedDims`](https://rdrr.io/pkg/SingleCellExperiment/man/reducedDims.html)
[`exprs`](https://rdrr.io/pkg/monocle3/man/exprs.html)
[`compare`](https://waldo.r-lib.org/reference/compare.html)
[`create_loupe`](https://rdrr.io/pkg/loupeR/man/create_loupe.html)
