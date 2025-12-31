# Generate a CDS from Bulk RNA-seq data

This function allows you to simulate single cell data from bulk RNA-seq
data. It requires a TPM count matrix. The rationale is that TPM
quantifies transcript counts per million reads, so you can think of this
like 1 million UMI counts from a scRNA-seq experiment distributed in a
certain way across the transcriptome. This function samples
*n_pseudocells* with *transcripts_per_pseudocell* from this
distribution. Then it creates a cell data set based on a matrix of these
samples.

Importantly, this function cannot accurately identify transcriptional
heterogenity within the bulk data. The sampling effect may reveal some
potential heterogeneity but there is no method here for determining
whether this is due to randomness or heterogeneity within the data.

The intended use of this function is to project a pseudocell cds onto an
actual single cell data set. This can be used to help identify regions
of UMAP space that are shared between the pseudocells and the real
cells.

Note: The matrix rownames and row metadata for the returned cds will
contain only the rownames from the input tpm_matrix. So these should
share the same namespace as the single cell cds that the pseudocell data
will be projected onto.

## Usage

``` r
bb_pseudocells(
  tpm_matrix,
  n_pseudocells,
  transcripts_per_pseudocell,
  remove_genes = NULL
)
```

## Arguments

- tpm_matrix:

  A matrix of TPM counts from a bulk RNA experiment. A cds will be
  generated for each column in this matrix and the result combined.

- n_pseudocells:

  The number of pseudocells to create. Should be length 1 or to specify
  a uniqe n_pseudocells for each dataset, a vector of the same length as
  the number of columns in tpm_matrix. This value will be recycled if
  necessary to match the number of columns in tpm_mtx.

- transcripts_per_pseudocell:

  The number of transcripts to sample for each pseudocell. Should be
  similar to the median number of UMI in the single cell data the
  pseudocells will be projected onto. Should be length 1 or to specify a
  uniqe n_pseudocells for each dataset, a vector of the same length as
  the number of columns in tpm_matrix. This value will be recycled if
  necessary to match the number of columns in tpm_mtx.

- remove_genes:

  A vector of genes to remove before sampling. Should be the same or
  similar to the genes removed from the single cell data the pseudocells
  will be projected onto, Default: NULL

## Value

A cell data set

## See also

[`map`](https://purrr.tidyverse.org/reference/map.html),
[`reduce`](https://purrr.tidyverse.org/reference/reduce.html),
[`map2`](https://purrr.tidyverse.org/reference/map2.html),
[`pmap`](https://purrr.tidyverse.org/reference/pmap.html)
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
[`count`](https://dplyr.tidyverse.org/reference/count.html),
[`select`](https://dplyr.tidyverse.org/reference/select.html)
[`components`](https://generics.r-lib.org/reference/components.html)
[`new_cell_data_set`](https://rdrr.io/pkg/monocle3/man/new_cell_data_set.html),
[`combine_cds`](https://rdrr.io/pkg/monocle3/man/combine_cds.html),
[`preprocess_cds`](https://rdrr.io/pkg/monocle3/man/preprocess_cds.html),
[`reduce_dimension`](https://rdrr.io/pkg/monocle3/man/reduce_dimension.html)

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 #EXAMPLE1
 }
} # }
```
