#' @title Import a Big Wig File
#' @description This is a thin wrapper around rtracklayer::import.bw.  The purpose is to serve as a helper function for making Trace objects from bigwig files.  This function converts the name of the numeric value metadata column to "coverage" for consistency with Trace objects made from Seurat/Signac objects.  The numeric column it will look for is "score" by default.  This appears to be the default name applied by import.bw and so this is the default value for this function.  The option is provided to change it if necessary.  The group variable must be supplied.  Typically this will be something informative, like "ATAC" or some Histone mark that the data come from.
#' @param path file path to the bigwig file
#' @param group a label to apply that describes the source data for the track
#' @param coverage_column PARAM_DESCRIPTION, Default: 'score'
#' @return a granges object
#' @rdname bb_import_bw
#' @export
#' @importFrom rtracklayer import.bw
#' @importFrom plyranges mutate select
bb_import_bw <- function(path, group, coverage_column = "score") {
  rtracklayer::import.bw(path) |>
    plyranges::mutate(group = group) |>
    plyranges::mutate(coverage = !!sym(coverage_column)) |>
    plyranges::select(-!!sym(coverage_column))

}

# Function to fill internal gaps with fixed-width tiles
#' @importFrom GenomicRanges gaps tile sort
#' @importFrom plyranges mutate
#' @importFrom tidyr replace_na
fill_gaps_with_tiles <- function(gr, fixed_width, plot_range) {
  # Get the gaps
  gaps <- GenomicRanges::gaps(gr)
  # Tile the gaps
  tiled_gaps <- GenomicRanges::tile(gaps, width = fixed_width)
  # Unlist the tiled gaps
  tiled_gaps <- unlist(tiled_gaps)
  # Combine the original GRanges with the tiled gaps
  combined_gr <- c(gr, tiled_gaps)

  # Sort the combined GRanges
  combined_gr <- GenomicRanges::sort(combined_gr)
  combined_gr <- trim_and_drop_levels(combined_gr, trim_to = plot_range) |>
    plyranges::mutate(coverage = tidyr::replace_na(coverage, 0)) |>
    plyranges::mutate(group = tidyr::replace_na(group, unique(gr$group)))


  return(combined_gr)
}



# Helper functions
#' @importFrom GenomicRanges makeGRangesFromDataFrame
#' @importFrom BiocGenerics as.data.frame
#' @importFrom dplyr mutate filter
buff_granges <- function(x, gen = NULL) {
  std_chroms <-
    c(as.character(1:25),
      paste0("chr", 1:25),
      "X",
      "Y",
      "chrX",
      "chrY")
  x_df <- as.data.frame(x) |>
    as_tibble() |>
    mutate(seqnames = as.character(seqnames)) |>
    dplyr::filter(seqnames %in% std_chroms) |>
    mutate(seqnames = ifelse(
      str_detect(seqnames, "chr"),
      seqnames,
      paste0("chr", seqnames)
    ))

  x <- makeGRangesFromDataFrame(x_df, keep.extra.columns = T)
  genome(x) <- gen
  return(x)
}

#' Clean Up Your GRanges Object
#'
#' @description This function does several things.  It removes ranges with non-standard chromosomes and drops their levels.  It will optionally set the genome to the user-provided value.  Typically we would use "hg38" or "danRer11". This is the exported version because it is so useful.
#' @param x A Granges object to buff.
#' @param gen An optional genome name to provide.  Recommend "hg38" or "danRer11".
#' @return A GRanges object
#' @export
#' @importFrom GenomicRanges makeGRangesFromDataFrame
#' @importFrom BiocGenerics as.data.frame
#' @importFrom dplyr mutate filter
bb_buff_granges <- function(x, gen) {
  std_chroms <-
    c(as.character(1:25),
      paste0("chr", 1:25),
      "X",
      "Y",
      "chrX",
      "chrY")
  x_df <- as.data.frame(x) |>
    as_tibble() |>
    mutate(seqnames = as.character(seqnames)) |>
    dplyr::filter(seqnames %in% std_chroms) |>
    mutate(seqnames = ifelse(
      str_detect(seqnames, "chr"),
      seqnames,
      paste0("chr", seqnames)
    ))

  x <- makeGRangesFromDataFrame(x_df, keep.extra.columns = T)
  genome(x) <- gen
  return(x)
}

#' @importFrom IRanges subsetByOverlaps
trim_and_drop_levels <- function(x, trim_to, trim_type = "within") {
  x <- subsetByOverlaps(x, trim_to, type = trim_type)
  seqlevels(x, pruning.mode = "tidy") <- seqlevels(trim_to)
  return(x)
}

