import os
rule picrust2_tree_insertion:
    input:
        fasta = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/filtered_1_read_total_no_short/raw_seqs.fa'
    output:
        tree  = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/filtered_1_read_total_no_short/placed_seqs.tre'
    params:
        intermediate = '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/filtered_1_read_total_no_short/placement_working'
    log:      '{fs_prefix}/{df}/dada2/{sample_set}/learn_erros__{params}/filtered_1_read_total_no_short/placement_working/log.txt'
    wildcard_constraints:    
        df="[\w\d_-]+",
        params="[\w\d_-]+"
    threads: 20
    conda: 'env.yaml'
    shell: ('(place_seqs.py -s {input.fasta} \
            -o {output.fasta} \
            -p {threads} --intermediate {params.intermediate} --verbose) >{log} 2>&1')




        


        

