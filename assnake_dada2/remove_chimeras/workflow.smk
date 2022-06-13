seqtab_nochim_script = os.path.join(config['assnake-dada2']['install_dir'], 'remove_chimeras/seqtab_nochim.R')
rule dada2_nochim:
    input:  '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/seqtab.rds'
    output: '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'
    conda: '../dada2.yaml'
    wildcard_constraints:    
        sample_set="[\w\d_-]+",
        merged_preset="[\w\d_-]+",
        # min_overlap=" ^[0-9]+$"
    threads: 120
    shell: ('''export LANG=en_US.UTF-8;\nexport LC_ALL=en_US.UTF-8;\n
        Rscript {seqtab_nochim_script} '{input}' '{output}' {threads};''') 
