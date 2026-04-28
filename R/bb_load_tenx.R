#' @title Load a 10X Genomics H5 File and Return a CDS
#' @description This function reads a 10X Genomics H5 file and returns a cell_data_set or CDS.  The option to split citeseq data .
#' @param filename Path to the h5 file.
#' @param sample_metadata_tbl A single row data frame with sample metadata.  Usually this will be filtered from an experiment config file.
#' @param split_citeseq Option to retain citeseq data within the main experiment slot or split it out to an alternate slot.
#' @return A cell data set.
#' @rdname bb_load_tenx_h5
#' @export
#' @importFrom cli cli_abort cli_warn
#' @importFrom hdf5r H5File existsGroup
#' @importFrom Matrix sparseMatrix
#' @importFrom Seurat as.sparse
#' @importFrom monocle3 new_cell_data_set
#' @importFrom SingleCellExperiment mainExpName
bb_load_tenx_h5 <- function (filename,
                             sample_metadata_tbl = NULL,
                             split_citeseq = FALSE) {
  if (!requireNamespace("hdf5r", quietly = TRUE)) {
    cli::cli_abort("Please install hdf5r to read HDF5 files")
  }
  if (!file.exists(filename)) {
    cli::cli_abort("File not found")
  }
  infile <- hdf5r::H5File$new(filename = filename, mode = "r")
  genomes <- names(x = infile)
  output <- list()
  if (hdf5r::existsGroup(infile, "matrix")) {
    feature_slot <- "features/id"
    gene_names <- "features/name"
  } else {
    feature_slot <- "genes"
    gene_names <- "gene_names"
  }
  for (genome in genomes) {
    counts <- infile[[paste0(genome, "/data")]]
    indices <- infile[[paste0(genome, "/indices")]]
    indptr <- infile[[paste0(genome, "/indptr")]]
    shp <- infile[[paste0(genome, "/shape")]]
    features <- infile[[paste0(genome, "/", feature_slot)]][]
    gene_names <- infile[[paste0(genome, "/", gene_names)]][]
    barcodes <- infile[[paste0(genome, "/barcodes")]]
    sparse.mat <- Matrix::sparseMatrix(
      i = indices[] + 1,
      p = indptr[],
      x = as.numeric(x = counts[]),
      dims = shp[],
      repr = "T",
    )
    features <- make.unique(names = features, sep = "__")
    rownames(x = sparse.mat) <- features
    colnames(x = sparse.mat) <- barcodes[]
    sparse.mat <- Seurat::as.sparse(x = sparse.mat)
    if (infile$exists(name = paste0(genome, "/features"))) {
      types <- infile[[paste0(genome, "/features/feature_type")]][]
    }
    barcodes <-
      data.frame(barcode = barcodes[], row.names = barcodes[])
    features <-
      data.frame(
        id = features,
        gene_short_name = gene_names,
        data_type = types,
        row.names = features
      )
    output[[genome]] <-
      list(mat = sparse.mat,
           features = features,
           barcodes = barcodes)
  }
  infile$close_all()

  cds <-
    monocle3::new_cell_data_set(
      expression_data = output$matrix$mat,
      cell_metadata = output$matrix$barcodes,
      gene_metadata =  output$matrix$features
    )
  SingleCellExperiment::mainExpName(cds) <- "Gene Expression"

  if (split_citeseq) {
    if ("Antibody Capture" %in% types) {
    cds <- bb_split_citeseq(cds)
  }  else {
	  cli::cli_warn("No Antibody Data to Analyze.")

    }

  }

  if (!is.null(sample_metadata_tbl)) {
    sample_metadata_expanded <- dplyr::bind_cols(bb_cellmeta(cds), sample_metadata_tbl) |>
      dplyr::select(c(cell_id, matches(colnames(sample_metadata_tbl))))
    cds <- bb_tbl_to_coldata(obj = cds, min_tbl = sample_metadata_expanded)

  }

  return(cds)
}
