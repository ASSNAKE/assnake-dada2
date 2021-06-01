rule idTaxa_annotate_16s:
    input: 
        seqtab  = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'
    output:
        idtaxa_res = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/idtaxa_res.rds',
        idtaxa_table = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/idtaxa.tsv'
    log: '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/idtaxa.log'

    wildcard_constraints:    
        sample_set="[\w\d_-]+",
    threads: 100
    conda: './env.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2']['install_dir'], 'idtaxa/wrapper.py') 

# seqtab = `dada2/{sample_set}/{learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/seqtab__{seqtab_preset}/filtering__{filtering_preset}/seqtab.rds`,
# seqs = `dada2/{sample_set}/{learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/seqtab__{seqtab_preset}/filtering__{filtering_preset}/sequences.fa`,



