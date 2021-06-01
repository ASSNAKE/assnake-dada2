from snakemake.shell import shell
import yaml
import os

infer_pooled_script = os.path.join(snakemake.config['assnake-dada2']['install_dir'], 'idtaxa/idtaxa.R')

shell('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript  {infer_pooled_script} '{snakemake.input.seqtab}' \
            {snakemake.threads} '{snakemake.output.idtaxa_res}' '{snakemake.output.idtaxa_table}' > {snakemake.log} 2>&1;\n''')