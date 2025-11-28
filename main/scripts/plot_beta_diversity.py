import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from qiime2 import Artifact
from skbio.stats.ordination import OrdinationResults

jaccard_path = snakemake.input.jaccard_pcoa 
braycurtis_path = snakemake.input.braycurtis_pcoa
unweighted_path = snakemake.input.unweighted_pcoa
weighted_path = snakemake.input.weighted_pcoa
metadata_path = snakemake.input.metadata_path
output_dir = snakemake.input.diversity_dir

group_columns = snakemake.params.group_columns

# ... (Original code to load PCoA results, metadata, and define n_pcs, output_dir) ...
# Load PCoA results
pcoa_results = {
    "Bray-Curtis": Artifact.load(braycurtis_path).view(OrdinationResults),
    "Jaccard": Artifact.load(jaccard_path).view(OrdinationResults),
    "Weighted": Artifact.load(weighted_path).view(OrdinationResults),
    "Unweighted": Artifact.load(unweighted_path).view(OrdinationResults),
}

metadata = pd.read_csv("metadata.tsv", sep="\t", index_col=0)

# Strip whitespace from all string/object columns
for col_name in metadata.select_dtypes(include=['object']).columns:
    metadata[col_name] = metadata[col_name].str.strip()
n_pcs = len(metadata) - 1

# Define the columns for grouping and filtering
Group_Column = "Group"
Subject_Column = "Subject"
Target_Groups = ['N', 'Y']

comparisons = [
    (Subject_Column, Target_Groups) # Plot by Subject, filtered to N and Y
] 

# --- New settings for the plot ---
DRAW_ELLIPSES = True
# Define colors for the N and Y groups for the ellipses and legend
GROUP_COLORS = {'N': 'blue', 'Y': 'red'} 

