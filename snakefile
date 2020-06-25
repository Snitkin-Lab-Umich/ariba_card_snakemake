import glob
import re

# fastq directory path
fastq_dir = '/nfs/esnitkin/Project_CRE_EIP/Sequence_data/fastq/' #"/path/to/fastq/dir/" # CHANGE THIS (include last / for directory)

# fastq file R1 suffix
fastq_R1_suffix = "_R1_001.fastq.gz" # MAYBE CHANGE THIS

# generate strings used later in script
infiles_path = fastq_dir +  "*" + fastq_R1_suffix
sub_string = fastq_dir + "|" + fastq_R1_suffix
infile = fastq_dir + "{smp}" + fastq_R1_suffix

# get list of input files
infiles = glob.glob(infiles_path)

# get list of sample names
samps = [re.sub(sub_string,'',x) for x in infiles]

# CARD database directory (you can change this if you want to use a different database)
db_dir='/nfs/esnitkin/bin_group/database/ariba/CARD/CARD_db/'

# Output files we want to generate
rule all:
  input:
    'results/card_minimal_results.csv',
    'results/card_all_results.csv'

# Run ARIBA on each set of fastq files (R1 and r2)
rule run_ariba:
  input:
    db_dir=db_dir,
    infile=infile
  output:
    'card/{smp}/report.tsv'
  shell:
    "db_dir={input.db_dir};"
    "samp={input.infile};"
    "samp2=${{samp//R1/R2}};" #reverse reads
    "outdir=card/{wildcards.smp};"
    "echo $samp; echo $samp2; echo $outdir;"
    #"samp2=${{samp//_R1_001.fastq/_R2_001.fastq}};" #reverse reads
    #"outdir=card/$(echo ${{samp//_R1_001.fastq.gz/}} | cut -d/ -f7);"
    "ariba run --force $db_dir $samp $samp2 $outdir;" #ariba command

# Get presence/absence profile for each isolate and gene/variant
rule summarize_ariba_minimal:
  input:
    expand('card/{samp}/report.tsv',samp=samps)
  output:
    'results/card_minimal_results.csv'
  shell:
    "ariba summary --preset minimal results/card_minimal_results {input}"

# Get more complete results about ARIBA output
rule summarize_ariba_all:
  input:
    expand('card/{samp}/report.tsv',samp=samps)
  output:
    'results/card_all_results.csv'
  shell:
    "ariba summary --preset all results/card_all_results {input}"

    
