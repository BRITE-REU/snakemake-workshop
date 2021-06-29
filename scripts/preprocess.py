import pandas as pd
import numpy as np
import scanpy as sc

def preprocess_cells(adata, min_cells, min_genes, pct_mito, n_hvgs):
    """
    Preprocess and clean up scRNAseq data.

    params
    ------
    adata : sc.AnnData
        dataset to clean
    min_cells : int
        Minimum number of cells a gene must be expressed in order to retain.
    min_genes : int
        Minimum total number of unique genes a cell must express
        in order to retain.
    pct_mito : float
        Maximum percent of reads assigned to mitochondrial reads allowed when
        retaining cells.
    n_hvgs : int
        Number of highly variable genes to retain.
    
    returns
    -------
    sc.AnnData
        Cleaned dataset.
    """
    adata.var_names_make_unique()
    sc.pp.filter_cells(adata, min_genes=min_genes)
    sc.pp.filter_genes(adata, min_cells=min_cells)
    # annotate the group of mitochondrial genes as 'mt'
    adata.var['mt'] = adata.var_names.str.startswith('MT-') 
    sc.pp.calculate_qc_metrics(adata,
                               qc_vars=['mt'],
                               percent_top=None,
                               log1p=False,
                               inplace=True)
    adata = adata[adata.obs.pct_counts_mt < pct_mito, :]
    sc.pp.normalize_total(adata)
    sc.pp.log1p(adata)
    sc.pp.highly_variable_genes(adata,
                                n_top_genes=n_hvgs,
                                flavor='seurat',
                                subset=True)
    return adata

if __name__ == '__main__':
    try:
        snakemake
    except NameError:
        snakemake = None
    if snakemake is not None:
        # read in data
        adata = sc.read(snakemake.input['adata'])
        out = preprocess_cells(adata,
                               snakemake.params['min_cells'],
                               snakemake.params['min_genes'],
                               snakemake.params['pct_mito'],
                               snakemake.params['n_hvgs'])
        adata.write(snakemake.output['adata'])