for col, filter_values in comparisons:
    if col not in metadata.columns:
        print(f"Warning: Column '{col}' not found in metadata. Skipping.")
        continue
    if Group_Column not in metadata.columns:
         print(f"Error: Group column '{Group_Column}' not found in metadata. Exiting.")
         break

    fig, axes = plt.subplots(2, 2, figsize=(14, 12))
    axes = axes.flatten()

    for ax, (distance_metric, pcoa_res) in zip(axes, pcoa_results.items()):
        coords = pcoa_res.samples
        df = coords.merge(metadata, left_index=True, right_index=True)
        df.rename(columns={i: f'PC{i+1}' for i in range(n_pcs)}, inplace=True)

        df_subset = df.copy()
        if filter_values is not None:
            df_subset = df_subset[df_subset[Group_Column].isin(filter_values)]
        
        # ... (Checks for empty data or missing PCs omitted for brevity) ...

        # --- Color by Subject (col) ---
        hue_col = col 
        unique_subjects = df_subset[hue_col].dropna().unique()
        # Use a large palette for subjects
        subject_palette = sns.color_palette('hls', n_colors=len(unique_subjects)) 
        subject_to_color = dict(zip(unique_subjects, subject_palette))

        # Scatter plot: Color by Subject, Style by Group (N/Y)
        sns.scatterplot(
            x="PC1",
            y="PC2",
            hue=hue_col,     # Color by 'Subject'
            style=Group_Column, # Use shape/style to differentiate 'N' and 'Y'
            data=df_subset,
            s=100,
            alpha=0.8,
            palette=subject_to_color,
            ax=ax,
            legend=False # Hide scatterplot legend for manual placement later
        )
        
        # ----------------------------------------------------------------------
        # 1. MODIFICATION: Draw Ellipses by Group (N vs Y)
        # ----------------------------------------------------------------------
        if DRAW_ELLIPSES:
            for group, color in GROUP_COLORS.items():
                data_subset = df_subset[df_subset[Group_Column] == group]
                
                if len(data_subset) < 2:
                    continue
                
                # Check for zero variance to prevent division by zero for std()
                if data_subset["PC1"].std() == 0 or data_subset["PC2"].std() == 0:
                     continue

                centroid_x = data_subset["PC1"].mean()
                centroid_y = data_subset["PC2"].mean()
                
                # Calculate variance/spread across all subjects in that group (N or Y)
                width = data_subset["PC1"].std() * 2 # Represents 2 standard deviations
                height = data_subset["PC2"].std() * 2 
                
                ellipse = Ellipse(
                    (centroid_x, centroid_y),
                    width=width, height=height,
                    edgecolor=color, # Color based on N or Y
                    facecolor=color, lw=2, alpha=0.1, zorder=5 # Light fill for visibility
                )
                ax.add_patch(ellipse)
                
                # Draw Centroid
                ax.scatter(centroid_x, centroid_y, marker='D', 
                           color=color, s=150, zorder=10, 
                           label=f'{group} Centroid') # Use a distinct marker for group centroid

        # ----------------------------------------------------------------------
        # 2. Draw N -> Y Transition Arrows
        # ----------------------------------------------------------------------
        paired_subjects = df_subset.groupby(col)[Group_Column].nunique()
        paired_subjects = paired_subjects[paired_subjects >= 2].index

        for subject in paired_subjects:
            subject_data = df_subset[df_subset[col] == subject].sort_values(Group_Column) 
            n_sample = subject_data[subject_data[Group_Column] == 'N']
            y_sample = subject_data[subject_data[Group_Column] == 'Y']

            if not n_sample.empty and not y_sample.empty:
                x_n, y_n = n_sample['PC1'].iloc[0], n_sample['PC2'].iloc[0]
                x_y, y_y = y_sample['PC1'].iloc[0], y_sample['PC2'].iloc[0]
                
                # Use the subject's color for the arrow
                arrow_color = subject_to_color.get(subject, 'gray') 

                ax.annotate(
                    '', xy=(x_y, y_y), xytext=(x_n, y_n),
                    arrowprops=dict(
                        arrowstyle="->", 
                        color=arrow_color, 
                        lw=1.5, 
                        linestyle='-', 
                        alpha=0.6,
                        connectionstyle="arc3,rad=0.0"
                    ),
                    zorder=1
                )
        
        ax.set_title(distance_metric)
        ax.set_xlabel("PC1")
        ax.set_ylabel("PC2")
        
    # Combine legend outside grid (Focus on Group, Centroid, and Arrow)
    
    # 1. Group Ellipse/Centroid Legend
    group_handles = [plt.Line2D([0], [0], marker='D', color='w', 
                                markerfacecolor=GROUP_COLORS[g], 
                                markersize=10, linestyle='', alpha=1.0) 
                     for g in Target_Groups]
    group_labels = [f"Group {g} Centroid ($\pm$ 2 SD Ellipse)" for g in Target_Groups]
    
    # 2. N/Y Point Style Legend (re-used from scatterplot)
    point_handles = [plt.Line2D([0], [0], marker=marker, color='k', markersize=8, linestyle='') 
                     for marker in ['x', 'o']] 
    point_labels = [f"Time Point {label}" for label in Target_Groups]
    
    # 3. Arrow Handle
    arrow_handle = plt.Line2D([0], [0], color='gray', lw=1.5, linestyle='-', marker='>', markersize=5)
    
    final_handles = group_handles + point_handles + [arrow_handle]
    final_labels = group_labels + point_labels + ["Subject Transition (N $\\rightarrow$ Y)"]

    
    fig.legend(final_handles, final_labels, 
               title="Visualization Key", 
               bbox_to_anchor=(1.05, 0.5), loc='center left')
    
    
    subset_label = "paired_by_subject_w_group_ellipse"
    fig.suptitle(f"Paired PCoA comparison: Variance by Group (N/Y), Points Colored by Subject", fontsize=16)

    plt.tight_layout(rect=[0, 0, 0.85, 0.95])

    filename = f"PCoA_paired_by_subject_w_group_ellipse_{col}_{subset_label}.svg"
    filepath = os.path.join(output_dir, filename)
    plt.savefig(filepath, dpi=300)
    plt.close()