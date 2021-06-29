library(ggplot2)

plot_cells <- function(obs, x, y, color) {
    p <- ggplot(obs, aes_string(x=x, y=y, color=color)) +
        geom_point()
    return(p)
}

if (exists('snakemake')) {
    X <- read.csv(snakemake@input[['X']], header=FALSE, row.names=NULL)
    obs <- read.csv(snakemake@input[['obs']], header=TRUE, row.names=1)
    var <- read.csv(snakemake@input[['var']], header=TRUE, row.names=1)

    p <- plot_cells(obs, x='umap1', y='umap2', color=snakemake.params['louvain'])
    ## TO DO: Add line to save plot
}