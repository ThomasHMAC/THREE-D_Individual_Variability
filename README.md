# THREE-D Individual Variability
Individual variability analysis using THREE-D dataset

## Dependencies:
```R-studio
connectome-workbench/1.3.2 
ciftify/2.3.3```

## Requirements:
1. Functional connectivity map converted to text file using connectome-workbench (i.e wb_command -cifti-convert -to-text)

## Pipelines:
3D_analysis.Rmd - perform calculation of Mean Correlational Distance (MCD);
                - statistical analysis (i.e linear mix model)
                - plotting
                - Tables

ind_var_figure.R - plot pairwise correlational distance matrix
