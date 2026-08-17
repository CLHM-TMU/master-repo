suppressPackageStartupMessages({
  library(lefser)
  library(ggplot2)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

# ---------- Snakemake bindings ----------
lefser_rds    <- snakemake@input[["lefser_rds"]]
lda_svg       <- snakemake@output[["lda_svg"]]
cladogram_svg <- snakemake@output[["cladogram_svg"]]
lda_png       <- snakemake@output[["lda_png"]]
cladogram_png <- snakemake@output[["cladogram_png"]]
group_col     <- snakemake@params[["group_col"]] %||% stop("group_col param not set")
color_palette <- snakemake@params[["colors"]]     %||% stop("color_palette param not set")

dir.create(dirname(lda_svg), recursive = TRUE, showWarnings = FALSE)

empty_plot <- function(msg = "No significant markers found") {
  ggplot2::ggplot() +
    ggplot2::annotate("text", x = 0.5, y = 0.5, label = msg, size = 6, hjust = 0.5) +
    ggplot2::theme_void()
}

write_empty_outputs <- function() {
  svg(lda_svg, width = 10, height = 4); print(empty_plot()); dev.off()
  ggplot2::ggsave(lda_png, plot = empty_plot(), width = 10, height = 4, dpi = 300, bg = "white")
  svg(cladogram_svg, width = 12, height = 12); print(empty_plot()); dev.off()
  ggplot2::ggsave(cladogram_png, plot = empty_plot(), width = 12, height = 12, dpi = 300, bg = "white")
  message("[lefseR] Empty plots written.")
}

message("[lefseR] Loading results: ", lefser_rds)
payload <- tryCatch(readRDS(lefser_rds), error = function(e) {
  message("[lefseR] Failed to load RDS (", conditionMessage(e), "); writing empty plots.")
  NULL
})

if (is.null(payload) || is.null(payload$res) || nrow(payload$res) == 0) {
  write_empty_outputs()
  quit(save = "no", status = 0)
}

res        <- payload$res
res_clades <- payload$res_clades
class_a    <- payload$class_a
class_b    <- payload$class_b
n_markers  <- nrow(res)
message("[lefseR] Markers to plot: ", n_markers)

missing_colors <- setdiff(c(class_a, class_b), names(color_palette))
if (length(missing_colors) > 0)
  warning("[lefseR] Groups missing from color_palette: ", paste(missing_colors, collapse = ", "))

color_pair <- c(unlist(color_palette)[[class_a]] %||% "grey50",
                unlist(color_palette)[[class_b]] %||% "grey80")

plot_title <- paste0(group_col, ": ", class_a, " vs ", class_b)

# ---------- LDA bar plot ----------
message("[lefseR] Writing LDA bar plot -> ", lda_svg)
p_lda <- tryCatch(
  lefser::lefserPlot(res, colors = color_pair, title = plot_title),
  error = function(e) {
    message("[lefseR] lefserPlot() failed: ", conditionMessage(e))
    empty_plot("LDA plot failed")
  }
)

lda_height <- max(4, n_markers * 0.3 + 2)
svg(lda_svg, width = 10, height = lda_height)
print(p_lda)
dev.off()
ggplot2::ggsave(lda_png, plot = p_lda, width = 10, height = lda_height, dpi = 300, bg = "white")

# ---------- Cladogram ----------
message("[lefseR] Writing cladogram -> ", cladogram_svg)
p_clado <- if (is.null(res_clades) || nrow(res_clades) == 0) {
  message("[lefseR] No clade-resolved results available; falling back to LDA bar plot.")
  p_lda
} else {
  tryCatch(
    lefser::lefserPlotClad(res_clades, colors = color_pair, showTipLabels = FALSE, showNodeLabels = "p"),
    error = function(e) {
      message("[lefseR] lefserPlotClad() failed: ", conditionMessage(e),
              "; falling back to LDA bar plot.")
      p_lda
    }
  )
}

svg(cladogram_svg, width = 16, height = 16)
print(p_clado)
dev.off()
ggplot2::ggsave(cladogram_png, plot = p_clado, width = 16, height = 16, dpi = 300, bg = "white")

message("[lefseR] Plotting done.")
