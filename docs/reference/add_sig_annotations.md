# Add significance annotations to an existing ggplot

Add significance annotations to an existing ggplot

## Usage

``` r
add_sig_annotations(
  plot,
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
  star_y_npc_offset = 0.01,
  text_family = NULL,
  text_face = NULL,
  text_colour = "black",
  bracket_colour = "black",
  bracket_linewidth = 0.4,
  bracket_linetype = 1,
  bracket_lineend = "round",
  vjust = 0
)
```

## Arguments

- plot:

  A ggplot object with a discrete x-axis and continuous y-axis.

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

A ggplot object with annotation layers appended.