#' An S4 class to Hold Genome Track Data
#'
#' @description An instance of this class is created by calling "bb_makeTrace".  All slots in this object are GRanges objects.  Validation checks will make sure data, peaks, links, and gene models all are bound by the same plot range on the same chromosome of the same genome.  This is different from the standard GRangesList object in that each slot can have it's own metadata columns.  Currently, hg38 and danRer11 are the supported genomes.  Use this class to plot coverage tracks from bulk or single cell ATAC, CHIP, or similar experiments.  Link plotting is available for cicero-style links.
#'
#' @slot trace_data A GRanges object with a metadata column for "score" or "coverage" intended to be plotted as a y-variable.  Metadata variables may be included to annotate color and and facets in the final plotting.  This is particularly important for single cell data or when combining bulk tracks from different samples.  Whole sample bigwig files can be converted to GRanges objects using import.bw from rtracklayer.  All track data is trimmed during import but pre-trimming to the approximate range desired will significantly speed up processing.  The plyranges package is recommended for granges manipulations such as filtering by chromosome, adding metadata and binding GRanges objects together.  Bulk tracks from different samples should be pre-normalized before importing.
#' @slot peaks A GRanges object containing peaks to plot in a track-style format.
#' @slot links A GRanges object with Cicero-style links.
#' @slot gene_model The gene model for plotting.  Will be automatically generated by bb_makeTrace.
#' @slot plot_range The master GRange for the whole object.  Validity checks and/or constructors ensure all other ranges are contained within.
#' @import methods
#' @export Trace
#' @exportClass Trace
Trace <- setClass(
  "Trace",
  slots = list(
    trace_data = "GRanges",
    peaks = "GRanges",
    links = "GRanges",
    gene_model = "GRanges",
    plot_range = "GRanges"

  )
)

#' Show a Trace Object
#'
#' @export
setMethod("show",
          "Trace",
          function(object) {
            cat(paste0(
              "A Trace object from genome " ,
              genome(object@trace_data),
              ", sequence ",
              names(genome(object@trace_data))
            ))
            cat(paste0(
              ".\n\nThe plot range is set to ",
              start(object@plot_range),
              "-",
              end(object@plot_range)
            ), ".")
          })

# Validity Check
#' @export
setValidity("Trace", function(object) {
  if (genome(object@trace_data) %notin% c("danRer11", "hg38"))
    return("The trace data genome must be either danRer11 or hg38")
  if (genome(object@trace_data) != genome(object@peaks))
    return("The trace data and peaks genomes must match.")
  if (genome(object@trace_data) != genome(object@links))
    return("The trace data and links genomes must match.")
  if (genome(object@trace_data) != genome(object@gene_model))
    return("The trace data and gene model genomes must match.")
  if (genome(object@trace_data) != genome(object@plot_range))
    return("The trace data and plot range genomes must match.")
  if (levels(seqnames(object@trace_data)) != levels(seqnames(object@peaks)))
    return("The trace data and peaks seqnames must match.")
  if (levels(seqnames(object@trace_data)) != levels(seqnames(object@links)))
    return("The trace data and links seqnames must match.")
  if (levels(seqnames(object@trace_data)) != levels(seqnames(object@gene_model)))
    return("The trace data and gene model seqnames must match.")
  if (levels(seqnames(object@trace_data)) != levels(seqnames(object@plot_range)))
    return("The trace data and plot range seqnames must match.")
  if (length(object@plot_range) != 1)
    return("The plot range must have length 1.")
  if (length(findOverlaps(query = object@trace_data, subject = object@plot_range, type = "within")) != length(object@trace_data))
    return("The plot ranges must all overlap")
  if (length(findOverlaps(query = object@peaks, subject = object@plot_range, type = "within")) != length(object@peaks))
    return("The plot ranges must all overlap")
  if (length(findOverlaps(query = object@links, subject = object@plot_range, type = "within")) != length(object@links))
    return("The plot ranges must all overlap")
  if (length(findOverlaps(query = object@gene_model, subject = object@plot_range, type = "within")) != length(object@gene_model))
    return("The plot ranges must all overlap")


})

