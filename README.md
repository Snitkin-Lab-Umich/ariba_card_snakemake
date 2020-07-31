# Snakemake pipeline to run ARIBA on genomes using CARD, PlasmidFinder, or MLST database

Written by Sophie Hoffman & Zena Lapp.

## Useful links

ARIBA, CARD, PlasmidFinder & MLST:
- [ARIBA wiki](https://github.com/sanger-pathogens/ariba/wiki)
- [CARD website](https://card.mcmaster.ca/) 
- [PlasmidFinder website](https://cge.cbs.dtu.dk//services/PlasmidFinder/instructions.php)
- [MLST github](https://github.com/sanger-pathogens/ariba/wiki/MLST-calling-with-ARIBA)

[Snakemake setup](https://github.com/Snitkin-Lab-Umich/Snakemake_setup)

## Download this repo

First, go to the directory where you want to dowload the repo to. Next, run the following command:
```
git clone https://github.com/Snitkin-Lab-Umich/snakemake_pipelines/ariba_snakemake.git
```

## Snakemake and Conda

Visit this guide to [snakemake setup](https://github.com/Snitkin-Lab-Umich/Snakemake_setup) (including conda) to get started. 

To create and activate the conda environment:
```
conda env create -f config/env.yaml # you only have to do this once
conda activate ariba # you have to do this every time 
```

## Running the ARIBA snakemake pipeline on the cluster

To run the ARIBA snakemake pipeline on the cluster, you have to:
- Modify your email address in `ariba.sbat` and `config/cluster.yaml`
- Modify the fastq file directory path, and potentially the fastq file R1 suffix in the `snakefile`
- Choose which database (CARD, PlasmidFinder, or MLST) you want to run, and modify the `db_dir` path to match the location of that database

Then run:
```
conda activate ariba # if you're not already in the ariba conda environment
sbatch ariba.sbat
```

You can check your job using:
```
squeue -u UNIQNAME
```

The pipeline outputs:
- An `ariba` directory with a subdirectory for each input genome containing the ARIBA results
- Two summary files (the most useful output, in my opinion):
  - `results/ariba_minimal_results.csv` (contains presence/absence, i.e. match,  results from ARIBA output)
  - `results/ariba_all_results.csv` (contains comprhensive results from  ARIBA output, i.e. the following columns for each gene: assembled,match,ref_seq,pct_id,ctg_cov,known_var,novel_var)
