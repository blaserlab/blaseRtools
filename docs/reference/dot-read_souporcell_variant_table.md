# Read Souporcell variant table

Internal helper for reading `common_variants_covered_tmp.vcf`, which is
expected to be a tab-delimited VCF-like file in the same order as the
variant dimension of `alt.mtx` and `ref.mtx`.

## Usage

``` r
.read_souporcell_variant_table(
  variant_file,
  n_variants,
  variant_name_style = c("chr_pos_ref_alt", "chr_pos", "id"),
  snp_prefix = "SNP_"
)
```

## Arguments

- variant_file:

  Character scalar. Variant table path.

- n_variants:

  Integer scalar. Expected number of variants.

- variant_name_style:

  Character scalar. Naming style.

- snp_prefix:

  Character scalar. Fallback SNP prefix.

## Value

A tibble with one row per variant.
