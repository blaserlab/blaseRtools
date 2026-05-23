#' Build a Souporcell genotype-by-SNP allele-fraction matrix
#'
#' Reads standard Souporcell output files and aggregates reference/alternate
#' allele counts across cells assigned to each Souporcell genotype. The returned
#' matrix is designed for genotype-demultiplexing QC plots, especially heatmaps
#' showing whether inferred genetic IDs have distinct SNP allele profiles.
#'
#' The function expects a Souporcell output directory containing `alt.mtx`,
#' `ref.mtx`, and `clusters.tsv`. If present, `common_variants_covered_tmp.vcf`
#' is used to label SNPs with genomic coordinates and alleles.
#'
#' @param souporcell_dir Character scalar. Path to a Souporcell output directory,
#'   for example `"results/g_pos_1/souporcell/K15"`.
#' @param return Character scalar. One of `"continuous"` or `"discrete"`.
#'   `"continuous"` returns aggregate alternate allele fractions. `"discrete"`
#'   returns genotype-like binned values.
#' @param orientation Character scalar. One of `"snps_by_genotypes"` or
#'   `"genotypes_by_snps"`. The default returns SNPs as rows and Souporcell
#'   genotype IDs as columns.
#' @param variant_file Character scalar or `NULL`. Path to the variant file used
#'   for `alt.mtx` / `ref.mtx` column order. If `NULL`, the function looks for
#'   `common_variants_covered_tmp.vcf` in `souporcell_dir`.
#' @param use_variant_names Logical scalar. If `TRUE`, use variant coordinates
#'   from `variant_file` as SNP names.
#' @param variant_name_style Character scalar. One of `"chr_pos_ref_alt"`,
#'   `"chr_pos"`, or `"id"`.
#' @param status_keep Character vector. Cell statuses from `clusters.tsv` to
#'   include. Default is `"singlet"`.
#' @param assignment_col Character scalar. Column in `clusters.tsv` containing
#'   Souporcell genotype assignments. Default is `"assignment"`.
#' @param status_col Character scalar. Column in `clusters.tsv` containing cell
#'   status. Default is `"status"`.
#' @param min_total_reads Numeric scalar. Minimum aggregate read depth required
#'   for a genotype/SNP pair. Values below this are set to `NA` before SNP
#'   filtering.
#' @param min_genotype_coverage Numeric scalar between 0 and 1. Fraction of
#'   genotype IDs that must have adequate coverage for a SNP to be retained.
#' @param require_finite Logical scalar. If `TRUE`, remove SNPs with any
#'   remaining non-finite values after coverage filtering. Recommended for
#'   heatmap clustering.
#' @param min_range Numeric scalar. Minimum ALT allele-fraction range across
#'   genotype IDs required for a SNP to be retained.
#' @param min_sd Numeric scalar. Minimum ALT allele-fraction standard deviation
#'   across genotype IDs required for a SNP to be retained.
#' @param ref_threshold Numeric scalar. ALT allele fractions less than or equal
#'   to this value are considered reference-like.
#' @param alt_threshold Numeric scalar. ALT allele fractions greater than or
#'   equal to this value are considered alternate-like.
#' @param require_ref_like Integer scalar. Minimum number of genotype IDs that
#'   must be reference-like for a SNP to be retained.
#' @param require_alt_like Integer scalar. Minimum number of genotype IDs that
#'   must be alternate-like for a SNP to be retained.
#' @param top_n Integer scalar or `NULL`. If non-`NULL`, keep only the top
#'   `top_n` SNPs ranked by allele-fraction range and then standard deviation.
#' @param discrete_values Numeric vector of length 3. Values used for
#'   reference-like, intermediate/heterozygous-like, and alternate-like states
#'   when `return = "discrete"`.
#' @param genotype_prefix Character scalar. Prefix for genotype names.
#' @param snp_prefix Character scalar. Prefix for fallback SNP names when no
#'   usable variant label is available.
#' @param sort_genotypes Logical scalar. If `TRUE`, sort genotype IDs
#'   numerically when possible.
#' @param verbose Logical scalar. If `TRUE`, print filtering summaries.
#' @param return_metadata Logical scalar. If `TRUE`, return a list containing the
#'   matrix and intermediate summary tables. If `FALSE`, return only the matrix.
#'
#' @return If `return_metadata = FALSE`, a numeric matrix. By default, rows are
#'   SNPs and columns are Souporcell genotype IDs. If `return_metadata = TRUE`,
#'   a list with elements `matrix`, `snp_summary`, `variant_table`,
#'   `alt_by_genotype`, `ref_by_genotype`, `depth_by_genotype`,
#'   `allele_fraction_by_genotype`, and `clusters`.
#'
#' @examples
#' mat <- build_souporcell_genotype_matrix(
#'   souporcell_dir = "results/g_pos_1/souporcell/K15",
#'   return = "discrete",
#'   orientation = "snps_by_genotypes",
#'   top_n = 75
#' )
#'
#' pheatmap::pheatmap(
#'   mat,
#'   cluster_rows = TRUE,
#'   cluster_cols = TRUE,
#'   show_rownames = FALSE
#' )
#'
#' @importFrom Matrix readMM colSums t
#' @importFrom readr read_tsv cols col_character
#' @importFrom tibble tibble
#' @importFrom dplyr arrange desc mutate
#' @export
bb_souporcell_matrix <- function(
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
    ref_threshold = 0.20,
    alt_threshold = 0.80,
    require_ref_like = 1L,
    require_alt_like = 1L,
    top_n = 75L,
    discrete_values = c(ref = 0, het = 0.5, alt = 1),
    genotype_prefix = "ID_",
    snp_prefix = "SNP_",
    sort_genotypes = TRUE,
    verbose = TRUE,
    return_metadata = FALSE
) {
  return <- match.arg(return)
  orientation <- match.arg(orientation)
  variant_name_style <- match.arg(variant_name_style)

  if (!is.character(souporcell_dir) || length(souporcell_dir) != 1) {
    stop("`souporcell_dir` must be a character scalar.", call. = FALSE)
  }

  souporcell_dir <- path.expand(souporcell_dir)

  if (!dir.exists(souporcell_dir)) {
    stop("`souporcell_dir` does not exist: ", souporcell_dir, call. = FALSE)
  }

  if (is.null(variant_file)) {
    candidate_variant_file <- file.path(souporcell_dir, "common_variants_covered_tmp.vcf")
    if (file.exists(candidate_variant_file)) {
      variant_file <- candidate_variant_file
    }
  } else {
    variant_file <- path.expand(variant_file)
  }

  if (!is.numeric(min_genotype_coverage) ||
      length(min_genotype_coverage) != 1 ||
      min_genotype_coverage <= 0 ||
      min_genotype_coverage > 1) {
    stop("`min_genotype_coverage` must be a number > 0 and <= 1.", call. = FALSE)
  }

  if (!is.numeric(discrete_values) || length(discrete_values) != 3) {
    stop("`discrete_values` must be a numeric vector of length 3.", call. = FALSE)
  }

  if (ref_threshold >= alt_threshold) {
    stop("`ref_threshold` must be less than `alt_threshold`.", call. = FALSE)
  }

  alt_file <- file.path(souporcell_dir, "alt.mtx")
  ref_file <- file.path(souporcell_dir, "ref.mtx")
  clusters_file <- file.path(souporcell_dir, "clusters.tsv")

  missing_files <- c(alt_file, ref_file, clusters_file)[
    !file.exists(c(alt_file, ref_file, clusters_file))
  ]

  if (length(missing_files) > 0) {
    stop(
      "Missing required Souporcell output file(s):\n",
      paste(missing_files, collapse = "\n"),
      call. = FALSE
    )
  }

  alt <- Matrix::readMM(alt_file)
  ref <- Matrix::readMM(ref_file)

  clusters <- readr::read_tsv(
    clusters_file,
    show_col_types = FALSE
  )

  if (!status_col %in% names(clusters)) {
    stop("`status_col` not found in clusters.tsv: ", status_col, call. = FALSE)
  }

  if (!assignment_col %in% names(clusters)) {
    stop("`assignment_col` not found in clusters.tsv: ", assignment_col, call. = FALSE)
  }

  n_cells <- nrow(clusters)

  # Orient matrices as cells x variants.
  if (ncol(alt) == n_cells && ncol(ref) == n_cells) {
    alt <- Matrix::t(alt)
    ref <- Matrix::t(ref)
  } else if (nrow(alt) == n_cells && nrow(ref) == n_cells) {
    # Already cells x variants.
  } else {
    stop(
      "Could not orient alt/ref matrices relative to clusters.tsv. ",
      "alt dimensions: ", paste(dim(alt), collapse = " x "),
      "; ref dimensions: ", paste(dim(ref), collapse = " x "),
      "; clusters rows: ", n_cells, ".",
      call. = FALSE
    )
  }

  n_variants <- ncol(alt)

  variant_table <- NULL

  if (isTRUE(use_variant_names) && !is.null(variant_file) && file.exists(variant_file)) {
    variant_table <- .read_souporcell_variant_table(
      variant_file = variant_file,
      n_variants = n_variants,
      variant_name_style = variant_name_style,
      snp_prefix = snp_prefix
    )
  } else if (isTRUE(use_variant_names) && verbose) {
    message(
      "No variant file found. Using fallback SNP names. Expected: ",
      file.path(souporcell_dir, "common_variants_covered_tmp.vcf")
    )
  }

  keep_cells <- clusters[[status_col]] %in% status_keep

  if (!any(keep_cells)) {
    stop(
      "No cells matched `status_keep`: ",
      paste(status_keep, collapse = ", "),
      call. = FALSE
    )
  }

  keep_idx <- which(keep_cells)
  grp <- as.character(clusters[[assignment_col]][keep_idx])

  valid_assignment <- !is.na(grp) & grp != "" & grp != "NA"

  keep_idx <- keep_idx[valid_assignment]
  grp <- grp[valid_assignment]

  if (length(grp) == 0) {
    stop("No retained cells had valid Souporcell assignments.", call. = FALSE)
  }

  alt_s <- alt[keep_idx, , drop = FALSE]
  ref_s <- ref[keep_idx, , drop = FALSE]

  cluster_ids <- unique(grp)

  if (sort_genotypes) {
    cluster_ids_num <- suppressWarnings(as.numeric(cluster_ids))
    if (all(!is.na(cluster_ids_num))) {
      cluster_ids <- cluster_ids[order(cluster_ids_num)]
    } else {
      cluster_ids <- sort(cluster_ids)
    }
  }

  alt_by_genotype <- do.call(
    rbind,
    lapply(cluster_ids, function(g) {
      Matrix::colSums(alt_s[grp == g, , drop = FALSE])
    })
  )

  ref_by_genotype <- do.call(
    rbind,
    lapply(cluster_ids, function(g) {
      Matrix::colSums(ref_s[grp == g, , drop = FALSE])
    })
  )

  genotype_names <- paste0(genotype_prefix, cluster_ids)

  rownames(alt_by_genotype) <- genotype_names
  rownames(ref_by_genotype) <- genotype_names

  depth_by_genotype <- alt_by_genotype + ref_by_genotype

  allele_fraction <- alt_by_genotype / depth_by_genotype
  allele_fraction[depth_by_genotype < min_total_reads] <- NA_real_

  plot_mat <- as.matrix(allele_fraction)

  min_n_genotypes <- ceiling(min_genotype_coverage * nrow(plot_mat))

  covered_genotypes <- colSums(!is.na(plot_mat))
  keep_covered <- covered_genotypes >= min_n_genotypes

  if (!any(keep_covered)) {
    stop(
      "No SNPs retained after genotype coverage filtering. ",
      "Try lowering `min_total_reads` or `min_genotype_coverage`.",
      call. = FALSE
    )
  }

  plot_mat <- plot_mat[, keep_covered, drop = FALSE]
  current_original_idx <- which(keep_covered)

  if (require_finite) {
    keep_finite <- apply(plot_mat, 2, function(x) all(is.finite(x)))

    if (!any(keep_finite)) {
      stop(
        "No SNPs retained after finite-value filtering. ",
        "Try setting `require_finite = FALSE` or lowering coverage filters.",
        call. = FALSE
      )
    }

    plot_mat <- plot_mat[, keep_finite, drop = FALSE]
    current_original_idx <- current_original_idx[keep_finite]
  }

  snp_summary <- tibble::tibble(
    current_col = seq_len(ncol(plot_mat)),
    snp_original_index = current_original_idx,
    mean_af = apply(plot_mat, 2, mean, na.rm = TRUE),
    sd_af = apply(plot_mat, 2, stats::sd, na.rm = TRUE),
    range_af = apply(plot_mat, 2, function(x) diff(range(x, na.rm = TRUE))),
    min_af = apply(plot_mat, 2, min, na.rm = TRUE),
    max_af = apply(plot_mat, 2, max, na.rm = TRUE),
    n_ref_like = apply(
      plot_mat,
      2,
      function(x) sum(x <= ref_threshold, na.rm = TRUE)
    ),
    n_het_like = apply(
      plot_mat,
      2,
      function(x) sum(x > ref_threshold & x < alt_threshold, na.rm = TRUE)
    ),
    n_alt_like = apply(
      plot_mat,
      2,
      function(x) sum(x >= alt_threshold, na.rm = TRUE)
    )
  )

  if (!is.null(variant_table)) {
    snp_summary <- merge(
      snp_summary,
      variant_table,
      by = "snp_original_index",
      all.x = TRUE,
      sort = FALSE
    )

    snp_summary <- snp_summary[order(snp_summary$current_col), , drop = FALSE]
  }

  keep_informative <- is.finite(snp_summary$range_af) &
    is.finite(snp_summary$sd_af) &
    snp_summary$range_af >= min_range &
    snp_summary$sd_af >= min_sd &
    snp_summary$n_ref_like >= require_ref_like &
    snp_summary$n_alt_like >= require_alt_like

  if (!any(keep_informative)) {
    stop(
      "No SNPs retained after informativeness filtering. ",
      "Try lowering `min_range`, `min_sd`, `require_ref_like`, or ",
      "`require_alt_like`.",
      call. = FALSE
    )
  }

  plot_mat <- plot_mat[, keep_informative, drop = FALSE]
  snp_summary <- snp_summary[keep_informative, , drop = FALSE]

  rank_df <- snp_summary |>
    dplyr::mutate(filtered_col = seq_len(dplyr::n())) |>
    dplyr::arrange(dplyr::desc(.data$range_af), dplyr::desc(.data$sd_af))

  if (!is.null(top_n)) {
    top_n <- min(as.integer(top_n), nrow(rank_df))
    rank_df <- rank_df[seq_len(top_n), , drop = FALSE]
  }

  plot_mat <- plot_mat[, rank_df$filtered_col, drop = FALSE]
  snp_summary <- snp_summary[rank_df$filtered_col, , drop = FALSE]

  if (!is.null(variant_table) && "variant_label" %in% names(snp_summary)) {
    snp_names <- snp_summary$variant_label
    snp_names[is.na(snp_names) | snp_names == ""] <-
      paste0(snp_prefix, snp_summary$snp_original_index[is.na(snp_names) | snp_names == ""])
    snp_names <- make.unique(snp_names)
  } else {
    snp_names <- paste0(snp_prefix, seq_len(ncol(plot_mat)))
  }

  colnames(plot_mat) <- snp_names
  snp_summary$snp_id <- snp_names

  if (return == "discrete") {
    out_mat <- plot_mat

    ref_like <- out_mat <= ref_threshold
    alt_like <- out_mat >= alt_threshold
    het_like <- out_mat > ref_threshold & out_mat < alt_threshold

    out_mat[ref_like] <- discrete_values[[1]]
    out_mat[het_like] <- discrete_values[[2]]
    out_mat[alt_like] <- discrete_values[[3]]
  } else {
    out_mat <- plot_mat
  }

  # Default final output: SNPs x genotypes.
  if (orientation == "snps_by_genotypes") {
    out_mat <- t(out_mat)
  }

  if (verbose) {
    message("Souporcell directory: ", souporcell_dir)
    message("Retained cells: ", length(grp))
    message("Retained genotype IDs: ", length(cluster_ids))
    message("Matrix variant count: ", n_variants)
    if (!is.null(variant_table)) {
      message("Variant labels loaded: ", nrow(variant_table))
    }
    message("SNPs after coverage filter: ", sum(keep_covered))
    if (require_finite) {
      message("SNPs after finite filter: ", length(current_original_idx))
    }
    message("Informative SNPs returned: ", ifelse(
      orientation == "snps_by_genotypes",
      nrow(out_mat),
      ncol(out_mat)
    ))
  }

  if (return_metadata) {
    return(
      list(
        matrix = out_mat,
        snp_summary = snp_summary,
        variant_table = variant_table,
        alt_by_genotype = alt_by_genotype,
        ref_by_genotype = ref_by_genotype,
        depth_by_genotype = depth_by_genotype,
        allele_fraction_by_genotype = allele_fraction,
        clusters = clusters
      )
    )
  }

  out_mat
}


