# Noramalize a Data Table by Group and Batch

Often you will have a data table with repeats or batches of the same
experiment. An effective way to control for batch effects is to
normalize the data from each batch to a control group present in all of
the experiments. To use this function, provide such a data table,
identify the column holding the experimental group data, the identity of
the control group to normalize by, the column holding the batch data,
and the column holding the numerical data to normalize. Also select the
function to average by (mean or median). The function will return the
data table with three new columns: the average of the control group by
batch, fold change of each observation relative to the batch average and
the log2-transformed fold change. This function is pipe-friendly.

## Usage

``` r
normalize_batch(
  data,
  group_col,
  norm_group,
  batch_col,
  data_col,
  fun = c("mean", "median")
)
```

## Arguments

- data:

  a tibble

- group_col:

  the column containing the experimental group identifier

- norm_group:

  the experimental group you want to normalize to across batches

- batch_col:

  the column containing the batch identifier

- data_col:

  the column with your data

- fun:

  averaging function to use, Default: c("mean", "median")

## Value

A tibble with new columns indicating batch normalization group average,
fold change for each observation relative to the batch average and log2
fold change

## See also

[`arg_match`](https://rlang.r-lib.org/reference/arg_match.html)
[`cli_abort`](https://cli.r-lib.org/reference/cli_abort.html)
[`filter`](https://dplyr.tidyverse.org/reference/filter.html),
[`group_by`](https://dplyr.tidyverse.org/reference/group_by.html),
[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html),
[`select`](https://dplyr.tidyverse.org/reference/select.html),
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html)
