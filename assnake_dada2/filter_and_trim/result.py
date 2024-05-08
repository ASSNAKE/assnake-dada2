import os
from assnake.core.Result import Result
from assnake.core.inputs.IlluminaSampleInput import IlluminaSampleInput

result = Result.from_location(name='dada2-filter-and-trim',
                              description='Quality based filtering and trimming from DADA2',
                              result_type = 'preprocessing',
                              input_type='illumina_sample',
                              with_presets=True,
                              preset_file_format='yaml',
                              requires = [IlluminaSampleInput],

                              location=os.path.dirname(os.path.abspath(__file__)))