#' Make a Copy of Image Files and Rename With File Hashes in Blinded Folder
#'
#' @description Will copy and rename the files and generate two files:
#' "blinding_key.csv" with the original and blinded file names, and
#' "scoresheet.csv" with just the blinded filenames. Add columns as needed
#' to scoresheet, for example, runx_count. Then run bb_unblind to rejoin
#' scoresheet to the key and generate an unblinded result file.
#'
#' @param analysis_file The analysis file for the experiment. It should contain
#'   1 line for every biological sample and should have a filename for every
#'   file to be blinded.
#' @param file_column The column name (substring match) in the analysis_file
#'   with the files to be blinded.
#' @param output_dir The linux-style file path for the directory that will hold
#'   the blinded images. The directory will be created by the function.
#' @return nothing
#' @export
#'
#' @importFrom stringr str_replace_all str_sub
#' @importFrom fs path dir_create path_file path_ext file_copy file_exists
#' @importFrom dplyr mutate across select pull filter arrange everything
#' @importFrom tidyr pivot_longer
#' @importFrom tidyselect contains
#' @importFrom digest digest
#' @importFrom tibble tibble
#' @importFrom readr write_csv
bb_blind_images <- function(analysis_file, file_column, output_dir) {
  # Timestamp suffix (digits only)
  ts <- stringr::str_replace_all(Sys.time(), "[:punct:]|[:alpha:]|[:space:]", "")
  output_dir <- fs::path(paste0(output_dir, "_", ts))
  fs::dir_create(path = output_dir)

  # Normalize file paths in-place for any matching columns
  analysis_file <- analysis_file |>
    dplyr::mutate(dplyr::across(tidyselect::contains(file_column), bb_fix_file_path))

  # Collect all file paths across matching columns (robust to multiple cols)
  filepaths <- analysis_file |>
    dplyr::select(tidyselect::contains(file_column)) |>
    tidyr::pivot_longer(cols = dplyr::everything(), values_to = "filepaths") |>
    dplyr::pull(filepaths)

  # Final cleanup: fix path format, drop blanks, de-dup
  filepaths <- bb_fix_file_path(filepaths)
  filepaths <- filepaths[!is.na(filepaths) & nzchar(filepaths)]
  filepaths <- unique(filepaths)

  if (length(filepaths) == 0) {
    stop("No file paths found in columns matching: ", file_column, call. = FALSE)
  }

  # Optional: fail early if any source files are missing
  missing <- filepaths[!fs::file_exists(filepaths)]
  if (length(missing) > 0) {
    stop(
      "Some source files do not exist:\n- ",
      paste(missing, collapse = "\n- "),
      call. = FALSE
    )
  }

  # Build key (fast word lookup; collision-resistant names)
  n_words <- nrow(blaseRdata::wordhash)
  ok_ext <- c("tif", "tiff", "jpeg", "jpg", "png")

  blinding_key <- purrr::map_dfr(
    .x = filepaths,
    .f = function(x, out = output_dir) {
      ext <- tolower(fs::path_ext(x))
      if (!ext %in% ok_ext) {
        stop("Unsupported image extension for file: ", x, call. = FALSE)
      }
      extension <- paste0(".", ext)

      # hash file contents
      hash <- digest::digest(x, algo = "md5", file = TRUE)
      hash_short <- stringr::str_sub(hash, end = 6)

      # map into word list (1-based)
      hash_int <- strtoi(paste0("0x", hash_short))
      idx <- (hash_int %% n_words) + 1L
      word <- blaseRdata::wordhash$word[idx]

      tibble::tibble(
        source_file  = x,
        blinded_file = fs::path(out, paste0(word, "_", hash_short, extension))
      )
    }
  )

  # Guardrail: ensure no duplicate blinded output paths
  dup <- blinding_key$blinded_file[duplicated(blinding_key$blinded_file)]
  if (length(dup) > 0) {
    stop(
      "Duplicate blinded_file paths generated:\n- ",
      paste(unique(dup), collapse = "\n- "),
      call. = FALSE
    )
  }

  # Copy files
  fs::file_copy(
    path = blinding_key$source_file,
    new_path = blinding_key$blinded_file,
    overwrite = FALSE
  )

  # Write scoresheet + key
  scoresheet <- blinding_key |>
    dplyr::select(-source_file) |>
    dplyr::arrange(blinded_file)

  readr::write_csv(blinding_key, file = fs::path(output_dir, "blinding_key.csv"))
  readr::write_csv(scoresheet,  file = fs::path(output_dir, "scoresheet.csv"))

  invisible(NULL)
}
