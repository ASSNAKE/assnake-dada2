merge_pooled_script = os.path.join(config['assnake-dada2']['install_dir'], 'merge/merge_pooled.R')
print('INCLUDED')
rule dada2_merge_pooled22:
    input: 
        samples_list   = '{fs_prefix}/{df}/dada2/{sample_set}/samples_R1.tsv',
        errR1          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/errR1.rds',
        errR2          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/errR2.rds',
    output:
        mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/mergers.rds',
        mergers2= '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/core_algo/merged/merged.rds',

    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        # err_params="[\w\d_-]+",
        # min_overlap="^[0-9]+$"
    threads:1
    conda: '../dada2.yaml'
    shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript {merge_pooled_script} '{input.derep_1}' '{input.derep_2}'  '{input.dada_1}' '{input.dada_2}' '{output.mergers}';''') 
