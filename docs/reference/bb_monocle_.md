# Annotate Single cell Data Using Monocle3

This function wraps the monocle3 method for data projection and label
transfer into a function. This function takes in reference and query cds
objects plus a character vector of label column names and returns the
query CDS with the new labels.

bb_monocle_anno and bb_monocle_project use similar inputs and methods
and both return cds objects, but the cds objects are different. Both
wrap around the monocle3 mehtod for data projection and label transfer.

bb_monocle_anno takes in reference and query cds objects plus a
character vector of label column names to transfer. It returns the query
CDS with new cell metadata contining one or more columns with the labels
corresponding to the nearest neighbor in the reference data. A suffix is
appended to the new column name in the result. By default this is
"\_ref" but it can be changed using the suffix parameter.

bb_monocle_project also takes in reference and query cds objects and
character vector of label column names. In this case, a combined cds
object is returned carrying the query and reference data projected int
the reference data space. New column names are added indicating the
reference and query data. The query cells are given the label of their
nearest neighbor in the reference. These label column(s) are prepended
with "merged\_".

Importantly, for both of these to work, the reference and query genes
must have a shared namespace.

## Usage

``` r
bb_monocle_(cds_qry, cds_ref, labels, suffix, use_aligned)

bb_monocle_anno(cds_qry, cds_ref, labels, suffix = "_ref", use_aligned = TRUE)

bb_monocle_project(
  cds_qry,
  cds_ref,
  labels,
  suffix = "_ref",
  use_aligned = TRUE
)
```

## Arguments

- cds_qry:

  A query cell data set.

- cds_ref:

  A reference cell data set.

- labels:

  A character vector of cell metadata column names to transfer.

- suffix:

  A character string of length 1 to append to all of the tranferred
  column names. There is no checking for name conflicts, so use this
  sensibly to prevent overwriting preexisting columns. Default =
  "\_ref".

- use_aligned:

  Whether to use aligned PCA coordinates from cds_ref, if they are
  available. Default = TRUE.

## Value

A cell data set

## Details

see https://cole-trapnell-lab.github.io/monocle3/docs/projection/

## See also

[`cli_abort`](https://cli.r-lib.org/reference/cli_abort.html),
[`cli_alert`](https://cli.r-lib.org/reference/cli_alert.html) `sets`
[`estimate_size_factors`](https://rdrr.io/pkg/monocle3/man/estimate_size_factors.html),
[`preprocess_cds`](https://rdrr.io/pkg/monocle3/man/preprocess_cds.html),
[`reduce_dimension`](https://rdrr.io/pkg/monocle3/man/reduce_dimension.html),
[`save_transform_models`](https://rdrr.io/pkg/monocle3/man/save_transform_models.html),
[`load_transform_models`](https://rdrr.io/pkg/monocle3/man/load_transform_models.html),
[`preprocess_transform`](https://rdrr.io/pkg/monocle3/man/preprocess_transform.html),
[`reduce_dimension_transform`](https://rdrr.io/pkg/monocle3/man/reduce_dimension_transform.html),
[`transfer_cell_labels`](https://rdrr.io/pkg/monocle3/man/transfer_cell_labels.html),
[`fix_missing_cell_labels`](https://rdrr.io/pkg/monocle3/man/fix_missing_cell_labels.html)
[`reducedDims`](https://rdrr.io/pkg/SingleCellExperiment/man/reducedDims.html)
[`path`](https://fs.r-lib.org/reference/path.html)
[`map`](https://purrr.tidyverse.org/reference/map.html),
[`reduce`](https://purrr.tidyverse.org/reference/reduce.html)
[`SummarizedExperiment-class`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`join_by`](https://dplyr.tidyverse.org/reference/join_by.html)

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 #EXAMPLE1
 }
} # }
```
