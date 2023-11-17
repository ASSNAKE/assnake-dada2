rule dada2_export_feature_table:
    input: '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'
    output:'{fs_prefix}/{df}/feature_tables/{sample_set}/dada2_learn_errors_{learn_errors_preset}__core_algo__{core_algo_preset}__merged__{merged_preset}__nonchim__{nonchim_preset}/asv_table.rds'
    wildcard_constraints:    
        df="[\w\d_-]+"
    shell: "cp {input} {output}"