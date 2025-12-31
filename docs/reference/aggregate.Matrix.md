# Compute summary statistics of a Matrix

Similar to [`aggregate`](https://rdrr.io/r/stats/aggregate.html). Splits
the matrix into groups as specified by groupings, which can be one or
more variables. Aggregation function will be applied to all columns in
data, or as specified in formula. Warning: groupings will be made dense
if it is sparse, though data will not.

## Usage

``` r
# S3 method for class 'Matrix'
aggregate(x, groupings = NULL, form = NULL, fun = "sum", ...)
```

## Arguments

- x:

  a `Matrix` or matrix-like object

- groupings:

  an object coercible to a group of factors defining the groups

- form:

  [`formula`](https://rdrr.io/r/stats/formula.html)

- fun:

  character string specifying the name of aggregation function to be
  applied to all columns in data. Currently "sum", "count", and "mean"
  are supported.

- ...:

  arguments to be passed to or from methods. Currently ignored

## Value

A sparse `Matrix`. The rownames correspond to the values of the
groupings or the interactions of groupings joined by a `_`.

There is an attribute `crosswalk` that includes the groupings as a data
frame. This is necessary because it is not possible to include character
or data frame groupings in a sparse Matrix. If needed, one can
`cbind(attr(x,"crosswalk"),x)` to combine the groupings and the
aggregates.

## Details

`aggregate.Matrix` uses its own implementations of functions and should
be passed a string in the `fun` argument.

## See also

[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)

[`summarise`](https://rdrr.io/pkg/plyr/man/summarise.html)

[`aggregate`](https://rdrr.io/r/stats/aggregate.html)
