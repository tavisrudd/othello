"""Recorded topical zbMATH searches and sequential S2 retry after throttling."""
import importlib.util
import json
import urllib.parse
from pathlib import Path

base = Path(__file__).parent
spec = importlib.util.spec_from_file_location('citations', base / '2026-09-11-c1141-citation-query.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
queries = [
    'ti:"Fano surfaces with 12 or 30 elliptic curves"',
    'ti:"Stably rational irrational varieties"',
    'ti:"Universal torsors over quartic del Pezzo surfaces and stable rationality"',
    '"del Pezzo" & "stable rationality"',
    '"cubic threefold" & "isogeny"',
    '"cubic threefold" & "automorphism"',
    'ti:"On intermediate Jacobians of cubic threefolds admitting an automorphism of order five"',
]
records = []
for query in queries:
    result = module.fetch('https://api.zbmath.org/v1/document/_search?' + urllib.parse.urlencode({'search_string': query, 'results_per_page': 200}))
    result['query'] = query
    records.append(result)
    data = result.get('data', {})
    print('zbMATH', query, data.get('status', {}).get('nr_total_results'), result['outcome'])
retries = []
for name, arxiv, doi in module.SEEDS[1:]:
    result = module.fetch('https://api.semanticscholar.org/graph/v1/paper/DOI:' + doi + '?fields=paperId,title,externalIds,citationCount')
    result['seed'] = name
    if result['outcome'] == 'success':
        result['count'] = result['data'].get('citationCount')
        result['citations'] = module.fetch('https://api.semanticscholar.org/graph/v1/paper/' + result['data']['paperId'] + '/citations?fields=title,year,externalIds,abstract&limit=1000')
    retries.append(result)
    print('S2 retry',name,result['outcome'],result.get('count'))
(base/'2026-09-11-c1141-database-results.json').write_text(json.dumps({'zbmath':records,'s2_retries':retries},indent=2)+'\n')