#' Read Souporcell variant table
#'
#' Internal helper for reading `common_variants_covered_tmp.vcf`, which is
#' expected to be a tab-delimited VCF-like file in the same order as the variant
#' dimension of `alt.mtx` and `ref.mtx`.
#'
#' @param variant_file Character scalar. Variant table path.
#' @param n_variants Integer scalar. Expected number of variants.
#' @param variant_name_style Character scalar. Naming style.
#' @param snp_prefix Character scalar. Fallback SNP prefix.
#'
#' @return A tibble with one row per variant.
#'
#' @keywords internal
.read_souporcell_variant_table <- function(
    variant_file,
    n_variants,
    variant_name_style = c("chr_pos_ref_alt", "chr_pos", "id"),
    snp_prefix = "SNP_"
) {
  variant_name_style <- match.arg(variant_name_style)
  variant_file <- path.expand(variant_file)

  if (!file.exists(variant_file)) {
    stop("Variant file does not exist: ", variant_file, call. = FALSE)
  }

  # Read as TSV without assuming clean VCF headers. Comment lines are skipped.
  variant_table <- readr::read_tsv(
    variant_file,
    comment = "#",
    col_names = FALSE,
    col_types = readr::cols(.default = readr::col_character()),
    show_col_types = FALSE
  )

  if (nrow(variant_table) != n_variants) {
    warning(
      "Variant file row count does not match matrix variant count. ",
      "variant rows = ", nrow(variant_table),
      "; matrix variants = ", n_variants,
      ". SNP labels may not align.",
      call. = FALSE
    )
  }

  if (ncol(variant_table) < 5) {
    stop(
      "Variant file must have at least 5 tab-delimited columns: ",
      "CHROM, POS, ID, REF, ALT.",
      call. = FALSE
    )
  }

  names(variant_table)[seq_len(min(5, ncol(variant_table)))] <-
    c("chrom", "pos", "id", "ref", "alt")[seq_len(min(5, ncol(variant_table)))]

  variant_table <- variant_table |>
    dplyr::mutate(
      snp_original_index = seq_len(dplyr::n()),
      variant_label = dplyr::case_when(
        variant_name_style == "chr_pos_ref_alt" ~ paste0(.data$chrom, ":", .data$pos, "_", .data$ref, ">", .data$alt),
        variant_name_style == "chr_pos" ~ paste0(.data$chrom, ":", .data$pos),
        variant_name_style == "id" & !is.na(.data$id) & .data$id != "." & .data$id != "" ~ .data$id,
        TRUE ~ paste0(snp_prefix, .data$snp_original_index)
      )
    )

  variant_table |>
    dplyr::select(
      "snp_original_index",
      "chrom",
      "pos",
      "id",
      "ref",
      "alt",
      "variant_label"
    )
}
