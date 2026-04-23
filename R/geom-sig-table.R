#' Significance-table annotations for ggplot2 discrete x-axes
#'
#' Helpers to add significance labels and optional brackets to ggplot2 plots
#' from a user-supplied comparison table.
#'
#' Notes:
#' - Facet-aware: if `p_table` contains facet columns matching the plot facets,
#'   annotations are placed only in matching panels. Otherwise they are repeated
#'   across all panels.
#' - PDF-safe significance stars: star-only labels like "*", "**", "***" remain
#'   ASCII and are nudged upward slightly so they sit more like "ns".
#' - Bracket segment ends default to `lineend = "round"`.
#'
#' @name geom_sig_table
NULL

# internal helpers ------------------------------------------------------------

`%||%` <- function(x, y) if (is.null(x)) y else x

.pt_to_mm <- function(pt) {
  pt / ggplot2::.pt
}

.theme_base_size_pt <- function(plot = NULL) {
  th <- ggplot2::theme_get()
  if (!is.null(plot) && !is.null(plot$theme)) {
    th <- th + plot$theme
  }
  th$text$size %||% 11
}

.assert_required_cols <- function(data, cols) {
  missing_cols <- base::setdiff(cols, names(data))
  if (length(missing_cols) > 0) {
    stop(
      "Missing required column(s): ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }
}

.get_built_plot <- function(plot) {
  ggplot2::ggplot_build(plot)
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

  if (is.factor(x)) {
    levels(x)
  } else {
    unique(as.character(x))
  }
}

.get_panel_y_range <- function(built, panel) {
  pp <- built$layout$panel_params[[panel]]

  yr <- pp$y.range %||%
    pp$y$range$range %||%
    pp$y$continuous_range %||%
    NULL

  if (is.null(yr) || length(yr) != 2) {
    stop("Could not determine y-range from plot panel.", call. = FALSE)
  }

  as.numeric(yr)
}

.npc_to_data_y <- function(npc, y_range) {
  y_range[1] + npc * diff(y_range)
}

.get_facet_layout <- function(plot) {
  built <- .get_built_plot(plot)
  layout <- built$layout$layout

  non_facet_cols <- c("PANEL", "ROW", "COL", "SCALE_X", "SCALE_Y")
  facet_cols <- base::setdiff(names(layout), non_facet_cols)

  list(
    built = built,
    layout = layout,
    facet_cols = facet_cols
  )
}

.get_annotation_facet_cols <- function(p_table, layout_df, facet_cols = NULL) {
  built_nonfacet <- c("PANEL", "ROW", "COL", "SCALE_X", "SCALE_Y")
  built_facet_cols <- base::setdiff(names(layout_df), built_nonfacet)

  if (!is.null(facet_cols)) {
    facet_cols <- as.character(facet_cols)

    missing_cols <- base::setdiff(facet_cols, names(p_table))
    if (length(missing_cols) > 0) {
      stop(
        "Requested facet column(s) not found in `p_table`: ",
        paste(missing_cols, collapse = ", "),
        call. = FALSE
      )
    }

    missing_in_layout <- base::setdiff(facet_cols, built_facet_cols)
    if (length(missing_in_layout) > 0) {
      stop(
        "Requested facet column(s) not found in plot facet layout: ",
        paste(missing_in_layout, collapse = ", "),
        call. = FALSE
      )
    }

    return(facet_cols)
  }

  intersect(names(p_table), built_facet_cols)
}

.match_annotation_panels <- function(p_table, layout_df, facet_cols = NULL) {
  ann_facet_cols <- .get_annotation_facet_cols(
    p_table = p_table,
    layout_df = layout_df,
    facet_cols = facet_cols
  )

  if (length(ann_facet_cols) == 0) {
    return(lapply(seq_len(nrow(p_table)), function(i) layout_df$PANEL))
  }

  out <- vector("list", nrow(p_table))

  for (i in seq_len(nrow(p_table))) {
    keep <- rep(TRUE, nrow(layout_df))

    for (fc in ann_facet_cols) {
      keep <- keep & (as.character(layout_df[[fc]]) == as.character(p_table[[fc]][i]))
    }

    panels <- layout_df$PANEL[keep]

    if (length(panels) == 0) {
      facet_desc <- paste(
        paste0(
          ann_facet_cols,
          "=",
          vapply(
            ann_facet_cols,
            function(fc) as.character(p_table[[fc]][i]),
            character(1)
          )
        ),
        collapse = ", "
      )
      stop(
        "No facet panel matched annotation row ", i, " (", facet_desc, ").",
        call. = FALSE
      )
    }

    out[[i]] <- panels
  }

  out
}

is_star_label <- function(x) {
  x <- as.character(x)
  grepl("^\\*+$", x)
}

.validate_sig_inputs <- function(
    plot,
    p_table,
    y_npc,
    group1_col,
    group2_col,
    label_col,
    x_levels = NULL
) {
  .assert_required_cols(p_table, c(group1_col, group2_col, label_col))

  if (length(y_npc) != nrow(p_table)) {
    stop(
      "`y_npc` must have the same length as the number of rows in `p_table`.",
      call. = FALSE
    )
  }

  if (!is.numeric(y_npc)) {
    stop("`y_npc` must be numeric.", call. = FALSE)
  }

  if (any(is.na(y_npc))) {
    stop("`y_npc` cannot contain missing values.", call. = FALSE)
  }

  if (any(y_npc < 0 | y_npc > 1)) {
    stop("All `y_npc` values must be between 0 and 1.", call. = FALSE)
  }

  g1 <- p_table[[group1_col]]
  g2 <- p_table[[group2_col]]

  if (is.numeric(g1) || is.numeric(g2)) {
    stop(
      "`group1` and `group2` must be categorical (character/factor), not numeric.",
      call. = FALSE
    )
  }

  x_levels <- .get_plot_x_levels(plot, x_levels = x_levels)

  g1_chr <- as.character(g1)
  g2_chr <- as.character(g2)

  bad1 <- base::setdiff(unique(g1_chr), x_levels)
  bad2 <- base::setdiff(unique(g2_chr), x_levels)

  if (length(bad1) > 0 || length(bad2) > 0) {
    msg <- c(
      "Some comparison groups do not match x-axis values.",
      if (length(bad1) > 0) paste0("Unmatched in `", group1_col, "`: ", paste(bad1, collapse = ", ")),
      if (length(bad2) > 0) paste0("Unmatched in `", group2_col, "`: ", paste(bad2, collapse = ", "))
    )
    stop(paste(msg, collapse = "\n"), call. = FALSE)
  }

  invisible(TRUE)
}

# exported helpers ------------------------------------------------------------

#' Prepare significance annotation data for a ggplot
#'
#' Facet-aware version. If `p_table` contains facet columns matching the plot,
#' annotations are placed only in the matching panels. If not, annotations are
#' repeated across all panels.
#'
#' Star-only labels like `"***"` are kept as ASCII for PDF robustness and
#' nudged upward slightly so they sit more like `"ns"`.
#'
#' @param plot A ggplot object with a discrete x-axis and continuous y-axis.
#' @param p_table A data frame containing at minimum `group1`, `group2`, and
#'   `significance` columns.
#' @param y_npc Numeric vector of label y positions in npc coordinates.
#' @param group1_col,group2_col,label_col Column names in `p_table`.
#' @param x_levels Optional character vector giving x-axis order.
#' @param facet_cols Optional character vector naming the facet columns in
#'   `p_table`. If `NULL`, they are auto-detected.
#' @param draw_brackets Logical; whether brackets should be drawn.
#' @param bracket_tip_npc Length of bracket tips in npc units.
#' @param bracket_margin_npc Gap between label and bracket top line in npc units.
#' @param text_size_pt Text size in points. Defaults to theme text size minus 2.
#' @param star_y_npc_offset Upward offset, in npc units, applied only to
#'   star-only labels like `"*"`, `"**"`, `"***"`.
#'
#' @return A tibble with one row per annotation per matched panel.
#' @export
prepare_sig_annotations <- function(
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
    star_y_npc_offset = 0.01
) {
  .validate_sig_inputs(
    plot = plot,
    p_table = p_table,
    y_npc = y_npc,
    group1_col = group1_col,
    group2_col = group2_col,
    label_col = label_col,
    x_levels = x_levels
  )

  if (!is.numeric(bracket_tip_npc) || length(bracket_tip_npc) != 1L || bracket_tip_npc < 0) {
    stop("`bracket_tip_npc` must be a single non-negative number.", call. = FALSE)
  }

  if (!is.numeric(bracket_margin_npc) || length(bracket_margin_npc) != 1L || bracket_margin_npc < 0) {
    stop("`bracket_margin_npc` must be a single non-negative number.", call. = FALSE)
  }

  if (!is.numeric(star_y_npc_offset) || length(star_y_npc_offset) != 1L) {
    stop("`star_y_npc_offset` must be a single numeric value.", call. = FALSE)
  }

  facet_info <- .get_facet_layout(plot)
  built <- facet_info$built
  layout_df <- facet_info$layout

  x_levels <- .get_plot_x_levels(plot, x_levels = x_levels)
  x_map <- stats::setNames(seq_along(x_levels), x_levels)

  matched_panels <- .match_annotation_panels(
    p_table = p_table,
    layout_df = layout_df,
    facet_cols = facet_cols
  )

  if (is.null(text_size_pt)) {
    text_size_pt <- .theme_base_size_pt(plot) - 2
  }

  rows <- vector("list", nrow(p_table))
  ann_facet_cols <- .get_annotation_facet_cols(
    p_table = p_table,
    layout_df = layout_df,
    facet_cols = facet_cols
  )

  for (i in seq_len(nrow(p_table))) {
    panels_i <- matched_panels[[i]]

    label_i <- as.character(p_table[[label_col]][i])
    is_star_i <- is_star_label(label_i)

    rows[[i]] <- do.call(
      rbind,
      lapply(panels_i, function(panel_i) {
        y_range <- .get_panel_y_range(built, panel_i)

        data.frame(
          .row = i,
          PANEL = panel_i,
          group1 = as.character(p_table[[group1_col]][i]),
          group2 = as.character(p_table[[group2_col]][i]),
          label = label_i,
          x1 = unname(x_map[as.character(p_table[[group1_col]][i])]),
          x2 = unname(x_map[as.character(p_table[[group2_col]][i])]),
          x = mean(c(
            unname(x_map[as.character(p_table[[group1_col]][i])]),
            unname(x_map[as.character(p_table[[group2_col]][i])])
          )),
          y_npc = y_npc[i],
          y = .npc_to_data_y(
            y_npc[i] + if (is_star_i) star_y_npc_offset else 0,
            y_range
          ),
          bracket_y = .npc_to_data_y(max(0, y_npc[i] - bracket_margin_npc), y_range),
          tip_y = .npc_to_data_y(max(0, y_npc[i] - bracket_margin_npc - bracket_tip_npc), y_range),
          text_size_pt = text_size_pt,
          draw_brackets = draw_brackets,
          stringsAsFactors = FALSE
        )
      })
    )

    if (length(ann_facet_cols) > 0) {
      for (fc in ann_facet_cols) {
        rows[[i]][[fc]] <- as.character(p_table[[fc]][i])
      }
    }
  }

  out <- tibble::as_tibble(do.call(rbind, rows))
  out$PANEL <- as.integer(out$PANEL)
  out
}

#' Build significance annotation geoms
#'
#' @param annotation_data Output from [prepare_sig_annotations()].
#' @param draw_brackets Logical; draw brackets if `TRUE`.
#' @param text_family,text_face,text_colour Text styling parameters.
#' @param bracket_colour,bracket_linewidth,bracket_linetype Bracket styling.
#' @param bracket_lineend Line ending for bracket segments. Defaults to `"round"`.
#' @param vjust Vertical justification for text.
#'
#' @return A list of ggplot layers.
#' @export
geom_sig_annotations <- function(
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
) {
  text_layer <- ggplot2::geom_text(
    data = annotation_data,
    mapping = ggplot2::aes(x = x, y = y, label = label),
    inherit.aes = FALSE,
    size = .pt_to_mm(annotation_data$text_size_pt[1]),
    family = text_family,
    fontface = text_face,
    colour = text_colour,
    vjust = vjust
  )

  if (!isTRUE(draw_brackets)) {
    return(list(text_layer))
  }

  bracket_top <- ggplot2::geom_segment(
    data = annotation_data,
    mapping = ggplot2::aes(x = x1, xend = x2, y = bracket_y, yend = bracket_y),
    inherit.aes = FALSE,
    linewidth = bracket_linewidth,
    linetype = bracket_linetype,
    lineend = bracket_lineend,
    colour = bracket_colour
  )

  bracket_left <- ggplot2::geom_segment(
    data = annotation_data,
    mapping = ggplot2::aes(x = x1, xend = x1, y = bracket_y, yend = tip_y),
    inherit.aes = FALSE,
    linewidth = bracket_linewidth,
    linetype = bracket_linetype,
    lineend = bracket_lineend,
    colour = bracket_colour
  )

  bracket_right <- ggplot2::geom_segment(
    data = annotation_data,
    mapping = ggplot2::aes(x = x2, xend = x2, y = bracket_y, yend = tip_y),
    inherit.aes = FALSE,
    linewidth = bracket_linewidth,
    linetype = bracket_linetype,
    lineend = bracket_lineend,
    colour = bracket_colour
  )

  list(bracket_top, bracket_left, bracket_right, text_layer)
}

#' Add significance annotations to an existing ggplot
#'
#' @inheritParams prepare_sig_annotations
#' @inheritParams geom_sig_annotations
#'
#' @return A ggplot object with annotation layers appended.
#' @export
add_sig_annotations <- function(
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
) {
  ann <- prepare_sig_annotations(
    plot = plot,
    p_table = p_table,
    y_npc = y_npc,
    group1_col = group1_col,
    group2_col = group2_col,
    label_col = label_col,
    x_levels = x_levels,
    facet_cols = facet_cols,
    draw_brackets = draw_brackets,
    bracket_tip_npc = bracket_tip_npc,
    bracket_margin_npc = bracket_margin_npc,
    text_size_pt = text_size_pt,
    star_y_npc_offset = star_y_npc_offset
  )

  plot + geom_sig_annotations(
    annotation_data = ann,
    draw_brackets = draw_brackets,
    text_family = text_family,
    text_face = text_face,
    text_colour = text_colour,
    bracket_colour = bracket_colour,
    bracket_linewidth = bracket_linewidth,
    bracket_linetype = bracket_linetype,
    bracket_lineend = bracket_lineend,
    vjust = vjust
  )
}

#' Add significance labels and optional brackets from a table
#'
#' Returns an object that can be added directly to a ggplot with `+`.
#'
#' @inheritParams prepare_sig_annotations
#' @inheritParams geom_sig_annotations
#'
#' @return An object that can be added to a ggplot with `+`.
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
    vjust = 0
) {
  structure(
    list(
      p_table = p_table,
      y_npc = y_npc,
      group1_col = group1_col,
      group2_col = group2_col,
      label_col = label_col,
      x_levels = x_levels,
      facet_cols = facet_cols,
      draw_brackets = draw_brackets,
      bracket_tip_npc = bracket_tip_npc,
      bracket_margin_npc = bracket_margin_npc,
      text_size_pt = text_size_pt,
      star_y_npc_offset = star_y_npc_offset,
      text_family = text_family,
      text_face = text_face,
      text_colour = text_colour,
      bracket_colour = bracket_colour,
      bracket_linewidth = bracket_linewidth,
      bracket_linetype = bracket_linetype,
      bracket_lineend = bracket_lineend,
      vjust = vjust
    ),
    class = "sig_table_layer"
  )
}

#' @export
#' @method ggplot_add sig_table_layer
ggplot_add.sig_table_layer <- function(object, plot, object_name) {
  ann <- prepare_sig_annotations(
    plot = plot,
    p_table = object$p_table,
    y_npc = object$y_npc,
    group1_col = object$group1_col,
    group2_col = object$group2_col,
    label_col = object$label_col,
    x_levels = object$x_levels,
    facet_cols = object$facet_cols,
    draw_brackets = object$draw_brackets,
    bracket_tip_npc = object$bracket_tip_npc,
    bracket_margin_npc = object$bracket_margin_npc,
    text_size_pt = object$text_size_pt,
    star_y_npc_offset = object$star_y_npc_offset
  )

  plot + geom_sig_annotations(
    annotation_data = ann,
    draw_brackets = object$draw_brackets,
    text_family = object$text_family,
    text_face = object$text_face,
    text_colour = object$text_colour,
    bracket_colour = object$bracket_colour,
    bracket_linewidth = object$bracket_linewidth,
    bracket_linetype = object$bracket_linetype,
    bracket_lineend = object$bracket_lineend,
    vjust = object$vjust
  )
}
