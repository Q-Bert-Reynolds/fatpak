"""Audit the Phase 0d feasibility budget against the current RGBDS link map."""
from pathlib import Path
import json
import re

ROOT=Path(__file__).resolve().parents[1]


def audit():
    text=(ROOT/'build/main.map').read_text()
    sections={name: int(size,16) for size,name in re.findall(
        r'SECTION:.*\(\$([0-9a-fA-F]+) bytes?\) \["([^"]+)"\]',text)}
    totals={}
    documentation=(ROOT/'notes/SGB.md').read_text()
    budget=documentation.split('<!-- sgb-budget:start -->',1)[1].split(
        '<!-- sgb-budget:end -->',1)[0]
    rows=[line for line in budget.splitlines() if line.startswith('|')]
    for line in rows[2:]:  # Skip the Markdown header and separator.
        region,item,size,basis=(cell.strip() for cell in line.strip('|').split('|'))
        totals[region]=totals.get(region,0)+int(size)
    assert totals['WRAMX']<=4096
    assert totals['WRAM0_RENDER_UNION']<=sections['Render Vars']
    assert totals['HRAM']==sections['Fullscreen transport']
    result={'wramx_planned':totals['WRAMX'],'wramx_free':4096-totals['WRAMX'],
            'render_union_current':sections['Render Vars'],
            'render_union_planned':totals['WRAM0_RENDER_UNION'],
            'render_union_free':sections['Render Vars']-totals['WRAM0_RENDER_UNION'],
            'fixed_render_candidate':sections['Render'],
            'rom0_renderer':sections['Render ROM0'],
            'geometry_vars':sections.get('Geometry Vars',0),
            'transport_hram_current':sections['Fullscreen transport']}
    path=ROOT/'build/sgb';path.mkdir(parents=True,exist_ok=True)
    (path/'budget.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))


if __name__=='__main__':
    audit()
