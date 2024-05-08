from snakemake.shell import shell
import yaml
import os

infer_pooled_script = os.path.join(snakemake.config['assnake-dada2']['install_dir'], 'derep_infer_merge/derep_infer_merge.R')

shell(
    '''
    export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
    Rscript {infer_pooled_script} \
        --input-file {snakemake.input.samples_list_r1} \
        --errR1 {snakemake.input.errR1} \
        --errR2 {snakemake.input.errR2} \
        --output-file {snakemake.output.mergers} \
        --threads {snakemake.threads} \
        --read-tracking {snakemake.output.track} \
        --seqtab-output {snakemake.output.seqtab} \
        > {snakemake.log} 2>&1''')