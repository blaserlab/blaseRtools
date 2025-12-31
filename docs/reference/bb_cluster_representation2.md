# Cluster Representation By Regression Per Sample

Use this function to determine the differential representation of cells
in clusters. It uses a regression method to determine fold change
between groups of biological samples. It can only compare two sample
groups, e.g. control vs experimental at this point. See parameter
descriptions for how to identify these properly.

## Usage

``` r
bb_cluster_representation2(
  obj,
  sample_var,
  cluster_var,
  comparison_var,
  comparison_levels = NULL,
  color_pal = c("red3", "blue4"),
  sig_val = c("FDR", "PValue"),
  return_val = c("plot", "data")
)
```

## Source

http://bioconductor.org/books/3.13/OSCA.multisample/differential-abundance.html

## Arguments

- obj:

  The (possibly filtered) single cell object to operate on. Can be
  either Seurat or monocle/CDS object.

- sample_var:

  The metadata column holding the biological sample information.

- cluster_var:

  The metadata column holding the clustering or other cell
  classification information.

- comparison_var:

  The metadata column holding the comparison group information. There
  can be only two levels in this column. Character data will be
  converted to factors.

- comparison_levels:

  A character vector identifying the order of the levels to compare. The
  first value will be shown with negative log2Fold Change and the second
  will be positive. If NULL (default), R will pick for you.

- color_pal:

  Color palette for the comparison levels, Default: c("red3", "blue4")

- sig_val:

  Report PValue or FDR, Default: "FDR"

- return_val:

  Value to return, Default: c("plot", "table)

## Value

OUTPUT_DESCRIPTION

## Details

DETAILS
