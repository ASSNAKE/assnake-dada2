import yaml

def get_dada2_asv_table_path_from_metadata(wildcards):
    # Construct the path to the metadata file using the given wildcards
    ft_meta_loc = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/metadata.yaml'.format(**wildcards)
    
    # Load the metadata from the file
    with open(ft_meta_loc, 'r') as meta_file:
        ft_meta = yaml.safe_load(meta_file)

    # Construct the source file path using the metadata
    source_wc_string = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'

    # Fill in the wildcard values from the metadata
    filled_source_path = source_wc_string.format(
        fs_prefix=wildcards['fs_prefix'],
        df=wildcards['df'],
        sample_set=wildcards['sample_set'],
        **ft_meta
    )

    # Return the filled source file path
    return filled_source_path

def get_dada2_taxa_path_from_metadata(wildcards):
    # Construct the path to the metadata file using the given wildcards
    ft_meta_loc = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/asv_taxa.meta.yaml'.format(**wildcards)
    
    # Load the metadata from the file
    with open(ft_meta_loc, 'r') as meta_file:
        ft_meta = yaml.safe_load(meta_file)

    # Construct the source file path using the metadata
    source_wc_string = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/taxa_{algo}__{db}__{preset}.rds'

    # Fill in the wildcard values from the metadata
    filled_source_path = source_wc_string.format(
        fs_prefix=wildcards['fs_prefix'],
        df=wildcards['df'],
        sample_set=wildcards['sample_set'],
        **ft_meta
    )

    # Return the filled source file path
    return filled_source_path

rule dada2_export_feature_table:
    input:  
        ft_meta = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/metadata.yaml',
        taxa_meta = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/asv_taxa.meta.yaml',
        source_seqtab = get_dada2_asv_table_path_from_metadata,
        source_taxa = get_dada2_taxa_path_from_metadata,
    output: 
        asv_table = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/asv_table.rds',
        taxa_table = '{fs_prefix}/{df}/feature_tables/{sample_set}/{ft_name}/taxa.rds'
    wildcard_constraints:    
        df="[\w\d_-]+",
        ft_name="[\w\d_-]+",
        sample_set="[\w\d_-]+",
    shell: "cp {input.source_seqtab} {output.asv_table}; cp {input.source_taxa} {output.taxa_table}"
