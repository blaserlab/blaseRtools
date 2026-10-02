devtools::load_all()

load("~/brad_workspace/multiome.analyses.datapkg.shared_data/zf_dll4_trace.rda")
load("~/brad_workspace/multiome.analyses.datapkg.shared_data/zf_dll4_cnt_trace.rda")

zf_dll4_trace@gene_model
bb_plot_trace_model(zf_dll4_cnt_trace, select_transcript = "ENSDART00000103320")
bb_plot_trace_model(zf_dll4_cnt_trace, select_transcript = "ENSDART00000191703")
bb_plot_trace_model(zf_dll4_cnt_trace)

