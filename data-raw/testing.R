.rs.restartR()
devtools::load_all()
# analysis_tibble <- readxl::read_excel("/network/X/Labs/Blaser/share/collaborators/toland_oca2_zfish_data/Images_scoring shelby/OCA2 recovery scoring.xlsx", sheet = 2L)
# blaseRtools::bb_blind_images(analysis_tibble, file_column = "Path to images", output_dir = "~/network/X/Labs/Blaser/share/collaborators/toland_oca2_zfish_data/Images_scoring shelby/blinding")
#
blaseRtools::project_data("~/network/X/Labs/Blaser/share/collaborators/lapalombella_mehdi_network/datapkg")

bb_cite_umap(cds_main, "Hu.CD52")
bb_rowmeta(cds_main, experiment_type = "Antibody Capture") |> print(n = Inf)
