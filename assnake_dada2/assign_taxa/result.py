import os
from assnake.core.Result import Result

result = Result.from_location(name='dada2-assign-taxa',
                              description='Assign taxonomy using DADA2 algo',
                              result_type = 'feature_table',
                              input_type='feature_table',
                              with_presets=False,
                              preset_file_format='yaml',
                              location=os.path.dirname(os.path.abspath(__file__)))