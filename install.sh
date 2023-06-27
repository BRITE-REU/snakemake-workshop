module load miniconda
conda create --name workshop
conda activate workshop
conda install -c conda-forge scanpy pandas r-ggplot2 igraph python-igraph louvain
conda install -c bioconda snakemake
