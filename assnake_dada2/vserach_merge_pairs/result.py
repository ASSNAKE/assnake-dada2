import os
from assnake.core.result import Result

result = Result.from_location(name='vsearch-merge-pairs',
                              description='Merge paired-end reads into one sequence with Vsearch',
                              result_type = 'preprocessing',
                              input_type='illumina_sample',
                              with_presets=True,
                              preset_file_format='yaml',
                              location=os.path.dirname(os.path.abspath(__file__)))