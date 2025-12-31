# An Improved Function to Perform Regression on Single Cell Data.

This function replaces bb_monocle_regression. It returns log2FoldChange
instead of estimates. The log2FoldChange value is the normalized_effect
value returned from the monocle regression functions.

## Usage

``` r
bb_monocle_regression_better(
  cds,
  gene_or_genes,
  stratification_variable = NULL,
  stratification_value = NULL,
  form,
  linking_function = "negbinomial"
)
```

## Arguments

- cds:

  A cell data set object.

- gene_or_genes:

  Genes to regress by.

- stratification_variable:

  Optional colData column to subset the cds by internal to the function.

- stratification_value:

  Optional value to stratify by.

- form:

  The regression formula in the form of "~var1+var2+..."

- linking_function:

  For the generalized linear model.

## Value

A tibble containing the regression results.
