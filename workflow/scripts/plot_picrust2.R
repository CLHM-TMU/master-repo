library(tidyverse)

# Function to process and plot
generate_plot <- function(file_path, title_label, metadata_path) {
  
  message(paste("Reading file:", file_path))
  
  # 1. Load data
  data_table <- read_tsv(file_path, col_types = cols())
  metadata <- read_tsv(metadata_path, col_types = cols())
  
  # Debug: Check if data loaded correctly
  print(paste("Loaded", title_label, "with dimensions:", ncol(data_table), "cols x", nrow(data_table), "rows"))
  
  # 2. Pivot - using index 1:2 to skip ID and Description columns
  df_long <- data_table %>%
    pivot_longer(
      cols = -c(1:2), 
      names_to = "sampleid", 
      values_to = "Abundance"
    )
  
  # 3. Join with metadata
  df_merged <- inner_join(df_long, metadata, by = "sampleid")
  
  if(nrow(df_merged) == 0) {
    stop("Error: No matching SampleIDs found between metadata and PICRUSt2 output!")
  }

  # 4. Filter for top 30 most variable features
  # Uses the 1st column (ID) for grouping and 2nd column (Name) for plotting
  id_col <- colnames(data_table)[1]
  name_col <- colnames(data_table)[2]
  
  top_features <- df_merged %>%
    group_by(across(all_of(id_col))) %>%
    summarize(v = var(log10(Abundance + 1)), .groups = "drop") %>%
    slice_max(v, n = 30) %>%
    pull(id_col)
    
  plot_data <- df_merged %>% filter(.data[[id_col]] %in% top_features)
  
  # 5. Create Plot
  p <- ggplot(plot_data, aes(x = sampleid, y = .data[[name_col]], fill = log10(Abundance + 1))) +
    geom_tile() +
    scale_fill_viridis_c(option = "magma") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8),
      axis.text.y = element_text(size = 7),
      plot.title = element_text(hjust = 0.5)
    ) +
    labs(title = title_label, y = "Description", fill = "Log10 Abund")
    
  return(p)
}

# --- Main Execution ---

# Open PDF device for multi-page output
pdf(snakemake@output[["heatmap_pdf"]], width = 12, height = 10)

# Generate and print plots to the PDF
print(generate_plot(snakemake@input[["pathway"]], "Top 30 Pathways", snakemake@input[["metadata"]]))
print(generate_plot(snakemake@input[["ko"]], "Top 30 KOs", snakemake@input[["metadata"]]))
print(generate_plot(snakemake@input[["ec"]], "Top 30 EC Numbers", snakemake@input[["metadata"]]))

dev.off()

message("Success: PDF generated at ", snakemake@output[["heatmap_pdf"]])