import yaml

rule dada2_filter_and_trim:
    input: 
        r1 = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R1.fastq.gz',
        r2 = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R2.fastq.gz',
        params = os.path.join(config['assnake_db'], 'params/dada2/filter_and_trim/{params}.yaml')
    output:
        r1 = '{fs_prefix}/{df}/reads/{preproc}__dada2fat_{params}/{sample}_R1.fastq.gz',
        r2 = '{fs_prefix}/{df}/reads/{preproc}__dada2fat_{params}/{sample}_R2.fastq.gz'
    log: '{fs_prefix}/{df}/reads/{preproc}__dada2fat_{params}/{sample}.log'
    wildcard_constraints:    
        df="[\w\d_-]+"
    conda: 'dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2'], 'filter_trim_wrapper.py')

rule dada2_learn_errors:
    input: 
        samples_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples.tsv',
        params = os.path.join(config['assnake_db'], 'params/dada2/learn_errors/{params}.yaml')
    output:
        err          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/err{strand}.rds'
    log:               '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/err{strand}.log'
    threads: 24
    conda: 'dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2'], 'learn_errors_wrapper.py')


rule dada2_derep_infer_pooled:
    input: 
        samples_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples.tsv',
        err          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/err{strand}.rds'
    output:
        infered      = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/dada{strand}.rds',
        derep        = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/derep{strand}.rds',
    threads: 24
    conda: 'dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2'], 'infer_pooled_wrapper.py') 

merge_pooled_script = os.path.join(config['assnake-dada2'], 'scripts/merge_pooled.R')
rule dada2_merge_pooled:
    input: 
        dada_1  = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/dadaR1.rds',
        dada_2  = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/dadaR2.rds',
        derep_1 = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/derepR1.rds',
        derep_2 = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/derepR2.rds',
    output:
        mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/mergers__{min_overlap}.rds',
    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        err_params="[\w\d_-]+",
        # min_overlap="^[0-9]+$"
    threads:24
    conda: 'dada2.yaml'
    shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript {merge_pooled_script} '{input.derep_1}' '{input.derep_2}'  '{input.dada_1}' '{input.dada_2}' '{output.mergers}';''') 



make_seqtab_script = os.path.join(config['assnake-dada2'], 'scripts/make_seqtab.R')
rule dada2_make_seqtab:
    input: mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/mergers__{min_overlap}.rds',
    output:          '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/seqtab__{min_overlap}.rds'
    conda: 'dada2.yaml'
    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        err_params="[\w\d_-]+",
        # min_overlap="^[0-9]+$"
    shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript {make_seqtab_script} '{input.mergers}' '{output}';''') 

seqtab_nochim_script = os.path.join(config['assnake-dada2'], 'scripts/seqtab_nochim.R')
rule dada2_nochim:
    input:  '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/seqtab__{min_overlap}.rds'
    output: '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/seqtab_nochim__{min_overlap}.rds'
    conda: 'dada2.yaml'
    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        err_params="[\w\d_-]+",
        # min_overlap=" ^[0-9]+$"
    threads: 24
    shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript {seqtab_nochim_script} '{input}' '{output}';''') 


assign_taxa_script = os.path.join(config['assnake-dada2'], 'scripts/assign_taxa.R')
db_silva_nr_v132 = config.get('dada2-silva_nr_v132', None)
rule dada2_assign_taxa:
    input: '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/seqtab_nochim__{min_overlap}.rds'
    output: '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{err_params}/taxa_{min_overlap}.rds'
    threads: 24
    conda: 'dada2.yaml'
    shell: ("Rscript {assign_taxa_script} '{input}' '{output}' '{db_silva_nr_v132}' {threads}")

# rule dada2_make_seqtab_sub:
#     input: mergers = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/mergers_{len}.rds'),
#     output: os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/seqtab_{len}.rds')
#     conda: 'dada2.yaml'
#     shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
#         Rscript {make_seqtab_script} '{input.mergers}' '{output}';''') 



# make_tree_script = os.path.join(config['assnake-dada2'], 'scripts/make_tree.R')
# rule make_tree:
#     input: '{fs_prefix}/{df}/dada2/{sample_set}/seqtab_{mod}.rds'
#     output: tree = '{fs_prefix}/{df}/dada2/{sample_set}/tree_{mod}.rds',
#         al = '{fs_prefix}/{df}/dada2/{sample_set}/aligment_{mod}.rds'
#     conda: 'for_tree.yaml'
#     shell: ("Rscript {make_tree_script} '{input}' '{output.tree}' '{output.al}'")

# rule dada2_derep_dada_merge:
#     input: 
#         r1     = '{fs_prefix}/{df}/reads/{preproc}/{sample}/{sample}_R1.fastq.gz',
#         r2     = '{fs_prefix}/{df}/reads/{preproc}/{sample}/{sample}_R2.fastq.gz',
#         errF   = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/errR1.rds'),
#         errR   = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/errR2.rds'),
#         params = os.path.join(config['assnake_db'], 'params/dada2/merge/{params}.yaml')
#     output:
#         merged = '{fs_prefix}/{df}/reads/{preproc}/{sample}/dada2/{sample_set}/{err_params}/merged_{params}.rds',
#         stats  = '{fs_prefix}/{df}/reads/{preproc}/{sample}/dada2/{sample_set}/{err_params}/merged_{params}.stats',
#     log: '{fs_prefix}/{df}/reads/{preproc}/{sample}/dada2/{sample_set}/{err_params}/log_{params}.txt'
#     conda: 'dada2.yaml'
#     wrapper: "file://" + os.path.join(config['assnake-dada2'], 'derep_merge_wrapper.py') 

# rule dada2_derep_infer_pooled_sub:
#     input: 
#         samples_list = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}', 'samples.tsv'),
#         err   = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/err{strand}.rds'),
#     output:
#         infered = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/dada{strand}.rds'),
#         derep = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/derep{strand}.rds'),
#     wildcard_constraints:    
#         err_params="[\w\d_-]+"
#     conda: 'dada2.yaml'
#     wrapper: "file://" + os.path.join(config['assnake-dada2'], 'infer_pooled_wrapper.py') 

# rule dada2_merge_pooled_sub:
#     input: 
#         dada_1 = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/dadaR1.rds'),
#         dada_2 = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/dadaR2.rds'),
#         derep_1 = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/derepR1.rds'),
#         derep_2 = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/derepR2.rds'),
#     output:
#         mergers = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/{sub}/mergers_{len}.rds'),
#     conda: 'dada2.yaml'
#     shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
#         Rscript {merge_pooled_script} '{input.derep_1}' '{input.derep_2}'  '{input.dada_1}' '{input.dada_2}' '{output.mergers}';''') 




# derep_script = os.path.join(config['assnake-dada2'], 'scripts/derep.R')
# # rule dada2_derep:
# #     input:
# #         samples_list = os.path.join(config['dada2_dir'], '{sample_set}/', 'samples.tsv'),
# #         err   = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/err{strand}.rds'),
# #     output:
# #         derep = os.path.join(config['dada2_dir'], '{sample_set}/{err_params}/derep{strand}.rds'),
# #     conda: 'dada2.yaml'
# #     shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
# #         Rscript {derep_script} '{input.samples_list}' '{wildcards.strand}' '{output.derep}';''')