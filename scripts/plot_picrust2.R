library(tidyverse)

# Compute a global sample order from one file (pathway is most comprehensive)
# so that all three plots share the same x-axis ordering for easy comparison
get_global_sample_order <- function(file_path) {
  data_table <- read_tsv(file_path, col_types = cols())
  
  mat <- data_table %>%
    pivot_longer(cols = -c(1:2), names_to = "sampleid", values_to = "Abundance") %>%
    select(sampleid, name = 2, Abundance) %>%
    pivot_wider(names_from = "sampleid", values_from = "Abundance", values_fill = 0) %>%
    column_to_rownames("name") %>%
    as.matrix()

  log_mat <- log10(mat + 1)
  colnames(log_mat)[hclust(dist(t(log_mat)))$order]
}

# Function to process and plot
generate_plot <- function(file_path, title_label, metadata_path, global_sample_order) {
  
  message(paste("Reading file:", file_path))
  
  # 1. Load data
  data_table <- read_tsv(file_path, col_types = cols())
  metadata   <- read_tsv(metadata_path, col_types = cols())
  
  print(paste("Loaded", title_label, "with dimensions:", ncol(data_table), "cols x", nrow(data_table), "rows"))
  
  # 2. Pivot
  df_long <- data_table %>%
    pivot_longer(cols = -c(1:2), names_to = "sampleid", values_to = "Abundance")
  
  # 3. Join with metadata
  df_merged <- inner_join(df_long, metadata, by = "sampleid")
  
  if (nrow(df_merged) == 0) {
    stop("Error: No matching SampleIDs found between metadata and PICRUSt2 output!")
  }

  # 4. Filter for top N most variable features
  id_col   <- colnames(data_table)[1]
  name_col <- colnames(data_table)[2]
  
  top_features <- df_merged %>%
    group_by(across(all_of(id_col))) %>%
    summarize(v = var(log10(Abundance + 1)), .groups = "drop") %>%
    slice_max(v, n = snakemake@params[["top_n"]]) %>%
    pull(id_col)
    
  plot_data <- df_merged %>% filter(.data[[id_col]] %in% top_features)

  # 5. Apply global sample order (consistent across all three plots)
  #    Features are still clustered per-plot since they differ across pathway/KO/EC
  wide_mat <- plot_data %>%
    select(all_of(c("sampleid", name_col, "Abundance"))) %>%
    pivot_wider(names_from = "sampleid", values_from = "Abundance", values_fill = 0) %>%
    column_to_rownames(name_col) %>%
    as.matrix()

  feature_order <- rownames(wide_mat)[hclust(dist(log10(wide_mat + 1)))$order]

  plot_data$sampleid    <- factor(plot_data$sampleid,    levels = global_sample_order)
  plot_data[[name_col]] <- factor(plot_data[[name_col]], levels = feature_order)

  # 6. Create Plot
  p <- ggplot(plot_data, aes(x = sampleid, y = .data[[name_col]], fill = log10(Abundance + 1))) +
    geom_tile() +
    scale_fill_viridis_c(option = "magma") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8),
      axis.text.y = element_text(size = 7),
      plot.title  = element_text(hjust = 0.5)
    ) +
    labs(title = title_label, y = "Description", fill = "Log10 Abund")
    
  return(p)
}

# --- Main Execution ---

# Compute sample order once from the pathway file, reuse for KO and EC
global_sample_order <- get_global_sample_order(snakemake@input[["pathway"]])

pdf(snakemake@output[["heatmap_pdf"]], width = 12, height = 10)

print(generate_plot(snakemake@input[["pathway"]], "Top 30 Pathways",   snakemake@input[["metadata"]], global_sample_order))
print(generate_plot(snakemake@input[["ko"]],      "Top 30 KOs",        snakemake@input[["metadata"]], global_sample_order))
print(generate_plot(snakemake@input[["ec"]],      "Top 30 EC Numbers", snakemake@input[["metadata"]], global_sample_order))

dev.off()

message("Success: PDF generated at ", snakemake@output[["heatmap_pdf"]])