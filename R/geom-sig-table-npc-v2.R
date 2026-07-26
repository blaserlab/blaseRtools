#' Significance-table annotations in true panel NPC coordinates
#'
#' This implementation deliberately does not map any y aesthetic and does not
#' call ggplot_build() while the plot is being assembled. Vertical positions are
#' drawn directly in the final panel viewport, so annotations cannot train or
#' enlarge the y scale.
NULL

`%||%` <- function(x, y) if (is.null(x)) y else x

.theme_base_size_pt <- function(plot = NULL) {
  th <- ggplot2::theme_get()
  if (!is.null(plot) && !is.null(plot$theme)) {
    th <- th + plot$theme
  }
  th$text$size %||% 11
}

.assert_required_cols <- function(data, cols) {
  missing_cols <- base::setdiff(cols, names(data))
  if (length(missing_cols) > 0L) {
    stop(
      "Missing required column(s): ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }
}

.get_plot_x_var <- function(plot) {
  x_expr <- plot$mapping$x
  if (rlang::quo_is_null(x_expr)) {
    stop(
      "Could not determine x aesthetic from plot. Supply `x_levels` explicitly.",
      call. = FALSE
    )
  }
  rlang::as_name(rlang::get_expr(x_expr))
}

.get_plot_x_levels <- function(plot, x_levels = NULL) {
  if (!is.null(x_levels)) {
    return(as.character(x_levels))
  }

  x_var <- .get_plot_x_var(plot)
  if (is.null(plot$data) || !x_var %in% names(plot$data)) {
    stop(
      "Could not recover x-axis values from `plot$data`. Supply `x_levels` explicitly.",
      call. = FALSE
    )
  }

  x <- plot$data[[x_var]]
  if (is.factor(x)) levels(x) else unique(as.character(x))
}

is_star_label <- function(x) {
  grepl("^\\*+$", as.character(x))
}

.validate_sig_inputs <- function(
    p_table,
    y_npc,
    group1_col,
    group2_col,
    label_col,
    facet_cols = NULL,
    x_levels = NULL
) {
  .assert_required_cols(p_table, c(group1_col, group2_col, label_col))

  if (length(y_npc) != nrow(p_table)) {
    stop(
      "`y_npc` must have the same length as the number of rows in `p_table`.",
      call. = FALSE
    )
  }
  if (!is.numeric(y_npc) || anyNA(y_npc)) {
    stop("`y_npc` must be numeric and contain no missing values.", call. = FALSE)
  }
  if (any(y_npc < 0 | y_npc > 1)) {
    stop("All `y_npc` values must be between 0 and 1.", call. = FALSE)
  }

  if (!is.null(facet_cols)) {
    missing_facets <- base::setdiff(as.character(facet_cols), names(p_table))
    if (length(missing_facets) > 0L) {
      stop(
        "Requested facet column(s) not found in `p_table`: ",
        paste(missing_facets, collapse = ", "),
        call. = FALSE
      )
    }
  }

  g1 <- as.character(p_table[[group1_col]])
  g2 <- as.character(p_table[[group2_col]])

  if (!is.null(x_levels)) {
    bad <- base::setdiff(unique(c(g1, g2)), as.character(x_levels))
    if (length(bad) > 0L) {
      stop(
        "Some comparison groups do not match x-axis levels: ",
        paste(bad, collapse = ", "),
        call. = FALSE
      )
    }
  }

  invisible(TRUE)
}

.prepare_sig_npc_data <- function(
    p_table,
    y_npc,
    group1_col,
    group2_col,
    label_col,
    facet_cols = NULL,
    x_levels = NULL,
    bracket_tip_npc = 0.015,
    bracket_margin_npc = 0.02,
    text_size_pt = 9,
    star_y_npc_offset = 0.01
) {
  .validate_sig_inputs(
    p_table = p_table,
    y_npc = y_npc,
    group1_col = group1_col,
    group2_col = group2_col,
    label_col = label_col,
    facet_cols = facet_cols,
    x_levels = x_levels
  )

  if (!is.numeric(bracket_tip_npc) || length(bracket_tip_npc) != 1L ||
      bracket_tip_npc < 0) {
    stop("`bracket_tip_npc` must be one non-negative number.", call. = FALSE)
  }
  if (!is.numeric(bracket_margin_npc) || length(bracket_margin_npc) != 1L ||
      bracket_margin_npc < 0) {
    stop("`bracket_margin_npc` must be one non-negative number.", call. = FALSE)
  }
  if (!is.numeric(star_y_npc_offset) || length(star_y_npc_offset) != 1L) {
    stop("`star_y_npc_offset` must be one number.", call. = FALSE)
  }

  out <- as.data.frame(p_table)
  out$.sig_group1 <- as.character(out[[group1_col]])
  out$.sig_group2 <- as.character(out[[group2_col]])
  out$.sig_label <- as.character(out[[label_col]])

  if (!is.null(x_levels)) {
    out$.sig_group1 <- factor(out$.sig_group1, levels = x_levels)
    out$.sig_group2 <- factor(out$.sig_group2, levels = x_levels)
  }

  out$.sig_label_npc <- y_npc +
    ifelse(is_star_label(out$.sig_label), star_y_npc_offset, 0)
  out$.sig_bracket_npc <- pmax(0, y_npc - bracket_margin_npc)
  out$.sig_tip_npc <- pmax(
    0,
    y_npc - bracket_margin_npc - bracket_tip_npc
  )
  out$.sig_text_size_pt <- rep(text_size_pt, nrow(out))
  out
}

GeomSigTableNpc <- ggplot2::ggproto(
  "GeomSigTableNpc",
  ggplot2::Geom,

  required_aes = c(
    "x", "xend", "label",
    "label_npc", "bracket_npc", "tip_npc", "text_size_pt"
  ),

  default_aes = ggplot2::aes(),
  draw_key = ggplot2::draw_key_blank,

  extra_params = c(
    "na.rm", "draw_brackets",
    "text_family", "text_face", "text_colour",
    "bracket_colour", "bracket_linewidth", "bracket_linetype",
    "bracket_lineend", "vjust"
  ),

  draw_panel = function(
      data,
      panel_params,
      coord,
      draw_brackets = TRUE,
      text_family = NULL,
      text_face = NULL,
      text_colour = "black",
      bracket_colour = "black",
      bracket_linewidth = 0.4,
      bracket_linetype = 1,
      bracket_lineend = "round",
      vjust = 0,
      na.rm = FALSE
  ) {
    if (nrow(data) == 0L) {
      return(grid::nullGrob())
    }

    # x and xend are transformed to final panel coordinates in [0, 1].
    # The custom *_npc aesthetics are not position aesthetics and therefore
    # never train either axis.
    coords <- coord$transform(data, panel_params)

    keep <- stats::complete.cases(
      coords$x,
      coords$xend,
      coords$label_npc,
      coords$bracket_npc,
      coords$tip_npc
    )
    coords <- coords[keep, , drop = FALSE]

    if (nrow(coords) == 0L) {
      return(grid::nullGrob())
    }

    text_grob <- grid::textGrob(
      label = coords$label,
      x = grid::unit((coords$x + coords$xend) / 2, "npc"),
      y = grid::unit(coords$label_npc, "npc"),
      just = c(0.5, vjust),
      gp = grid::gpar(
        col = text_colour,
        fontsize = coords$text_size_pt,
        fontfamily = text_family %||% "",
        fontface = text_face %||% 1
      )
    )

    if (!isTRUE(draw_brackets)) {
      return(text_grob)
    }

    n <- nrow(coords)
    bracket_grob <- grid::segmentsGrob(
      x0 = grid::unit(
        c(coords$x, coords$x, coords$xend),
        "npc"
      ),
      x1 = grid::unit(
        c(coords$xend, coords$x, coords$xend),
        "npc"
      ),
      y0 = grid::unit(
        c(coords$bracket_npc, coords$bracket_npc, coords$bracket_npc),
        "npc"
      ),
      y1 = grid::unit(
        c(coords$bracket_npc, coords$tip_npc, coords$tip_npc),
        "npc"
      ),
      gp = grid::gpar(
        col = bracket_colour,
        lwd = bracket_linewidth * ggplot2::.pt,
        lty = bracket_linetype,
        lineend = bracket_lineend
      )
    )

    grid::grobTree(bracket_grob, text_grob)
  }
)

#' Add significance labels and optional brackets from a table
#'
#' `y_npc = 0` is the bottom and `y_npc = 1` the top of the final panel,
#' after scale expansion and coordinate limits. The layer has no y aesthetic,
#' so it cannot alter the y scale.
#'
#' @export
geom_sig_table <- function(
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
) {
  if (is.null(text_size_pt)) {
    text_size_pt <- .theme_base_size_pt() - 2
  }

  ann <- .prepare_sig_npc_data(
    p_table = p_table,
    y_npc = y_npc,
    group1_col = group1_col,
    group2_col = group2_col,
    label_col = label_col,
    facet_cols = facet_cols,
    x_levels = x_levels,
    bracket_tip_npc = bracket_tip_npc,
    bracket_margin_npc = bracket_margin_npc,
    text_size_pt = text_size_pt,
    star_y_npc_offset = star_y_npc_offset
  )

  ggplot2::layer(
    geom = GeomSigTableNpc,
    stat = "identity",
    position = "identity",
    data = ann,
    mapping = ggplot2::aes(
      x = .sig_group1,
      xend = .sig_group2,
      label = .sig_label,
      label_npc = .sig_label_npc,
      bracket_npc = .sig_bracket_npc,
      tip_npc = .sig_tip_npc,
      text_size_pt = .sig_text_size_pt
    ),
    inherit.aes = FALSE,
    params = list(
      draw_brackets = draw_brackets,
      text_family = text_family,
      text_face = text_face,
      text_colour = text_colour,
      bracket_colour = bracket_colour,
      bracket_linewidth = bracket_linewidth,
      bracket_linetype = bracket_linetype,
      bracket_lineend = bracket_lineend,
      vjust = vjust,
      na.rm = na.rm
    )
  )
}

#' Add significance annotations to an existing ggplot
#'
#' @export
add_sig_annotations <- function(plot, ...) {
  plot + geom_sig_table(...)
}