#' Construct a Trace object from a Signac Object or Granges object
#'
#' @description Problem 1:  Signac objects and GRanges made from bigwigs are large and it is computationally expensive to get data from them when tweaking plots.  Problem 2:  For the most part we like how Signac plots genomic coverage of track-like data and we would like to show bulk data in a similar way with a similar compuatational interface.  The trace object is a small intermediate object that holds the minimal amount of data you need to make a coverage plot showing accessibility or binding to a specific genomic region.  Then you can use the trace object to quickly and easily generate tracks as needed for your plot.  These tracks are all ggplots and are easy to configure for legible graphics using add-on layers.  There are options for displaying groups by color or facet which are built in with good graphical defaults.  If these are not suitable, they can be changed post hoc like any other ggplot.
#'
#' @param obj A Signac/Seurat object or a GRanges object.  Import a bigwig file to a GRanges object using bb_import_bw to ensure proper formatting.  Use plyranges functions to easily pre-filter the GRanges object e.g. by chr to reduce processing time.  The precise range will be defined by gene_to_plot and the extend arguments.  You may wish to add grouping metadata columns and to merge several bulk tracks.  This can be done while importing using c(bw1, bw2).
#' @param gene_to_plot The gene you want to display.  Must be a valid gene in the genome assembly being used.
#' @param genome The genome assembly.  Required.  Must be either "hg38" or "danRer11".
#' @param extend_left Bases to extend plot_range left, or upstream relative to the top strand.
#' @param extend_right Bases to extend plot_range right, or downstream relative to the top strand.
#' @param peaks An optional GRanges object holding peak data.  Ignored for Signac/Seurat objects which carry this internally.
#' @param bulk_group_col Used only when making a Trace from a GRanges object.  This identifies the metadata column holding the grouping information for the Trace data.   It will be converted literally to "group" when the object is made.  Recommendation is to import the bigwigs using import_bw which will set the group column and name it appropriately and then this can be left as the default.  This is ignored for Signac/Seurat objects which report this by default in a column named group.
#' @param bulk_coverage_col If you are making the object from a bigwig/GRanges, you need to identify which column in your bigwig/GRanges object holds the coverage data to plot on the y axis.  Defaults to "coverage".  Similar to bulk_group_col, if you import the bigwig using bb_import_bw, it should already be named appropriately.  Will be ignored for Signac/Seurat objects which use "coverage" by default.
#' @param fill_in Some track data may be very sparse.  This probably depends on how it was generated.  It seems that nextflow bigwigs have missing data where there is no signal but data from Signac is more complete with zeros.  The problem with missing data is that it makes the line plot look jagged.  This option allows you to fill in gaps in the trace data with 0's.  This is done by tiling the regions without real signal, leaving the ranges with real signal untouched.  Default is FALSE for compatibility with older code.  TRUE will fill in the gaps.
#' @param fixed_width Bin width for filling in gaps in sparse genome track data.  Defaults to 100 bp.
#' @import GenomicRanges tidyverse blaseRdata cli
#' @importFrom Signac CoveragePlot granges Links
#' @importFrom purrr map
#' @importFrom plyranges filter
#' @export
bb_makeTrace <- function(obj,
                         gene_to_plot,
                         genome = c("hg38", "danRer11"),
                         extend_left = 0,
                         extend_right = 0,
                         peaks = NULL,
                         bulk_group_col = "group",
                         bulk_coverage_col = "coverage",
                         fill_in = FALSE,
                         fixed_width = 100) {
  genome <- match.arg(genome, choices = c("hg38", "danRer11"))

  # find the chromosome needed needed
  available_genes <- c(mcols(hg38_granges_reduced)$gene_name,
                       mcols(zfin_granges_reduced)$gene_name)

  if (genome == "hg38") {
    full_gene_model = hg38_granges_reduced
  } else {
    full_gene_model = zfin_granges_reduced
  }

  if (gene_to_plot %in% available_genes) {
    selected_range <-
      full_gene_model[mcols(full_gene_model)$gene_name %in% gene_to_plot]
    plot_range <- range(selected_range)
  } else {
    cli::cli_abort("This gene is not available")
  }
  start(plot_range) <- start(plot_range) - extend_left
  end(plot_range) <- end(plot_range) + extend_right
  plot_range <- buff_granges(plot_range, gen = genome)
  # make the strand "*"
  plot_range <- GRanges(seqnames = seqnames(plot_range),
                        ranges = ranges(plot_range))
  genome(plot_range) <- genome

  # make the trace_data GRanges object
  if ("Seurat" %in% class(obj)) {
    trace_data <- Signac::CoveragePlot(
      obj,
      region = gene_to_plot,
      extend.upstream = extend_left,
      extend.downstream = extend_right
    )
    trace_data <- trace_data[[1]][[1]][["data"]]
    seqname <- levels(seqnames(plot_range))
    trace_data <- trace_data |> mutate(seqname = seqname)
    gr <- makeGRangesFromDataFrame(
      trace_data,
      keep.extra.columns = TRUE,
      start.field = "position",
      end.field = "position",
      seqnames.field = "seqname"
    )

  } else if ("GRanges" %in% class(obj)) {
    gr <- obj
  } else {
    return("Trace data must either be a data frame or a GRanges object.")
  }
  gr <- buff_granges(gr, gen = genome)

  # trim the data and clean up levels
  gr <- trim_and_drop_levels(x = gr, trim_to = plot_range)

  # clean up the metadata if you are working from a GRanges;
  if ("GRanges" %in% class(obj)) {
      values(gr)$group <- values(gr)[[bulk_group_col]]
      values(gr)$coverage <- values(gr)[[bulk_coverage_col]]
  }

  if (fill_in) {

    filled_in_list <-
      purrr::map(.x = unique(gr$group),
                 .f = \(x,
                        dat = gr,
                        pr = plot_range,
                        fw = fixed_width) {
                   # fill in zeros
                   dat <- plyranges::filter(dat, group == x)
                   fill_gaps_with_tiles(gr = dat, plot_range = pr, fixed_width = fw)

                 })
    gr <- GenomicRanges::sort(do.call(c, filled_in_list))

  }

  # get the species-specific gene-model
  selected_gene_model <-
    trim_and_drop_levels(x = full_gene_model, trim_to = plot_range)

  # add in the peaks/features
 if (!is.null(peaks)) {
    # read in the peak file in granges format
    peaks_to_add <- peaks
    # values(peaks_to_add) <- NULL
    peaks_to_add <- buff_granges(peaks_to_add, gen = genome)

    # trim the data and clean up levels
    peaks_to_add <-
      trim_and_drop_levels(x = peaks_to_add, trim_to = plot_range)
 } else if ("Seurat" %in% class(obj)) {
   peaks_to_add <- Signac::granges(obj)
 } else {
    # add in a zero-length peak to hold the place
    peaks_to_add <-
      GRanges(
        seqnames = levels(seqnames(plot_range)),
        ranges = IRanges(
          start = start(plot_range) + 1,
          end = start(plot_range)
        )
      )

  }


  peaks_to_add <- buff_granges(peaks_to_add, gen = genome)
  # peaks_to_add <-
  #   IRanges::subsetByOverlaps(peaks_to_add, plot_range)
  peaks_to_add <- trim_and_drop_levels(peaks_to_add, trim_to = plot_range)
  # trim the peaks
  # peaks_to_add <- trim_and_drop_levels(x = peaks_to_add, trim_to = plot_range)

  # add in the links
  if ("Seurat" %in% class(obj) && !is.null(Signac::Links(obj))) {
    links_to_add <- Signac::Links(obj)
  } else {
    # add in a zero-length feature to hold the place
    links_to_add <- GRanges(
      seqnames = levels(seqnames(plot_range)),
      ranges = IRanges(
        start = start(plot_range) + 1,
        end = start(plot_range)
      )
    )
  }

  links_to_add <- buff_granges(links_to_add, gen = genome)

  # trim the peaks
  links_to_add <-
    trim_and_drop_levels(x = links_to_add, trim_to = plot_range)

  theTrace <- Trace(
    trace_data = gr,
    gene_model = selected_gene_model,
    peaks = peaks_to_add,
    links = links_to_add,
    plot_range = plot_range

  )
  return(theTrace)
}

