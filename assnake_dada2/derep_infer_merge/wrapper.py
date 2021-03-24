from snakemake.shell import shell
import yaml
import os

infer_pooled_script = os.path.join(snakemake.config['assnake-dada2']['install_dir'], 'derep_infer_merge/derep_infer_merge.R')

shell('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript  {infer_pooled_script} '{snakemake.input.samples_list}' \
            '{snakemake.input.errR1}' '{snakemake.input.errR2}' '{snakemake.output.mergers}' {snakemake.threads} '{snakemake.output.track}' > {snakemake.log} 2>&1;\n''')