import os
from assnake.core.Result import Result
from assnake.core.inputs.FeatureTableInput import FeatureTableInput
from assnake.core.inputs.FeatureTableFeatureMeta import FeatureTableFeatureMeta

from assnake_dada2.assign_taxa.result import AsvTaxaTable
from assnake_dada2.export_asv_table import Dada2FeatureTable
    

result = Result.from_location(name='decipher-idTaxa',
                              description='Assign taxonomy using idTaxa',
                              result_type = 'feature_table',
                              input_type='feature_table',
                              with_presets=False,
                              preset_file_format='yaml',
                              requires = [Dada2FeatureTable],  
                              produces = [AsvTaxaTable],
                              location=os.path.dirname(os.path.abspath(__file__)))