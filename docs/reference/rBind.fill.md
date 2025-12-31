# Combine matrixes by row, fill in missing columns

rbinds a list of Matrix or matrix like objects, filling in missing
columns.

## Usage

``` r
rBind.fill(x, ..., fill = NULL, out.class = class(rbind(x, x))[1])
```

## Arguments

- x, ...:

  Objects to combine. If the first argument is a list and `..` is
  unpopulated, the objects in that list will be combined.

- fill:

  value with which to fill unmatched columns

- out.class:

  the class of the output object. Defaults to the class of x. Note that
  some output classes are not possible due to R coercion capabilities,
  such as converting a character matrix to a Matrix.

## Value

a single object of the same class as the first input, or of class
`matrix` if the first object is one dimensional

## Details

Similar to
[`rbind.fill.matrix`](https://rdrr.io/pkg/plyr/man/rbind.fill.matrix.html),
but works for `Matrix` as well as all other R objects. It is completely
agnostic to class, and will produce an object of the class of the first
input (or of class `matrix` if the first object is one dimensional).

The implementation is recursive, so it can handle an arbitrary number of
inputs, albeit inefficiently for large numbers of inputs.

This method is still experimental, but should work in most cases. If the
data sets consist solely of data frames,
[`rbind.fill`](https://rdrr.io/pkg/plyr/man/rbind.fill.html) is
preferred.

## See also

[`rbind.fill`](https://rdrr.io/pkg/plyr/man/rbind.fill.html)

[`rbind.fill.matrix`](https://rdrr.io/pkg/plyr/man/rbind.fill.matrix.html)
