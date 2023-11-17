def get_fastq_gz_files_for_dada2(wildcards):
    fastqc_list = []
    sample_set_loc = '{fs_prefix}/{df}/dada2/{sample_set}/sample_set.tsv'.format(**wildcards)
    sample_set = pd.read_csv(sample_set_loc, sep = '\t')
    for s in sample_set.to_dict(orient='records'):
        fastqc_list.append(wc_config['fastq_gz_file_wc'].format(df = s['df'], fs_prefix = s['fs_prefix'], df_sample = s['df_sample'], preproc = s['preproc'], strand = wildcards.strand))
    return fastqc_list

rule dada2_list_from_sample_set:
    input:  
        sample_set_loc = '{fs_prefix}/{df}/dada2/{sample_set}/sample_set.tsv',
        fastqc_data = get_fastq_gz_files_for_dada2
    output: sample_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples_{strand}.tsv',
    run: 
        sample_set = pd.read_csv(input.sample_set_loc, sep = '\t')
        
        dada2_dicts = []
        for s in sample_set.to_dict(orient='records'):
            dada2_dicts.append(dict(
                mg_sample=s['df_sample'],
                R1 = wc_config['fastq_gz_file_wc'].format(fs_prefix=s['fs_prefix'], df=s['df'], preproc=s['preproc'], df_sample = s['df_sample'], strand = 'R1'), 
                R2 = wc_config['fastq_gz_file_wc'].format(fs_prefix=s['fs_prefix'], df=s['df'], preproc=s['preproc'], df_sample = s['df_sample'], strand = 'R2'),
            ))
        dada2_df = pd.DataFrame(dada2_dicts)
        # os.makedirs(os.path.basepath(input.sample_set_loc), exist_ok=True)

        if not os.path.isfile(output.sample_list):
            dada2_df.to_csv(output.sample_list, sep='\t', index=False)

rule dada2_learn_errors:
    input: 
        samples_list = '{fs_prefix}/{df}/dada2/{sample_set}/samples_{strand}.tsv',
        preset = os.path.join(config['assnake_db'], 'presets/dada2-learn-errors/{preset}.yaml')
    output:
        err          = '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{preset}/err{strand}.rds'
    log:               '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{preset}/err{strand}.log'
    threads: 50
    conda: '../dada2.yaml'
    wrapper: "file://" + os.path.join(config['assnake-dada2']['install_dir'], './learn_errors/learn_errors_wrapper.py')
