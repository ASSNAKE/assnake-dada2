from snakemake.shell import shell
import yaml
import os

infer_pooled_script = os.path.join(snakemake.config['assnake-dada2']['install_dir'], 'derep_infer_pooled/infer_pooled.R')
shell('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript  {infer_pooled_script} '{snakemake.input.samples_list}' \
            '{snakemake.input.err}' '{snakemake.wildcards.strand}' '{snakemake.output.infered}' '{snakemake.output.derep}';\n''')