#' Get the Trace Data Slot from a Trace Object
#'
#' @export
setGeneric("Trace.data", function(trace)
  standardGeneric("Trace.data"))
#' @export
setMethod("Trace.data", "Trace", function(trace)
  trace@trace_data)

#' Get the peaks Slot from a Trace Object
#'
#' @export
setGeneric("Trace.peaks", function(trace)
  standardGeneric("Trace.peaks"))
#' @export
setMethod("Trace.peaks", "Trace", function(trace)
  trace@peaks)

#' Get the Links Slot from a Trace Object
#'
#' @export
setGeneric("Trace.links", function(trace)
  standardGeneric("Trace.links"))
#' @export
setMethod("Trace.links", "Trace", function(trace)
  trace@links)

#' Get the gene_model Slot from a Trace Object
#'
#' @export
setGeneric("Trace.gene_model", function(trace)
  standardGeneric("Trace.gene_model"))
#' @export
setMethod("Trace.gene_model", "Trace", function(trace)
  trace@gene_model)


#' Get the plot_range Slot from a Trace Object
#'
#' @export
setGeneric("Trace.plot_range", function(trace)
  standardGeneric("Trace.plot_range"))
#' @export
setMethod("Trace.plot_range", "Trace", function(trace)
  trace@plot_range)

#' Set the Trace Data Slot of a GRanges Object
#'
#' @param trace A trace object
#' @param gr A GRanges object.  This object will become the new trace_data.  If the range is smaller, it will trim the other slots to match.  Usually this is used to change range metadata only.
#' @export
setGeneric("Trace.setData", function(trace, gr)
  standardGeneric("Trace.setData"))
#' @export
setMethod("Trace.setData", "Trace", function(trace, gr) {
  trace@trace_data <- gr
  # trace@plot_range <-
  #   trim_and_drop_levels(x = trace@plot_range, trim_to = gr, trim_type = "any")
  # trace@peaks <-
  #   trim_and_drop_levels(x = trace@peaks, trim_to = gr)
  # trace@gene_model <-
  #   trim_and_drop_levels(x = trace@gene_model, trim_to = gr)
  # trace@links <- trim_and_drop_levels(x = trace@links, trim_to = gr)
  validObject(trace)
  trace
})

