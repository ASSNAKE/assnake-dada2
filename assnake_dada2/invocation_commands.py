import assnake
from tabulate import tabulate
import click
# from assnake.core.sample_set import generic_command_individual_samples, generate_result_list
from assnake.cli.command_builder import sample_set_construction_options, add_options
import os, datetime 
import pandas as pd
from assnake.core.Result import Result


@click.command('dada2-full', short_help='Execute full dada2 pipeline')

@add_options(sample_set_construction_options)
@click.option('--sample-set-name', 
                help='Name of your sample set', 
                default='',
                type=click.STRING )
@click.option('--learn-errors-preset', 
                help='Parameters for learn errors', 
                default='def',
                type=click.STRING )
@click.option('--core-algo-preset', 
                help='Parameters for core dada2 algo', 
                default='def',
                type=click.STRING )
@click.option('--merged-preset', 
                help='Parameters for merging', 
                default='def',
                type=click.STRING )
@click.option('--nonchim-preset', 
                help='Parameters for removing chimeras', 
                default='def',
                type=click.STRING )


@click.pass_obj
def dada2_full(config, sample_set_name, learn_errors_preset, core_algo_preset, merged_preset, nonchim_preset, **kwargs):

    # check if database initialized
    if config['config'].get('dada2-silva_nr_v132', None) is None:
        click.secho('Silva database not initialized!', fg='red')
        click.echo('run ' + click.style('assnake init dada2-silva-db', bg='blue') + ' and follow instructions')
        exit()

    # load sample set     
    sample_set, sample_set_name_gen = generic_command_individual_samples(config,  **kwargs)
    if sample_set_name == '':
        sample_set_name = sample_set_name_gen

    learn_errors_result = Result.get_result_by_name('dada2-learn-errors')
    learn_errors_preset = learn_errors_result.preset_manager.find_preset_by_name(learn_errors_preset)
    if learn_errors_preset is not None:
        learn_errors_preset = learn_errors_preset['full_name']
    else:
        click.secho('NO SUCH PRESET', fg='red')
        exit()
    # Prepare sample set file
    res_list = prepare_sample_set_tsv_and_get_results(sample_set, sample_set_name, 
            wc_config = config['wc_config'], 
            learn_errors_preset = learn_errors_preset, 
            core_algo_preset = core_algo_preset, 
            merged_preset = merged_preset, 
            nonchim_preset = nonchim_preset)

    config['requests'] += res_list

def prepare_sample_set_tsv_and_get_results(sample_set, sample_set_name, wc_config,  **kwargs):

    dfs = list(set(sample_set['df']))
    if len(dfs) == 1:
        fs_prefix = list(set(sample_set['fs_prefix']))[0]

    dada2_set_dir_wc = '{fs_prefix}/{df}/dada2/{sample_set_name}'
    dada2_set_dir = '{fs_prefix}/{df}/dada2/{sample_set_name}/'.format(fs_prefix = fs_prefix, df = dfs[0], sample_set_name = sample_set_name)
    from string import Formatter
    import string
    field_names = [name for text, name, spec, conv in string.Formatter().parse(dada2_set_dir_wc)]

    # print(field_names)

    # lst = { }

    # print(dada2_set_dir_wc.format( **{key:value for key,value in kwargs.items() if key in field_names} ))

    dada2_dicts = []
    for s in sample_set.to_dict(orient='records'):
        # print(s)
        dada2_dicts.append(dict(mg_sample=s['df_sample'],
        R1 = wc_config['fastq_gz_file_wc'].format(fs_prefix=s['fs_prefix'], df=s['df'], preproc=s['preproc'], df_sample = s['df_sample'], strand = 'R1'), 
        R2 = wc_config['fastq_gz_file_wc'].format(fs_prefix=s['fs_prefix'], df=s['df'], preproc=s['preproc'], df_sample = s['df_sample'], strand = 'R2'),
        # merged = sample_set.wc_config['dada2_merged_wc'].format(prefix=s['fs_prefix'], df=s['df'], preproc=s['preproc'], sample = s['fs_name'], sample_set = set_name)
        ))
    if not os.path.exists(dada2_set_dir):
        os.makedirs(dada2_set_dir, exist_ok=True)

    dada2_df = pd.DataFrame(dada2_dicts)
    if not os.path.isfile(os.path.join(dada2_set_dir, 'samples.tsv')):
        dada2_df.to_csv(os.path.join(dada2_set_dir, 'samples.tsv'), sep='\t', index=False)

    res_list = ['{fs_prefix}/{df}/dada2/{sample_set}/learn_errors__{learn_errors_preset}/core_algo__{core_algo_preset}/merged__{merged_preset}/nonchim__{nonchim_preset}/seqtab.rds'.format(
        fs_prefix = fs_prefix,
        df = dfs[0],
        sample_set = sample_set_name,
        learn_errors_preset = kwargs['learn_errors_preset'],
        core_algo_preset = kwargs['core_algo_preset'], 
        merged_preset    = kwargs['merged_preset'],
        nonchim_preset   = kwargs['nonchim_preset']
    )]

    return res_list
