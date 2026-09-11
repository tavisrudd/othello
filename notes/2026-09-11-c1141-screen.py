"""Offline inventory of the frozen search responses; not a novelty oracle."""
import hashlib
import json
import re
from pathlib import Path

BASE = Path(__file__).parent
PREFIX = '2026-09-11-c1141-'
def read(name):
    return json.loads((BASE / (PREFIX + name + '.json')).read_text())

seeds = read('citation-results')['seeds'] + [read('vgy-published-citations')]
sets = []
for seed in seeds:
    for service, result in seed['services'].items():
        rows = []
        for page in result.get('citing_pages', []):
            data = page.get('data', {})
            rows.extend(data.get('results', []))
            rows.extend(x['citingPaper'] for x in data.get('data', []))
        sets.append(dict(seed=seed['seed'], doi=seed['doi'], service=service,
                         count=result.get('count'), outcome=result['outcome'],
                         returned_rows=len(rows), rows=rows))
for result in read('database-results')['s2_retries'] + [dict(read('vgy-s2-retry'), seed='vanGeemenYamauchi-published')]:
    rows = [x['citingPaper'] for x in result.get('citations', {}).get('data', {}).get('data', [])]
    sets.append(dict(seed=result['seed'], service='SemanticScholar-retry',
                     count=result.get('count',result.get('data',{}).get('citationCount')),
                     outcome=result['outcome'],returned_rows=len(rows), rows=rows))

zb = []
for result in read('database-results')['zbmath']:
    rows = [dict(id=x['id'], title=x['title'], year=x['year'], links=x['links'])
            for x in result.get('data',{}).get('result',[])]
    zb.append(dict(query=result['query'],url=result['url'],returned_rows=len(rows),rows=rows))

web = []
for result in read('web-results'):
    hits = re.findall(r'^([^\n]+) \((https?://[^\n]+)\)\n',result['result'], re.M)
    web.append(dict(batch=result['name'], returned_appearances=len(hits),
                    rows=[dict(title=t,url=u) for t,u in hits]))

output = dict(schema=1, date='2026-09-11',
    fields='Citation graph and zbMATH titles/identifiers/years; web titles and supplied snippets. Promoted sources have separately recorded read depths.',
    discriminator='Promote smooth cubic families with explicit automorphisms or elliptic isogeny decompositions; quartic del Pezzo stable rationalization bounds; or arithmetic reduction/isogeny separation of cubic families. Retain direct cited sources. Other titles are not promoted, without asserting their full texts contain no relevant result.',
    scope='Four pinned citation seeds, including preprint/published alias resolution; union of enumerated graphs, not recursive citation closure.',
    citation_sets=sets, zbmath_sets=zb, web_sets=web)
(BASE/(PREFIX+'screen.json')).write_text(json.dumps(output,indent=2)+'\n')
print('citation sets',len(sets),'zbMATH appearances',sum(x['returned_rows'] for x in zb))
print('web batches',[(x['batch'],x['returned_appearances']) for x in web])
manifest = []
for path in sorted(BASE.glob(PREFIX+'*')):
    if path.is_file() and path.suffix in {'.py','.json','.md'}:
        manifest.append(hashlib.sha256(path.read_bytes()).hexdigest()+'  '+path.name)
(BASE/(PREFIX+'SHA256SUMS')).write_text('\n'.join(manifest)+'\n')
