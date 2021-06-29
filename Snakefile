configfile: "files/config.yaml"

rule all:
    input:
        "figures/pbmc3k/clusters.png"

# this should call the download_data.py Python script to download data.
# You will need to tell the script which dataset you want to download, and the
# file name to save the dataset under. The expected extension for the output file
# is an '.h5ad' file. In snakemake, it is good practice to write data files
# produced by each rule to unique directories.
# allowable: paul, moignard, pbmc3k
rule download_data:
    params:
        dataset="pbmc3k"
    output:
        adata="data/raw/pbmc3k.h5ad"
    script:
        "scripts/download_data.py"

rule preprocess_data:
    input:
        "data/raw/pbmc3k.h5ad"
    params:
        min_cells=config['preprocess']['min_cells'],
        min_genes=config['preprocess']['min_genes'],
        pct_mito=config['preprocess']['pct_mito'],
        n_hvgs=config['preprocess']['n_hvgs']
    output:
        "data/processed/pbmc3k.h5ad"
    script:
        "scripts/preprocess.py"

rule cluster_cells:
    input:
        "data/processed/pbmc3k.h5ad"
    params:
        k=config['cluster']['k'],
        resolution=config['cluster']['resolution'],
    output:
        X="data/clustered/pbmc3k/X.csv",
        obs="data/clustered/pbmc3k/obs.csv",
        var="data/clustered/pbmc3k/var.csv"
    script:
        "scripts/cluster_cells.py"

rule plot_clusters:
    input:
        X="data/clustered/pbmc3k/X.csv",
        obs="data/clustered/pbmc3k/obs.csv",
        var="data/clustered/pbmc3k/var.csv"
    params:
        color="louvain"
    output:
        report('figures/pbmc3k/clusters.png')
    script:
        "scripts/plot_cells.R"