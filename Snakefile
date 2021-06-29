configfile: "files/config.yaml"

# this should call the download_data.py Python script to download data.
# You will need to tell the script which dataset you want to download, and the
# file name to save the dataset under. The expected extension for the output file
# is an '.h5ad' file. In snakemake, it is good practice to write data files
# produced by each rule to unique directories.
rule download_data:
    params:
        dataset="pbmc3k"
    output:
        "data/raw/pbmc3k.h5ad"
    script:
        "scripts/download_data.py"

rule preprocess_data:
    input:
        "data/raw/pbmc3k.h5ad"
    params:
        min_cells=3,
        min_genes=200,
    output:
        "data/processed/pbmc3k.h5ad"
    script:
        "scripts/preprocess.py"

rule cluster_cells:
    input:
        "data/processed/pbmc3k.h5ad"
    params:
        k=15,
        resolution=1
    output:
        X="data/clustered/X.csv",
        obs="data/clustered/obs.csv",
        var="data/clustered/var.csv"
    script:
        "scripts/clsuter_cells.py"

rule plot_clusters:
    input:
        X="data/clustered/X.csv",
        obs="data/clustered/obs.csv",
        var="data/clustered/var.csv"
    params:
        color="louvain"
    output:
        report()