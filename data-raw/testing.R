devtools::load_all()
library(rtracklayer)
library(tidyverse)
library(GenomicRanges)

bg_files <- fs::dir_ls("~/network/X/Labs/Blaser/staff/Shelby-Wantong/bedgraph/coverage")
gr <- import(bg_files[1])
range(gr)
genome(gr) <- "danRer11"
gr
seqnames(gr)
gr1 <- GenomeInfoDb::renameSeqlevels(gr, c("NC_007131.7" = "20"))
seqnames(gr) <- "7"
seqlevels(gr)
gr$group <- "test"
gr

gr_list <- map2(bg_files,
                fs::path_file(bg_files),
    \(x, y) {
      gr <- rtracklayer::import(x)
      gr <- GenomeInfoDb::renameSeqlevels(gr, c("NC_007131.7" = "chr20"))
      gr$group <- y
      genome(gr) <- "danRer11"
      gr
      })

gr_all <- unlist(GRangesList(gr_list), use.names = FALSE)

test_trace <- bb_makeTrace(obj = gr_all, genome = "danRer11")
test_trace@trace_data

blaseRtools:::trim_and_drop_levels(zfin_granges_reduced, blaseRtools::Trace.plot_range(test_trace))
subsetByOverlaps(zfin_granges_reduced, blaseRtools::Trace.plot_range(test_trace))
subsetByOverlaps(zfin_granges_reduced, GenomicRanges::GRanges(seqnames = "chr1", ranges = IRanges(6680, 10191)))

blaseRtools::Trace.plot_range(test_trace)

theme_set(theme_cowplot())
bb_plot_trace_data(test_trace, yvar = "score", legend_pos = "none") /
  bb_plot_trace_model(test_trace) /
  bb_plot_trace_axis(test_trace) +
  patchwork::plot_layout(heights = c(10,1,1))
test_trace@gene_model

