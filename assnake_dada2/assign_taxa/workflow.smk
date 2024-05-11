assign_taxa_script = os.path.join(config['assnake-dada2']['install_dir'], 'assign_taxa/assign_taxa.R')
db_silva_nr99_v138 = config.get('dada2-silva_nr99_v138.1_wSpecies', None)
print(db_silva_nr99_v138)


rule dada2_assign_taxa:
    # input:  '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/asv_table.rds'
    # output: '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/taxa.rds'
    input:  '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'
    output: '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/taxa_{taxa_algo_preset}__{db_preset}__{pr_preset}.rds'
    threads: 50
    conda: '../dada2.yaml'
    wildcard_constraints:    
        df="[\w\d_-]+",
        ft_name="[\w\d_-]+",
        sample_set="[\w\d_-]+",
    shell: ("Rscript {assign_taxa_script} '{input}' '{output}' '{db_silva_nr99_v138}' {threads}")