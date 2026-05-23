# Build a Souporcell genotype-by-SNP allele-fraction matrix

Reads standard Souporcell output files and aggregates
reference/alternate allele counts across cells assigned to each
Souporcell genotype. The returned matrix is designed for
genotype-demultiplexing QC plots, especially heatmaps showing whether
inferred genetic IDs have distinct SNP allele profiles.

## Usage

``` r
bb_souporcell_matrix(
  souporcell_dir,
  return = c("continuous", "discrete"),
  orientation = c("snps_by_genotypes", "genotypes_by_snps"),
  variant_file = NULL,
  use_variant_names = TRUE,
  variant_name_style = c("chr_pos_ref_alt", "chr_pos", "id"),
  status_keep = "singlet",
  assignment_col = "assignment",
  status_col = "status",
  min_total_reads = 10,
  min_genotype_coverage = 0.7,
  require_finite = TRUE,
  min_range = 0.35,
  min_sd = 0.12,
  ref_threshold = 0.2,
  alt_threshold = 0.8,
  require_ref_like = 1L,
  require_alt_like = 1L,
  top_n = 75L,
  discrete_values = c(ref = 0, het = 0.5, alt = 1),
  genotype_prefix = "ID_",
  snp_prefix = "SNP_",
  sort_genotypes = TRUE,
  verbose = TRUE,
  return_metadata = FALSE
)
```

## Arguments

- souporcell_dir:

  Character scalar. Path to a Souporcell output directory, for example
  `"results/g_pos_1/souporcell/K15"`.

- return:

  Character scalar. One of `"continuous"` or `"discrete"`.
  `"continuous"` returns aggregate alternate allele fractions.
  `"discrete"` returns genotype-like binned values.

- orientation:

  Character scalar. One of `"snps_by_genotypes"` or
  `"genotypes_by_snps"`. The default returns SNPs as rows and Souporcell
  genotype IDs as columns.

- variant_file:

  Character scalar or `NULL`. Path to the variant file used for
  `alt.mtx` / `ref.mtx` column order. If `NULL`, the function looks for
  `common_variants_covered_tmp.vcf` in `souporcell_dir`.

- use_variant_names:

  Logical scalar. If `TRUE`, use variant coordinates from `variant_file`
  as SNP names.

- variant_name_style:

  Character scalar. One of `"chr_pos_ref_alt"`, `"chr_pos"`, or `"id"`.

- status_keep:

  Character vector. Cell statuses from `clusters.tsv` to include.
  Default is `"singlet"`.

- assignment_col:

  Character scalar. Column in `clusters.tsv` containing Souporcell
  genotype assignments. Default is `"assignment"`.

- status_col:

  Character scalar. Column in `clusters.tsv` containing cell status.
  Default is `"status"`.

- min_total_reads:

  Numeric scalar. Minimum aggregate read depth required for a
  genotype/SNP pair. Values below this are set to `NA` before SNP
  filtering.

- min_genotype_coverage:

  Numeric scalar between 0 and 1. Fraction of genotype IDs that must
  have adequate coverage for a SNP to be retained.

- require_finite:

  Logical scalar. If `TRUE`, remove SNPs with any remaining non-finite
  values after coverage filtering. Recommended for heatmap clustering.

- min_range:

  Numeric scalar. Minimum ALT allele-fraction range across genotype IDs
  required for a SNP to be retained.

- min_sd:

  Numeric scalar. Minimum ALT allele-fraction standard deviation across
  genotype IDs required for a SNP to be retained.

- ref_threshold:

  Numeric scalar. ALT allele fractions less than or equal to this value
  are considered reference-like.

- alt_threshold:

  Numeric scalar. ALT allele fractions greater than or equal to this
  value are considered alternate-like.

- require_ref_like:

  Integer scalar. Minimum number of genotype IDs that must be
  reference-like for a SNP to be retained.

- require_alt_like:

  Integer scalar. Minimum number of genotype IDs that must be
  alternate-like for a SNP to be retained.

- top_n:

  Integer scalar or `NULL`. If non-`NULL`, keep only the top `top_n`
  SNPs ranked by allele-fraction range and then standard deviation.

- discrete_values:

  Numeric vector of length 3. Values used for reference-like,
  intermediate/heterozygous-like, and alternate-like states when
  `return = "discrete"`.

- genotype_prefix:

  Character scalar. Prefix for genotype names.

- snp_prefix:

  Character scalar. Prefix for fallback SNP names when no usable variant
  label is available.

- sort_genotypes:

  Logical scalar. If `TRUE`, sort genotype IDs numerically when
  possible.

- verbose:

  Logical scalar. If `TRUE`, print filtering summaries.

- return_metadata:

  Logical scalar. If `TRUE`, return a list containing the matrix and
  intermediate summary tables. If `FALSE`, return only the matrix.

## Value

If `return_metadata = FALSE`, a numeric matrix. By default, rows are
SNPs and columns are Souporcell genotype IDs. If
`return_metadata = TRUE`, a list with elements `matrix`, `snp_summary`,
`variant_table`, `alt_by_genotype`, `ref_by_genotype`,
`depth_by_genotype`, `allele_fraction_by_genotype`, and `clusters`.

## Details

The function expects a Souporcell output directory containing `alt.mtx`,
`ref.mtx`, and `clusters.tsv`. If present,
`common_variants_covered_tmp.vcf` is used to label SNPs with genomic
coordinates and alleles.

## Examples

``` r
mat <- build_souporcell_genotype_matrix(
  souporcell_dir = "results/g_pos_1/souporcell/K15",
  return = "discrete",
  orientation = "snps_by_genotypes",
  top_n = 75
)
#> Error in build_souporcell_genotype_matrix(souporcell_dir = "results/g_pos_1/souporcell/K15",     return = "discrete", orientation = "snps_by_genotypes", top_n = 75): could not find function "build_souporcell_genotype_matrix"

pheatmap::pheatmap(
  mat,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE
)
#> Error: object 'mat' not found
```
