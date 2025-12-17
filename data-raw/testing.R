devtools::load_all()

library("blaseRtemplates")
# library("blaseRtools")
library("blaseRdata")
library("conflicted")
library("tidyverse")
library("gert")
library("cowplot")
library("BSgenome.Drerio.UCSC.danRer11")
library("Signac")
library("Seurat")
library("monocle3")
library("RColorBrewer")
library("TFBSTools")
library("JASPAR2020")
library("org.Dr.eg.db")
library("TxDb.Drerio.UCSC.danRer11.refGene")
library("circlize")
library("ComplexHeatmap")
library("ggpubr")
library("patchwork")
library("EnrichedHeatmap")

# conflicts ---------------------------------------------------------------
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer("count", "dplyr")
conflict_prefer("mutate", "dplyr")
conflict_prefer("colMaxs", "MatrixGenerics")
conflict_prefer("union", "base")
conflicted::conflicts_prefer(SummarizedExperiment::`colData<-`)
conflicted::conflicts_prefer(base::as.data.frame)

# project_data(path = c(
#   "~/network/X/Labs/Blaser/staff/datapkg/pkc_cxcl8",
#   "/network/X/Labs/Blaser/share/resources/datapkg/R01.feb2025"
# ), deconflict_string = c(".cxcl8", ""))

project_data(path = c(
  "~/network/X/Labs/Blaser/staff/datapkg/niche_epigenetics/multiome_analyses/",
  "~/network/X/Labs/Blaser/staff/datapkg/niche_epigenetics/huvec_multiome/",
  "~/network/X/Labs/Blaser/staff/datapkg/pkc_cxcl8"
), deconflict_string = c(".zfish", ".human", ".cxcl8"))



# trace ----------------------------------------------
Signac::Fragments(embryo_niche.zfish) <- NULL
Signac::Fragments(embryo_niche.zfish) <- Signac::CreateFragmentObject(path = "/home/OSUMC.EDU/blas02/network/X/Labs/Blaser/staff/single_cell/multiome_jul2022/pipestance/processed_20220924/aggr_20220924/outs/atac_fragments.tsv.gz")


zf_dll4_trace <-
  bb_makeTrace(
    embryo_niche.zfish,
    gene_to_plot = "dll4",
    extend_left = 10000,
    extend_right = 10000,
    genome = "danRer11"
  )

## file path to zebrafish cut tag bigwig and peak

k27ac_zf <-
  bb_import_bw(
    fs::path(
      "/workspace/wantong_workspace/cutntag/trimmed/alignment/bigwig/27ac_zf_raw.bw"
    ),
    group = "H3K27Ac")

k27ac_peak_zf <- bb_import_macs_narrowpeaks(
  fs::path(
    "/workspace/wantong_workspace/cutntag/trimmed/peaks/macs2/27ac_zf_peaks.narrowPeak"),
  group_variable = "group",
  group_value = "H3K27Ac")


k27me3_zf <-
  bb_import_bw(
    fs::path(
      "/workspace/wantong_workspace/cutntag/trimmed/alignment/bigwig/27me3_zf_raw.bw"
    ),
    group = "H3K27Me3")

k27me3_peak_zf <- bb_import_macs_narrowpeaks(
  fs::path("/workspace/wantong_workspace/cutntag/trimmed/peaks/macs2/27me3_zf_peaks.narrowPeak"),
  group_variable = "group",
  group_value = "H3K27Me3")


k4me3_zf <-
  bb_import_bw(
    fs::path(
      "/workspace/wantong_workspace/cutntag/trimmed/alignment/bigwig/k4me3_zf_raw.bw"
    ),
    group = "H3K4Me3")

k4me3_peak_zf <- bb_import_macs_narrowpeaks(
  fs::path("/workspace/wantong_workspace/cutntag/trimmed/peaks/macs2/k4me3_zf_peaks.narrowPeak"),
  group_variable = "group",
  group_value = "H3K4Me3")

zf_dll_trace <- bb_makeTrace(
  c(k27ac_zf, k27me3_zf, k4me3_zf),
  gene_to_plot = "dll4",
  genome = "danRer11",
  extend_left = 10000,
  extend_right = 10000,
  fill_in = TRUE,
  peaks = c(k27ac_peak_zf, k27me3_peak_zf, k4me3_peak_zf)
)


