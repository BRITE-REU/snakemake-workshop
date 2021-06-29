configfile: "files/config.yaml"

rule all:
    input:
        expand("figures/{dataset}/clusters.png",
               dataset=config['datasets'])

# this should call the download_data.py Python script to download data.
# You will need to tell the script which dataset you want to download, and the
# file name to save the dataset under. The expected extension for the output file
# is an '.h5ad' file. In snakemake, it is good practice to write data files
# produced by each rule to unique directories.
# allowable: paul, moignard, pbmc3k
rule download_data:
    params:
        dataset=lambda wc: wc.dataset
    output:
        adata="data/raw/{dataset}.h5ad"
    script:
        "scripts/download_data.py"

rule preprocess_data:
    input:
        adata="data/raw/{dataset}.h5ad"
    params:
        min_cells=config['preprocess']['min_cells'],
        min_genes=config['preprocess']['min_genes'],
        pct_mito=config['preprocess']['pct_mito'],
        n_hvgs=config['preprocess']['n_hvgs']
    output:
        adata="data/processed/{dataset}.h5ad"
    script:
        "scripts/preprocess.py"

rule cluster_cells:
    input:
        adata="data/processed/{dataset}.h5ad"
    params:
        k=config['cluster']['k'],
        resolution=config['cluster']['resolution'],
    output:
        X="data/clustered/{dataset}/X.csv",
        obs="data/clustered/{dataset}/obs.csv",
        var="data/clustered/{dataset}/var.csv"
    script:
        "scripts/cluster_cells.py"

rule plot_clusters:
    input:
        X="data/clustered/{dataset}/X.csv",
        obs="data/clustered/{dataset}/obs.csv",
        var="data/clustered/{dataset}/var.csv"
    params:
        color="louvain"
    output:
        png=report('figures/{dataset}/clusters.png',
                   caption='report/clusters.rst',
                   category='Clustering',
                   subcategory='{dataset}')
    script:
        "scripts/plot_cells.R"