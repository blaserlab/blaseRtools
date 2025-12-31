# A helper function to generate a data frame in the proper form for aggregate expression plotting with bb_gene_umap.

Use as argument for the "gene_or_genes" parameter for bb_gene_umap.

## Usage

``` r
bb_plot_rowData_col(cds, rowData_col, filter_in = NULL, filter_out = NULL)
```

## Arguments

- cds:

  CDS from which to extract the gene metadata. Should be the same cds as
  the enclosing function.

- rowData_col:

  Gene metadata column to aggregate by.

- filter_in:

  Subset of values to focus on. Each will become a facet in the final
  plot. Default is to keep everything except NA values.

- filter_out:

  Option to filter out any unwanted values. Default is to not filter out
  anything.

## Value

A data frame in the format needed to pass into bb_gene_umap.
