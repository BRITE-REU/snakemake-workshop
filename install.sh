module load anaconda3
conda create --name workshop seaborn scikit-learn statsmodels numba pytables
conda activate workshop
conda install -c conda-forge python-igraph leidenalg
pip install scanpy
