# Casts or pivots a long `data frame` into a wide sparse matrix

Similar in function to
[`dcast`](https://rdrr.io/pkg/reshape2/man/cast.html), but produces a
sparse `Matrix` as an output. Sparse matrices are beneficial for this
application because such outputs are often very wide and sparse.
Conceptually similar to a `pivot` operation.

## Usage

``` r
dMcast(
  data,
  formula,
  fun.aggregate = "sum",
  value.var = NULL,
  as.factors = FALSE,
  factor.nas = TRUE,
  drop.unused.levels = TRUE
)
```

## Arguments

- data:

  a data frame

- formula:

  casting [`formula`](https://rdrr.io/r/stats/formula.html), see details
  for specifics.

- fun.aggregate:

  name of aggregation function. Defaults to 'sum'

- value.var:

  name of column that stores values to be aggregated numerics

- as.factors:

  if TRUE, treat all columns as factors, including

- factor.nas:

  if TRUE, treat factors with NAs as new levels. Otherwise, rows with
  NAs will receive zeroes in all columns for that factor

- drop.unused.levels:

  should factors have unused levels dropped? Defaults to TRUE, in
  contrast to
  [`model.matrix`](https://rdrr.io/r/stats/model.matrix.html)

## Value

a sparse `Matrix`

## Details

Casting formulas are slightly different than those in `dcast` and follow
the conventions of
[`model.matrix`](https://rdrr.io/r/stats/model.matrix.html). See
[`formula`](https://rdrr.io/r/stats/formula.html) for details. Briefly,
the left hand side of the `~` will be used as the grouping criteria.
This can either be a single variable, or a group of variables linked
using `:`. The right hand side specifies what the columns will be.
Unlike `dcast`, using the `+` operator will append the values for each
variable as additional columns. This is useful for things such as
one-hot encoding. Using `:` will combine the columns as interactions.

## See also

[`cast`](https://rdrr.io/pkg/reshape/man/cast-9g.html)

[`dcast`](https://rdrr.io/pkg/reshape2/man/cast.html)
