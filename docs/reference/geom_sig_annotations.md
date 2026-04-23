# Build significance annotation geoms

Build significance annotation geoms

## Usage

``` r
geom_sig_annotations(
  annotation_data,
  draw_brackets = TRUE,
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

- annotation_data:

  Output from [`prepare_sig_annotations()`](prepare_sig_annotations.md).

- draw_brackets:

  Logical; draw brackets if `TRUE`.

- text_family, text_face, text_colour:

  Text styling parameters.

- bracket_colour, bracket_linewidth, bracket_linetype:

  Bracket styling.

- bracket_lineend:

  Line ending for bracket segments. Defaults to `"round"`.

- vjust:

  Vertical justification for text.

## Value

A list of ggplot layers.
