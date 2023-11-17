import os
from assnake.core.Result import Result

result = Result.from_location(name='dada2-derep-infer-merge',
                              description='Dereplicate reads, infer ASVs, merge reads',
                              result_type = 'dada2',
                              input_type='illumina_sample_set',
                              with_presets=False,
                              preset_file_format='yaml',
                              location=os.path.dirname(os.path.abspath(__file__)))