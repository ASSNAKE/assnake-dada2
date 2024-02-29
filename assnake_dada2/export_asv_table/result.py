import os
from assnake.core.Result import Result

result = Result.from_location(name='dada2-export-asv-table',
                              description='Quality based filtering and trimming from DADA2',
                              result_type = 'feature_table',
                              input_type='feature_table_specification',
                              with_presets=False,
                              preset_file_format='yaml',
                              location=os.path.dirname(os.path.abspath(__file__)))