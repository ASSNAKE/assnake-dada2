rule dada2_derep_infer_pooled_merge:
    input: 
        samples_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples.tsv',
        errR1          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/errR1.rds',
        errR2          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/errR2.rds',
    output:
        mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/mergers__{min_overlap}.rds',
        track = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/derep_dada_merge__{min_overlap}.reads_count.tsv'
    log: '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/derep_dada_merge__{min_overlap}.log'

    wildcard_constraints:    
        sample_set="[\w\d_-]+",
    threads: 24
    conda: '../dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2']['install_dir'], 'derep_infer_merge/wrapper.py') 