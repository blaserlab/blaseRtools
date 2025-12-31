# Run `link[monocle3]{learn_graph}` on a [`Seurat`](https://satijalab.org/seurat/reference/Seurat-package.html) object

Run `link[monocle3]{learn_graph}` on a
[`Seurat`](https://satijalab.org/seurat/reference/Seurat-package.html)
object

## Usage

``` r
LearnGraph(object, reduction = DefaultDimReduc(object = object), ...)
```

## Arguments

- object:

  A
  [`Seurat`](https://satijalab.org/seurat/reference/Seurat-package.html)
  object

- reduction:

  Name of reduction to use for learning the pseudotime graph

- ...:

  Arguments passed to
  [`learn_graph`](https://rdrr.io/pkg/monocle3/man/learn_graph.html)

## Value

A [`cell_data_set`](https://rdrr.io/pkg/monocle3/man/cell_data_set.html)
object with the pseudotime graph

## See also

[`learn_graph`](https://rdrr.io/pkg/monocle3/man/learn_graph.html)
[`cell_data_set`](https://rdrr.io/pkg/monocle3/man/cell_data_set.html)
