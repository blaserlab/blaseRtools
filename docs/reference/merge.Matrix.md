# Merges two Matrices or matrix-like objects

Implementation of [`merge`](https://rdrr.io/r/base/merge.html) for
`Matrix`. By explicitly calling `merge.Matrix` it will also work for
`matrix`, for `data.frame`, and `vector` objects as a much faster
alternative to the built-in `merge`.

## Usage

``` r
merge.Matrix(
  x,
  y,
  by.x,
  by.y,
  all.x = TRUE,
  all.y = TRUE,
  out.class = class(x)[1],
  fill.x = ifelse(is(x, "sparseMatrix"), FALSE, NA),
  fill.y = fill.x,
  ...
)

join.Matrix(
  x,
  y,
  by.x,
  by.y,
  all.x = TRUE,
  all.y = TRUE,
  out.class = class(x)[1],
  fill.x = ifelse(is(x, "sparseMatrix"), FALSE, NA),
  fill.y = fill.x,
  ...
)
```

## Arguments

- x, y:

  `Matrix` or matrix-like object

- by.x:

  vector indicating the names to match from `Matrix` x

- by.y:

  vector indicating the names to match from `Matrix` y

- all.x:

  logical; if `TRUE`, then each value in `x` will be included even if it
  has no matching values in `y`

- all.y:

  logical; if `TRUE`, then each value in `y` will be included even if it
  has no matching values in `x`

- out.class:

  the class of the output object. Defaults to the class of x. Note that
  some output classes are not possible due to R coercion capabilities,
  such as converting a character matrix to a Matrix.

- fill.x, fill.y:

  the value to put in merged columns where there is no match. Defaults
  to 0/FALSE for sparse matrices in order to preserve sparsity, NA for
  all other classes

- ...:

  arguments to be passed to or from methods. Currently ignored

## Details

\#' `all.x/all.y` correspond to the four types of database joins in the
following way:

- left:

  `all.x=TRUE`, `all.y=FALSE`

- right:

  `all.x=FALSE`, `all.y=TRUE`

- inner:

  `all.x=FALSE`, `all.y=FALSE`

- full:

  `all.x=TRUE`, `all.y=TRUE`

Note that `NA` values will match other `NA` values.