#' Set the Plot Range Slot of a GRanges Object
#'
#' @param trace A trace object
#' @param gr A GRanges object.  This object will become the new plot range.
#' @export
setGeneric("Trace.setRange", function(trace, gr)
  standardGeneric("Trace.setRange"))
#' @export
setMethod("Trace.setRange", "Trace", function(trace, gr) {
  trace@plot_range <- gr
  trace@trace_data <-
    trim_and_drop_levels(x = trace@trace_data, trim_to = gr)
  trace@peaks <-
    trim_and_drop_levels(x = trace@peaks, trim_to = gr)
  trace@gene_model <-
    trim_and_drop_levels(x = trace@gene_model, trim_to = gr)
  trace@links <- trim_and_drop_levels(x = trace@links, trim_to = gr)
  validObject(trace)
  trace
})

#' Set the peaks Slot of a GRanges Object
#'
#' @param trace A trace object
#' @param gr A GRanges object.  This object will become the new plot peaks.
#' @export
setGeneric("Trace.setpeaks", function(trace, gr)
  standardGeneric("Trace.setpeaks"))
#' @export
setMethod("Trace.setpeaks", "Trace", function(trace, gr) {
  gr <- buff_granges(gr, gen = genome(trace@plot_range))
  new_peaks <-
    trim_and_drop_levels(x = gr, trim_to = trace@plot_range)
  trace@peaks <- new_peaks
  validObject(trace)
  trace
})

#' Set the Links Slot of a GRanges Object
#'
#' @param trace A trace object
#' @param gr A GRanges object.  This object will become the new plot links.
#' @export
setGeneric("Trace.setLinks", function(trace, gr)
  standardGeneric("Trace.setLinks"))
#' @export
setMethod("Trace.setLinks", "Trace", function(trace, gr) {
  gr <- buff_granges(gr, gen = genome(trace@plot_range))
  new_links <-
    trim_and_drop_levels(x = gr, trim_to = trace@plot_range)
  trace@links <- new_links
  validObject(trace)
  trace
})




# helper functions for plotting
set_range <- function(grange) {
  start <- min(start(grange))
  end <- max(end(grange))
  return(c(start, end))
}

#' @import ggplot2
theme_no_x <- function() {
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x  = element_blank(),
    axis.title.x = element_blank(),
    axis.line.x = element_blank()
  )
}

#' @import ggplot2
theme_no_y <- function() {
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y  = element_blank(),
    axis.title.y = element_blank(),
    axis.line.y = element_blank()
  )
}

#' @import ggplot2
theme_min_y <- function() {
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

}

#' Plot The Trace Data From A Trace Object
#'
#' @description A function to generate a line plot from tracklike genomic data.  This pulls data from the Trace object trace_data slot.  Check what numeric and categorical variables are available for plotting using Trace.data.
#'
#' @param trace A Trace object
#' @param yvar The trace_data metadata variable that will become the y axis.  Defaults to "coverage".  Must be numeric.
#' @param yvar_label The y-axis label for the coverage track.  Defaults to "Coverage".
#' @param facet_var The trace_data metadata variable describing data facets.  Each will be placed as a separate horizontal track with the value printed to the left. Optional but recommended.  Defaults to "group".
#' @param color_var The variable to color groups of traces by.  Optional but recommended.  Defaults to "group".
#' @param pal A color palette.  Can also be added after the fact.
#' @param legend_pos Color legend position. Can also be added after the fact.  Defaults to "none".
#' @param group_filter Optional value to filter the trace data by.  Should be a value from the "group" metadata variable in the trace object.
#' @param group_variable Optional metadatavariable to filter trace data by.  When imported from signac/seurat objects, this value defaults to "group", so that is the default here.  However if constructed manually, you may wish to apply filtering to another variable.  If so, apply it to this parameter.
#' @import tidyverse
#' @importFrom BiocGenerics as.data.frame
#' @export
bb_plot_trace_data <- function(trace,
                               yvar = "coverage",
                               yvar_label = "Coverage",
                               facet_var = "group",
                               color_var = "group",
                               pal = NULL,
                               legend_pos = "none",
                               group_filter = NULL,
                               group_variable = "group"
                               ) {
  data_gr <- Trace.data(trace)

  data_tbl <-
    as.data.frame(data_gr) |>
    as_tibble() |>
    mutate(mid = width / 2 + start)

  if(!is.null(group_filter)) {
    data_tbl <- dplyr::filter(data_tbl, !!sym(group_variable) == group_filter)
  }


  p <- ggplot(data = data_tbl,
              mapping = aes(x = mid,
                            y = !!sym(yvar)))
  if (!is.null(color_var)) {
    p <- p + geom_line(aes(color = !!sym(color_var)))
  } else {
    p <- p + geom_line()
  }

  if (!is.null(pal)) {
    p <- p + scale_color_manual(values = pal,
                                breaks = names(pal))
  }

  if (!is.null(facet_var)) {
    p <- p + facet_wrap(
      facets = vars(!!sym(facet_var)),
      ncol = 1,
      strip.position = "left"
    ) +
      theme(strip.background = element_blank(),
            strip.text.y.left = element_text(angle = 0))
  }
  p <- p +
    xlim(set_range(Trace.plot_range(trace))) +
    theme_no_x() +
    theme(legend.position = legend_pos) +
    labs(y = yvar_label)

  return(p)
}

