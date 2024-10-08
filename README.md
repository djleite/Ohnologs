# Ohnologs
Ohnolog prediction workflow


## Overview
This pipeline uses Orthofinder (Emms et al 2019) and a previously published ohnolog prediction tool (Singh et al 2015; 2019). The original ohnolog pipeline (https://github.com/SinghLabUCSF/Ohnologs-v2.0) was modified with some multi-processing to reduce run times.

Please follow the installation of these tools and dependencies. The run_iterate_whole_pipeline.sh script uses a conda environment called "ohnologs", which can be created with the "requirements.txt" file.



Inputs are:
- Protein fastas. These need to be in the raw_pipline folder.
- Tab delimited "gene order" coordinate files of genes. (gene, strand[1/-1], chromosome, start, end). These need to be in the raw_pipline folder.
- Species list with each species per line. This needs to be in the raw_pipline folder.

IMPORTANT NOTE: Naming convention should follow that each gene ID has the species ID e.g. TARGIG, followed by the gene ID _g10000, i.e. TACGIG_g10000. The species list should contain this TACGIG ID.

Example data of protein fastas, gene order and species list files have been provided.

/results - contains the final results for spiders and hsc ohnologs at orthofinder inflation parameters 1.4, 1.5, and 1.6 and at the four z-score thresholds 0, A, B, and C

