import os
import pandas as pd

def get_files_for_links_for_deblur(wildcards):
    fastqc_list = []
    sample_set_loc = '{fs_prefix}/{df}/deblur/{sample_set}/sample_set.tsv'.format(**wildcards)
    sample_set = pd.read_csv(sample_set_loc, sep = '\t')
    for s in sample_set.to_dict(orient='records'):
        fastqc_list.append('{fs_prefix}/{df}/reads/{preproc}__vserach_merge_pairs_{preset}/{df_sample}_MERGED.fastq.gz'.format(df = s['df'], fs_prefix = s['fs_prefix'], df_sample = s['df_sample'], preproc = s['preproc']))
    return fastqc_list

def final_files_for_deblur(wildcards):
    fastqc_list = []
    sample_set_loc = '{fs_prefix}/{df}/deblur/{sample_set}/sample_set.tsv'.format(**wildcards)
    sample_set = pd.read_csv(sample_set_loc, sep = '\t')

    os.makedirs('{fs_prefix}/{df}/deblur/{sample_set}/reads/'.format(**wildcards), exist_ok = True)
    for s in sample_set.to_dict(orient='records'):
        fastqc_list.append('{fs_prefix}/{df}/deblur/{sample_set}/reads/{df_sample}.fastq.gz'.format(df = s['df'], 
            fs_prefix = s['fs_prefix'], 
            df_sample = s['df_sample'], 
            preproc = s['preproc'],
            sample_set = wildcards.sample_set
            )
        )
    return fastqc_list


rule prepare_folder_with_links:
    input:
        sample_set_loc = '{fs_prefix}/{df}/deblur/{sample_set}/sample_set.tsv',
        original_files = final_files_for_deblur
    output: 
        # final_files = final_files_for_deblur,
        done = '{fs_prefix}/{df}/deblur/{sample_set}/reads_linked.done'
    run: 
        print(input.original_files)
        print(output.final_files)
        


rule deblur_workflow:
    input: 
        done = '{fs_prefix}/{df}/deblur/{sample_set}/reads_linked.done',
        sample_set_loc = '{fs_prefix}/{df}/deblur/{sample_set}/sample_set.tsv',
    output:
        biom          = '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/all.biom'
    params:
        out_dir = '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/',
        tmp_reads_dir = '{fs_prefix}/{df}/deblur/{sample_set}/reads/'
    log:               '{fs_prefix}/{df}/deblur/{sample_set}/{preset}/deblur.log'
    threads: 24
    conda: '../dada2.yaml'
    shell: ("""deblur workflow --seqs-fp ./ --output-dir {out_dir}\
    --trim-length 300 -a 2 -O 60 --error-dist 1,0.06,0.02,0.02,0.01,0.005,0.005,0.005,0.001,0.001,0.001,0.0005\
    --overwrite --log-file {log}""")



