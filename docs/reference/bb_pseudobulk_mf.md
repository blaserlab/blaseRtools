# Run Multifactor Pseudobulk Analysis using Deseq2

Use this function to perform Pseudbulk DGE analysis.

## Usage

``` r
bb_pseudobulk_mf(
  cds,
  pseudosample_table,
  design_formula,
  count_filter = 10,
  result_recipe = "default",
  test = "Wald",
  reduced = NULL
)
```

## Arguments

- cds:

  The cell data set object subset to analyze

- pseudosample_table:

  A tibble indicating the sample groupings for analysis. This should
  include 1.) Unique sample identifiers 2.) Any sample-level cell
  metadata you wish to include in the regression model and 3.) Any
  Cell-level metadata you may wish to include such as clusters or
  partitions. Values will be coerced to factors.

- design_formula:

  The regression-style formula for the analysis. In the form of "~
  variable1 + variable2 + ... final_variable". The default behavior is
  to calculate results according to the final_variable in the
  design_formula with preceding variables as co-variates. The reference
  class is chosen according to alphabetical order. This behavior can be
  modified by specifying the result_recipe argument.

- count_filter:

  The minimum number of counts required across all pseudosamples in
  order to keep a gene in the analysis.

- result_recipe:

  See above for the default recipe. Alternatively, supply a 3-element
  vector in the form of c("variable",
  "experimental_level","reference_or_control_level")

## Value

A list of results from pseudobulk analysis
