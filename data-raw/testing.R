devtools::load_all()
library(rtracklayer)
library(tidyverse)
library(GenomicRanges)

theme_set(theme_cowplot())

bg_files <- fs::dir_ls("~/network/X/Labs/Blaser/staff/Shelby-Wantong/bedgraph/coverage")

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

test_trace <- bb_makeTrace(obj = gr_all, genome = "danRer11", extend_right = 1000)
test_trace
# test_trace@trace_data
#
# blaseRtools:::trim_and_drop_levels(zfin_granges_reduced, blaseRtools::Trace.plot_range(test_trace))
# subsetByOverlaps(zfin_granges_reduced, blaseRtools::Trace.plot_range(test_trace))
# subsetByOverlaps(zfin_granges_reduced, GenomicRanges::GRanges(seqnames = "chr1", ranges = IRanges(6680, 10191)))
#
# blaseRtools::Trace.plot_range(test_trace)

bb_plot_trace_data(test_trace, yvar = "score", legend_pos = "none", facet = NULL) /
  bb_plot_trace_model(test_trace, segment_length_bp = 100, line_width = 0.5) /
  bb_plot_trace_axis(test_trace) +
  patchwork::plot_layout(heights = c(10,1,1))


test_trace@gene_model
start(Trace.plot_range(test_trace))

devtools::load_all()
bb_plot_trace_model(test_trace, icon_alpha = 0.6, arrow_scale = 2, segment_length_bp = 100)
bb_plot_trace_model(test_trace, icon_alpha = 0.6, arrow_scale = 2, segment_length_bp = 100) |> View()
Trace.plot_range(test_trace)
seq.int(5, 26, 5)
?seq_along
Trace.gene_model(test_trace)


trim_and_drop_levels(zfin_granges_reduced, trim_to = Trace.plot_range(test_trace), trim_type = "within")
restrict(zfin_granges_reduced, start = start(Trace.plot_range(test_trace)), end = end(Trace.plot_range(test_trace)))

trim_x_to_single_range(x = zfin_granges_reduced, target = Trace.plot_range(test_trace))

