"""Audit the Phase 0d feasibility budget against the current RGBDS link map."""
from pathlib import Path
import csv
import json
import re

ROOT=Path(__file__).resolve().parents[1]


def audit():
    text=(ROOT/'build/main.map').read_text()
    sections={name: int(size,16) for size,name in re.findall(
        r'SECTION:.*\(\$([0-9a-fA-F]+) bytes?\) \["([^"]+)"\]',text)}
    totals={}
    with (ROOT/'notes/SGB_WRAM.tsv').open() as source:
        for row in csv.DictReader(source,delimiter='\t'):
            totals[row['region']]=totals.get(row['region'],0)+int(row['bytes'])
    assert totals['WRAMX']<=4096
    assert totals['WRAM0_RENDER_UNION']<=sections['Render Vars']
    result={'wramx_planned':totals['WRAMX'],'wramx_free':4096-totals['WRAMX'],
            'render_union_current':sections['Render Vars'],
            'render_union_planned':totals['WRAM0_RENDER_UNION'],
            'render_union_free':sections['Render Vars']-totals['WRAM0_RENDER_UNION'],
            'fixed_render_candidate':sections['Render'],
            'rom0_renderer':sections['Render ROM0'],
            'geometry_vars':sections.get('Geometry Vars',0)}
    path=ROOT/'build/sgb';path.mkdir(parents=True,exist_ok=True)
    (path/'budget.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))


if __name__=='__main__':
    audit()
