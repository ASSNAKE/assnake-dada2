import os
from assnake.core.Result import Result
from assnake.core.inputs.FeatureTableSpecificationInput import FeatureTableSpecificationInput
from assnake.core.inputs.FeatureTableInput import FeatureTableInput
from assnake.core.inputs.SampleCollectionInput import SampleCollectionInput


class Dada2FeatureTable(FeatureTableInput):
    "Feature Table produced by DADA2 algorithm"
    
result = Result.from_location(name='dada2-export-asv-table',
                              description='Quality based filtering and trimming from DADA2',
                              result_type = 'feature_table',
                              input_type='feature_table_specification',
                              with_presets=True,
                              preset_file_format='yaml',

                            #   depends_on = 'dada2-derep-infer-merge',
                              produces = [Dada2FeatureTable],
                              requires = [SampleCollectionInput, FeatureTableSpecificationInput],  
                              location=os.path.dirname(os.path.abspath(__file__)))