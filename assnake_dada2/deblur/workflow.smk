rule deblur_workflow:
    input: 
        samples_list = '{fs_prefix}/{df}/deblur/{sample_set}/sample_set.tsv',
        preset = os.path.join(config['assnake_db'], 'presets/dada2-learn-errors/{preset}.yaml')
    output:
        biom          = '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/all.biom'
    params:
        out_dir = '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/',
        tmp_reads_dir = '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/tmp_reads/'
    log:               '{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{preset}/err{strand}.log'
    threads: 24
    conda: '../dada2.yaml'
    shell: ("""deblur workflow --seqs-fp ./ --output-dir {out_dir}\
    --trim-length 300 -a 2 -O 60 --error-dist 1,0.06,0.02,0.02,0.01,0.005,0.005,0.005,0.001,0.001,0.001,0.0005\
    --overwrite --log-file {log}""")



