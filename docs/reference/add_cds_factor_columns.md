# Add predefined sample-level cell metadata to cell data sets while importing

Add predefined sample-level cell metadata to cell data sets while
importing

## Usage

``` r
add_cds_factor_columns(cds, columns_to_add)
```

## Arguments

- cds:

  A cell data set object

- columns_to_add:

  A named vector where the name of each element becomes the name of the
  new colData column and the value is the value for that particular
  sample. Best used when importing from a metadata table.
