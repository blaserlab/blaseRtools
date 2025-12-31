# Print out a stats report

Print out a stats report

## Usage

``` r
bb_print_full_stats(
  data,
  classification_variable,
  numeric_variable,
  test_type = c("Student", "Welch", "Wilcox"),
  output = NULL
)
```

## Arguments

- data:

  A Tibble in tidy data format. Must contain or be filtered to contain
  only 2 levels in "classification_variable" for comparisons.

- classification_variable:

  Column containing the class variable

- numeric_variable:

  The column containing the numeric values to summarize and compare

- test_type:

  Must be one of "Student", "Welch", and "Wilcox"

- output:

  Output file; if null prints to screen.

## Value

A text file
