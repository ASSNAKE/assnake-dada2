# rule dada2_derep_infer_pooled_merge:
#     input: 
#         samples_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples.tsv',
#         errR1          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/errR1.rds',
#         errR2          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/errR2.rds',
#     output:
#         mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/mergers__{min_overlap}.rds',
#         track = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/derep_dada_merge__{min_overlap}.reads_count.tsv'
#     log: '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{params}/derep_dada_merge__{min_overlap}.log'

#     wildcard_constraints:    
#         sample_set="[\w\d_-]+",
#     threads: 24
#     conda: '../dada2.yaml'
#     wrapper: "file://" + os.path.join(config['assnake-dada2']['install_dir'], 'derep_infer_merge/wrapper.py') 

rule dada2_derep_infer_pooled_merge:
    input: 
        samples_list_r1   = '{fs_prefix}/{df}/dada2/{sample_set}/samples_R1.tsv',
        samples_list_r2   = '{fs_prefix}/{df}/dada2/{sample_set}/samples_R2.tsv',
        errR1          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/err_R1.rds',
        errR2          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/err_R2.rds',
    output:
        mergers = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/merged.rds',
        seqtab =  '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/seqtab.rds',
        track =   '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/reads_count.tsv'
    log:          '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/derep_dada_merge.log'

    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        merged_preset="[\w\d_-]+",
    threads: 48
    conda: '../dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2']['install_dir'], 'derep_infer_merge/wrapper.py') 