#' Plot The peak Data From A Trace Object
#'
#' @description A function to generate a peak plot from tracklike genomic data.
#'
#' @param trace A Trace object.
#' @param fill_color The color to fill the peak graphics with.  Defaults to grey60.
#' @param group_filter Optional value to filter the peak data by.  Should be a value from the "group" metadata variable in the trace object.
#' @param group_variable Optional metadatavariable to filter trace data by.  When imported from signac/seurat objects, this value defaults to "group", so that is the default here.  However if constructed manually, you may wish to apply filtering to another variable.  If so, apply it to this parameter.
#' @import tidyverse
#' @importFrom BiocGenerics as.data.frame
#' @importFrom cli cli_abort
#' @export
bb_plot_trace_peaks <- function(trace,
                                group_filter = NULL,
                                group_variable = "group",
                                pal = NULL) {
  gr <- Trace.peaks(trace)

  if (start(gr[1]) > end(gr[1])) {
    cli::cli_abort("This trace object contains no peaks!")
  }


  gr_tbl <-
    as.data.frame(gr) |>
    as_tibble() |>
    mutate(mid = width / 2 + start) |>
    mutate(type = "Peaks")

  if(!is.null(group_filter)) {
    gr_tbl <- dplyr::filter(gr_tbl, !!sym(group_variable) == group_filter)
  }

  p <- ggplot(data = gr_tbl,
              mapping = aes(x = mid,
                            y = type,
                            width = width))
  if (is.null(pal)) {
    p <- p +
      geom_tile(color = "black", fill = "grey60")
  } else {
    p <- p +
      geom_tile(color = "black", aes(fill = !!sym(group_variable))) +
      scale_fill_manual(values = pal) +
      theme(legend.position = "none")
  }

  p <- p +
    xlim(set_range(Trace.plot_range(trace))) +
    theme_no_x() +
    theme_min_y() +
    labs(y = "Peaks")

  return(p)
}


#' Plot The Link Data From A Trace Object
#'
#' @description A function to generate a link plot from tracklike genomic data.  Links will automatically be trimmed to lie entirely within the plot range.  An additional, optional score cutoff can be provided.
#'
#' @param trace A Trace object containing a valid links slot.
#' @param cutoff Score cutoff for link plotting.  Defaults to 0.
#' @param link_low_color The color of a link with value of 0, default = grey80
#' @param link_high_color  The color of a link with value of 1, default = red3
#' @param link_range  The range of the color scale in terms of link values, default = c(0,1)
#' @import tidyverse
#' @importFrom BiocGenerics as.data.frame
#' @importFrom cli cli_abort
#' @import ggforce
#' @export
bb_plot_trace_links <- function(trace,
                                cutoff = 0,
                                link_low_color = "grey80",
                                link_high_color = "red3",
                                link_range = c(0,1)) {
  gr <- Trace.links(trace)
  if (start(gr[1]) > end(gr[1])) {
    cli::cli_abort("This trace object contains no links!")
  }

  gr_tbl <-
    as.data.frame(gr) |>
    as_tibble() |>
    mutate(mid = width / 2 + start) |>
    dplyr::filter(score > cutoff) |>
    distinct() |>
    mutate(group = rank(score, ties.method = "first"))

  bezier_data <-
    tibble(
      x = c(gr_tbl$start,
            gr_tbl$mid,
            gr_tbl$end),
      y = c(rep(0, length(gr_tbl$start)),
            rep(-1, length(gr_tbl$mid)),
            rep(0, length(gr_tbl$end))),
      group = rep(gr_tbl$group, 3),
      score = rep(gr_tbl$score, 3)
    )

  p <- ggplot(data = bezier_data,
              mapping = aes(
                x = x,
                y = y,
                group = group,
                color = score
              )) +
    geom_bezier()
  p <- p +
    xlim(set_range(Trace.plot_range(trace))) +
    theme_no_x() +
    theme_min_y() +
    labs(y = "Links", color = "Link Score") +
    scale_color_gradient(low = link_low_color,
                         high = link_high_color,
                         limits = link_range)
  return(p)
}

