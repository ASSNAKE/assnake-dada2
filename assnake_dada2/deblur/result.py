
import click, os
from assnake.core.result import Result

result = Result.from_location(name='deblur',
                              description='Ultra-fast and memory-efficient NGS assembler',
                              result_type='assembly',
                              input_type='illumina_sample_set',
                              with_presets=True,
                              location=os.path.dirname(os.path.abspath(__file__))
                              )