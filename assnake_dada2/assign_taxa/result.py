import os
from assnake.core.Result import Result
from assnake.core.inputs.FeatureTableInput import FeatureTableInput
from assnake.core.inputs.FeatureTableFeatureMeta import FeatureTableFeatureMeta

from assnake_dada2.export_asv_table import Dada2FeatureTable
    

result = Result.from_location(name='dada2-assign-taxa',
                              description='Assign taxonomy using DADA2 algo',
                              result_type = 'feature_table',
                              input_type='feature_table',
                              with_presets=False,
                              preset_file_format='yaml',
                              requires = [Dada2FeatureTable],  
                              produces = [FeatureTableFeatureMeta],
                              location=os.path.dirname(os.path.abspath(__file__)))