#' @importFrom BiocGenerics as.data.frame
#' @import tidyverse
select_the_transcripts <- function(gr) {
  data <-
    as.data.frame(gr) |>
    as_tibble() |>
    group_by(gene_name, APPRIS, length, parent_transcript) |>
    summarise(.groups = "keep") |>
    ungroup() |>
    group_by(gene_name) |>
    arrange(APPRIS, desc(length)) |>
    slice_head() |>
    select(gene_name, parent_transcript) |>
    deframe()
  return(data)

}


#' Plot The Gene Model From A Trace Object
#'
#' @description A function to generate a plot of the underlying gene model.  The genes to be plotted are automatically selected according to the genome build and the plot range. The function automatically picks the longest principle transcript to show.  Optionally, alternative transcripts can be shown by specifying the select_transcript argument.  This must be an ensembl transcript identifier lying within the plot range.
#'
#' @param trace A Trace object.
#' @param font_face Font face option to use.  Default = "italic".
#' @param select_transcript Optional selected transcript(s) to plot.
#' @param icon_fill The color to make the exon boxes.
#' @param debug Boolean.  Option to show the transcript ID on the final plot to confirm you have the right one. Default = FALSE.
#' @import tidyverse
#' @importFrom BiocGenerics as.data.frame
#' @export
bb_plot_trace_model <- function(trace,
                                font_face = "italic",
                                select_transcript = NULL,
                                icon_fill = "cornsilk",
                                debug = FALSE) {
  data_gr <- Trace.gene_model(trace)
  data_tbl <-
    mcols(data_gr) |>
    as_tibble() |>
    dplyr::mutate(start = start(data_gr)) |>
    dplyr::mutate(end = end(data_gr)) |>
    dplyr::mutate(mid = width(data_gr) / 2 + start) |>
    dplyr::mutate(width = width(data_gr)) |>
    dplyr::mutate(strand = as.vector(strand(data_gr))) |>
    dplyr::mutate(ht = recode(
      type,
      "five_prime_UTR" = 0.5,
      "three_prime_UTR" = 0.5,
      "CDS" = 1
    ))

  transcripts <- select_the_transcripts(data_gr)
  if (!is.null(select_transcript)) {
    transcript_lookup <-
      bind_rows(as_tibble(mcols(hg38_granges_reduced)), as_tibble(mcols(zfin_granges_reduced)))
    selected <- transcript_lookup |>
      dplyr::filter(parent_transcript %in% select_transcript) |>
      select(gene_name, parent_transcript) |>
      deframe()
    # replace the original with selected transcripts
    transcripts[names(selected)] <- selected

  }

  data_to_plot <- data_tbl |>
    dplyr::filter(parent_transcript %in% transcripts)

  names_to_plot <- data_to_plot |>
    group_by(gene_name, parent_transcript, strand) |>
    summarise(gene_start = min(start), gene_end = max(end), .groups = "keep") |>
    mutate(mid_gene = (gene_start + gene_end) / 2)

  segments_to_plot <- map_dfr(
    .x = names_to_plot$gene_name,
    .f = function(x, data = names_to_plot) {
      filtered <- data |>
        dplyr::filter(gene_name == x)
      xpos <-
        seq.int(from = filtered$gene_start,
                to = filtered$gene_end,
                by = 1000)
      res <-
        tibble(
          gene_name = filtered$gene_name,
          parent_transcript = filtered$parent_transcript,
          xpos = xpos[-length(xpos)],
          xend = xpos + 1000,
          strand = filtered$strand
        )
      return(res)
    }
  )

  p <- ggplot() +
    geom_segment(
      data = dplyr::filter(segments_to_plot, strand == "+"),
      mapping = aes(
        x = xpos,
        xend = xend,
        y = parent_transcript,
        yend = parent_transcript
      ),
      arrow = arrow(
        ends = "last",
        type = "open",
        angle = 45,
        length = unit(x = 0.05, units = "inches")
      )
    ) +
    geom_segment(
      data = dplyr::filter(segments_to_plot, strand == "-"),
      mapping = aes(
        x = xpos,
        xend = xend,
        y = parent_transcript,
        yend = parent_transcript
      ),
      arrow = arrow(
        ends = "first",
        type = "open",
        angle = 45,
        length = unit(x = 0.05, units = "inches")
      )
    ) +
    geom_tile(
      data = data_to_plot,
      mapping = aes(
        x = mid,
        y = parent_transcript,
        width = width,
        height = ht
      ),
      color = "black",
      fill = icon_fill
    ) +
    geom_text(
      data = names_to_plot,
      mapping = aes(
        x = mid_gene,
        y = paste0(parent_transcript, "_gene"),
        label = gene_name
      ),
      size = 3,
      fontface = font_face
    )
  if (debug) {
    p <- p +
      xlim(set_range(Trace.plot_range(trace)))

  } else {
    p <- p +
      xlim(set_range(Trace.plot_range(trace))) +
      theme_no_x() +
      theme_min_y() +
      labs(y = "Genes")

  }

  return(p)
}