zf_plotfun <- function(trace1, trace2, bubdat, palette) {
  p0 <- bb_plot_trace_data(trace1,
                           yvar_label = "Multiome",
                           pal = palette) +
    theme(strip.placement = "outside") +
    scale_y_continuous(breaks = c(0, 150))
  p0.1 <- bb_plot_trace_peaks(trace1) + theme_nothing()
  p0.2 <- ggplot(bubdat,
                 aes(
                   x = gene_short_name,
                   y = group,
                   fill = expression,
                   size = proportion
                 )) +
    geom_point(pch = 21) +
    scale_fill_viridis_c() +
    scale_size_area(max_size = 5) +
    theme_minimal_grid(font_size = main_fontsize) +
    scale_x_discrete(position = "top") +
    theme(axis.text.x = element_text(face = "italic")) +
    theme(axis.text.y = element_blank()) +
    labs(
      x = NULL,
      y = NULL,
      fill = "Expression",
      size = "Proportion"
    )
  p0.3 <-
    bb_plot_trace_links(trace1) +
    theme_nothing(font_size = theme_get()$text$size) +
    theme(legend.position = "right") +
    scale_color_distiller(palette = "YlOrRd",
                          direction = 1,
                          limits = c(0, 0.2),
                          name = "Link")
  p1 <-
    bb_plot_trace_data(
      trace2,
      pal = palette,
      group_filter = "H3K27Ac",
      group_variable = "group"
    ) +
    theme(strip.placement = "outside") +
    theme(axis.title.y.left = element_blank())+
    scale_y_continuous(breaks = c(0, 3500))
  p2 <-
    bb_plot_trace_peaks(
      trace2,
      pal = palette,
      group_filter = "H3K27Ac",
      group_variable = "group"
    ) +
    theme_nothing()
  p3 <-
    bb_plot_trace_data(
      trace2,
      pal = palette,
      group_filter = "H3K27Me3",
      group_variable = "group"
    ) +
    theme(strip.placement = "outside") +
    theme(axis.title.y.left = element_blank()) +
    scale_y_continuous(breaks = c(0, 2800))
  p4 <-
    bb_plot_trace_peaks(
      trace2,
      pal = palette,
      group_filter = "H3K27Me3",
      group_variable = "group"
    ) +
    theme_nothing()
  p5 <-
    bb_plot_trace_data(
      trace2,
      pal = palette,
      group_filter = "H3K4Me3",
      group_variable = "group"
    ) +
    theme(strip.placement = "outside") +
    theme(axis.title.y.left = element_blank()) +
    scale_y_continuous(breaks = c(0, 2500))
  p6 <-
    bb_plot_trace_peaks(
      trace2,
      pal = palette,
      group_filter = "H3K4Me3",
      group_variable = "group"
    ) + theme_nothing()
  p7 <-
    bb_plot_trace_model(trace2) + theme(axis.line.y = element_blank()) + labs(y = NULL)
  p8 <- bb_plot_trace_axis(trace2)


  design <- "
  AC
  BM
  NM
  DM
  EM
  GM
  HM
  IM
  JM
  KM
  LM
  "

  wrap_plots(
    A = p0,
    B = p0.1,
    N = p0.3,
    C = p0.2,
    D = p1,
    E = p2,
    G = p3,
    H = p4,
    I = p5,
    J = p6,
    K = p7,
    L = p8,
    M = guide_area(),
    design = design,
    guides = "collect",
    heights = c(2, 0.1, 0.3, 0.6, 0.1, 0.6, 0.1, 0.6, 0.1, 0.6, 0.01),
    widths = c(2, 0.5)
  ) & theme(legend.box = "vertical", legend.justification = "center")

}

monocle_niche.zfish
zf_dll4_genebub_dat <-
  bb_genebubbles(
    monocle_niche.zfish,
    genes = c("dll4", "chac1"),
    cell_grouping = "cds_recluster",
    gene_ordering = "as_supplied",
    return_value = "data"
  )

zf_dll4_genebub_dat <- zf_dll4_genebub_dat |> mutate(group = factor(group, levels = c("sinusoidal", "osteoblast", "MSC", "fibroblast")))

experimental_group_palette <- c(

  "control" = "#3C5488",
  "competitor" = "#3C5488",
  "+" = "#DC0000",
  "-" = "#3C5488",
  # "unassigned" = brewer.pal(n = 8, name = "Set2")[8],
  "fibroblast" = "#83639f",
  "MSC" = "#ea7827",
  "osteoblast" = "#c22f2f",
  "sinusoidal" = "#449945",
  "other" = "#F781BF",
  "niche" = brewer.pal(n = 8, name = "Set2")[2],
  "sinusoidal-enriched" = brewer.pal(n = 8, name = "Set2")[3],
  "other-1" = brewer.pal(n = 8, name = "Set2")[4],
  "other-2" = brewer.pal(n = 8, name = "Set2")[5],
  "+ guides" = "#DC0000",
  "no guides" = "#3C5488",
  "\u2212 guides" = "#3C5488",
  "mt" = "#DC0000",
  "mutant" = "#DC0000",
  "WT" = "#3C5488",
  "H3K27Ac" = "black",
  "H3K27Me3" = "red",
  "H3K4Me3" = "blue",
  "FLI1" = "#F4A261",
  "FLI" = "#F4A261",
  "KLF3" = "#2A9D8F",
  "CTCF" = "#9B5DE5",
  "IgG" = "#B0B0B0",
  "dll4 enh." = "#3C5488",
  "Klf3 mt" = "#ea7827",
  "Rel mt" = "#F781BF",
  "cas9 only" = "#3C5488",
  "dll4 enhancer" = "#DC0000",
  "Klf3 motif" = "#ea7827",
  "Rel motif" = "#F781BF"


)
main_fontsize <- 11
zf_dll4_multiome_coverage_plot <- zf_plotfun(
  trace1 = zf_dll4_trace,
  trace2 = zf_dll_trace,
  palette = experimental_group_palette,
  bubdat = zf_dll4_genebub_dat
)
zf_dll4_multiome_coverage_plot
