
import os
from assnake.core.Result import Result

result = Result.from_location(name='dada2-create-phyloseq',
                              description='Create phyloseq object from provided otu and taxa rds files',
                              result_type='phyloseq',
                              input_type='illumina_sample_set',
                              with_presets=True,
                              preset_file_format='yaml',
                              location=os.path.dirname(os.path.abspath(__file__)))
