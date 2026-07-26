# Add significance labels and optional brackets from a table

`y_npc = 0` is the bottom and `y_npc = 1` the top of the final panel,
after scale expansion and coordinate limits. The layer has no y
aesthetic, so it cannot alter the y scale.

## Usage

``` r
geom_sig_table(
  p_table,
  y_npc,
  group1_col = "group1",
  group2_col = "group2",
  label_col = "significance",
  x_levels = NULL,
  facet_cols = NULL,
  draw_brackets = TRUE,
  bracket_tip_npc = 0.015,
  bracket_margin_npc = 0.02,
  text_size_pt = NULL,
  star_y_npc_offset = -0.05,
  text_family = NULL,
  text_face = NULL,
  text_colour = "black",
  bracket_colour = "black",
  bracket_linewidth = 0.2,
  bracket_linetype = 1,
  bracket_lineend = "round",
  vjust = 0,
  na.rm = FALSE
)
```
