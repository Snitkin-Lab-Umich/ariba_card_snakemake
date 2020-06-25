# Snakemake pipeline to run ARIBA on genomes using the CARD antibiotic resistance database 

## Useful links

ARIBA & CARD:
- [ARIBA wiki](https://github.com/sanger-pathogens/ariba/wiki)
- [CARD website](https://card.mcmaster.ca/)

Snakemake:
- [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/)
- [Short overview](https://slides.com/johanneskoester/snakemake-short#/)
- [More detailed overview](https://slides.com/johanneskoester/snakemake-tutorial#/)

## Benefits of snakemake
- Your analysis is reproducible.
- You don't have to re-perform computationally intensive tasks early in the pipeline to change downstream analyses or figures.
- You can easily combine shell, R, python, etc. scritps into one pipeline.
- You can easily share your pipeline with others.
- You can submit a single slurm job and snakemake handles submitting the rest of your jobs for you.

## Download this repo

First, go to the directory where you want to dowload the repo to. Next, run the following command:
```
git clone https://github.com/Snitkin-Lab-Umich/snakemake_pipelines/ariba_card.git
```

## Conda

To [download miniconda](https://docs.conda.io/en/latest/miniconda.html) for linux if you don't already have it:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh
```

To create and activate the conda environment:
```
conda env create -f config/env.yaml # you only have to do this once
conda activate ariba # you have to do this every time 
```

## A few basics

Useful snakemake arguments:
- `snakemake -n` dry-run (to test it out before running it)
- `snakemake` runs the pipeline
- ` snakemake --dag | dot -Tsvg > dag.svg` creates a dag (this can be super difficult to read with large complex pipelines)

## Running the ARIBA CARD snakemake pipeline on the cluster

To run the ARIBA CARD snakemake pipeline on the cluster, you have to:
- Modify your email address in `ariba_card.sbat` and `config/cluster.yaml`
- Modify the fastq file directory path, and potentially the fastq file R1 suffix in the `snakefile`

Then run:
```
sbatch ariba_card.sbat
```

You can check your job using:
```
squeue -u UNIQNAME
```

The pipeline outputs:
- A `card` directory with a subdirectory for each input genome containing the CARD results
- Two summary files (the most useful output, in my opinion):
  - `results/card_minimal_results.csv` (contains presence/absence, i.e. match,  results from ARIBA output)
  - `results/card_all_results.csv` (contains comprhensive results from  ARIBA output, i.e. the following columns for each gene: assembled,match,ref_seq,pct_id,ctg_cov,known_var,novel_var)