#' Plot The X Axis From A Trace Object
#'
#' @description Generates the X axis for stacking other track plots on top of.
#'
#' @param trace A Trace object.
#' @param xtitle An optional title for the X axis.  Defaults to the  genome and chromosome.
#' @import tidyverse
#' @import GenomicRanges
#' @export
bb_plot_trace_axis <- function(trace,
                               xtitle = NULL) {
  gr0 <- Trace.plot_range(trace)
  genome <- genome(gr0)
  chrom <- levels(seqnames(gr0))
  if (is.null(xtitle)) {
    if (genome == "hg38")
      xtitle <- paste0("GRCh38 ", chrom, " (kb)")
    else if (genome == "danRer11")
      xtitle <- paste0("GRCz11 ", chrom, " (kb)")
  }
  gr <- range(gr0)
  gr_tbl <-
    tibble(start = start(gr), end = end(gr)) |>
    pivot_longer(everything())
  p <- ggplot(data = gr_tbl, mapping = aes(x = value))
  p <- p +
    xlim(set_range(Trace.plot_range(trace))) +
    scale_x_continuous(labels = formatter1000) +
    theme_no_y() +
    labs(x = xtitle)
  return(p)
}

formatter1000 <- function(x){
  x/1000
}

#' @title Import Peaks from SEACR
#' @description The function reads peaks in .bed file format produced by SEACR.  Optionally add a group variable and value for later filtering or faceting when combined with other peak files.
#' @param file file path to the SEACR .bed file
#' @param group_variable An optional variable name for additional group metadata.  PARAM_DESCRIPTION, Default: NULL
#' @param group_value A value supplied to the group metadata variable.  Required if group_variable is not NULL.  PARAM_DESCRIPTION
#' @return A GRanges object
#' @seealso
#'  \code{\link[readr]{read_delim}}
#'  \code{\link[dplyr]{select}}, \code{\link[dplyr]{mutate}}
#'  \code{\link[GenomicRanges]{makeGRangesFromDataFrame}}
#' @rdname bb_import_seacr_peaks
#' @export
#' @importFrom readr read_tsv
#' @importFrom dplyr select mutate
#' @importFrom GenomicRanges makeGRangesFromDataFrame
bb_import_seacr_peaks <- function(file, group_variable = NULL, group_value) {
  tbl <- readr::read_tsv(file, col_names = c("chr", "start", "end", "total_signal", "max_signal", "region")) |>
    dplyr::select(c(chr, start, end))

  if(!is.null(group_variable)) {
    tbl <- tbl |>
      dplyr::mutate(!!group_variable := group_value)
  }
  GenomicRanges::makeGRangesFromDataFrame(tbl, keep.extra.columns = TRUE)
}

#' @title Import Peaks from MACS2
#' @description The function reads peak files produced by MACS.  Optionally add a group variable and value for later filtering or faceting when combined with other peak files.
#' @param file file path to the MACS narrowpeak file
#' @param group_variable An optional variable name for additional group metadata.  PARAM_DESCRIPTION, Default: NULL
#' @param group_value A value supplied to the group metadata variable.  Required if group_variable is not NULL.  PARAM_DESCRIPTION
#' @return A GRanges object
#' @seealso
#'  \code{\link[readr]{read_delim}}
#'  \code{\link[dplyr]{select}}, \code{\link[dplyr]{mutate}}
#'  \code{\link[GenomicRanges]{makeGRangesFromDataFrame}}
#' @rdname bb_import_seacr_peaks
#' @export
#' @importFrom readr read_tsv
#' @importFrom dplyr select mutate
#' @importFrom GenomicRanges makeGRangesFromDataFrame
bb_import_macs_narrowpeaks <- function(file,
                                        group_variable = NULL,
                                        group_value){
  tbl <- readr::read_tsv(
    file,
    col_names = c(
      "chrom",
      "chromStart",
      "chromEnd",
      "name",
      "score",
      "strand",
      "singalValue",
      "pValue",
      "qValue",
      "peak"
    )
  ) |> dplyr::select(c(chr = chrom, start = chromStart, end = chromEnd))

  if (!is.null(group_variable)) {
    tbl <- dplyr::mutate(tbl, `:=`(!!group_variable, group_value))
  }
  GenomicRanges::makeGRangesFromDataFrame(tbl, keep.extra.columns = TRUE)
}

