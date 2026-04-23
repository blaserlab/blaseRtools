# Significance-table annotations for ggplot2 discrete x-axes

Helpers to add significance labels and optional brackets to ggplot2
plots from a user-supplied comparison table.

Returns an object that can be added directly to a ggplot with `+`.

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
  vjust = 0
)
```

## Arguments

- p_table:

  A data frame containing at minimum `group1`, `group2`, and
  `significance` columns.

- y_npc:

  Numeric vector of label y positions in npc coordinates.

- group1_col, group2_col, label_col:

  Column names in `p_table`.

- x_levels:

  Optional character vector giving x-axis order.

- facet_cols:

  Optional character vector naming the facet columns in `p_table`. If
  `NULL`, they are auto-detected.

- draw_brackets:

  Logical; whether brackets should be drawn.

- bracket_tip_npc:

  Length of bracket tips in npc units.

- bracket_margin_npc:

  Gap between label and bracket top line in npc units.

- text_size_pt:

  Text size in points. Defaults to theme text size minus 2.

- star_y_npc_offset:

  Upward offset, in npc units, applied only to star-only labels like
  `"*"`, `"**"`, `"***"`.

- text_family, text_face, text_colour:

  Text styling parameters.

- bracket_colour, bracket_linewidth, bracket_linetype:

  Bracket styling.

- bracket_lineend:

  Line ending for bracket segments. Defaults to `"round"`.

- vjust:

  Vertical justification for text.

## Value

An object that can be added to a ggplot with `+`.

## Details

Notes:

- Facet-aware: if `p_table` contains facet columns matching the plot
  facets, annotations are placed only in matching panels. Otherwise they
  are repeated across all panels.

- PDF-safe significance stars: star-only labels like "*", "**", "***"
  remain ASCII and are nudged upward slightly so they sit more like
  "ns".

- Bracket segment ends default to `lineend = "round"`.
