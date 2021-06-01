rule vsearch_merge_pairs:
    input:
        r1 = '{fs_prefix}/{df}/reads/{preproc}/{df_sample}_R1.fastq.gz',
        r2 = '{fs_prefix}/{df}/reads/{preproc}/{df_sample}_R2.fastq.gz',
    output:
        merged = '{fs_prefix}/{df}/reads/{preproc}__vserach_merge_pairs_{preset}/{df_sample}_MERGED.fastq.gz',
    log: '{fs_prefix}/{df}/reads/{preproc}__vserach_merge_pairs_{preset}/{df_sample}_MERGED.log'
    threads: 12
    conda: './env.yaml'
    shell: "vsearch --fastq_mergepairs {input.r1} --reverse {input.r2} --fastqout {output.merged}\
    --fastq_ascii 33\
    --fastq_minlen 1\
    --fastq_minovlen 10\
    --fastq_maxdiffs 10\
    --fastq_qmin 0\
    --fastq_qminout 0\
    --fastq_qmax 41\
    --fastq_qmaxout 41\
    --minseqlength 1\
    --fasta_width 0 > {log} 2>&1;"