assign_taxa_script = os.path.join(config['assnake-dada2']['install_dir'], 'assign_taxa/assign_taxa.R')
db_silva_nr99_v138 = config.get('dada2-silva_nr99_v138.1_wSpecies', None)
print(db_silva_nr99_v138)
rule dada2_assign_taxa:
    input:  '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/asv_table.rds'
    output: '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/taxa.rds'
    threads: 50
    conda: '../dada2.yaml'
    wildcard_constraints:    
        df="[\w\d_-]+",
        ft_name="[\w\d_-]+",
        sample_set="[\w\d_-]+",
    shell: ("Rscript {assign_taxa_script} '{input}' '{output}' '{db_silva_nr99_v138}' {threads}")