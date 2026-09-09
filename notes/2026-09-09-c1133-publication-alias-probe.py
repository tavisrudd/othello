"""Independent graph counts for source-verified publication DOI aliases."""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.parse import quote
import importlib.util
import json

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('probe', HERE / '2026-09-09-c1133-citation-probe.py')
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)
probe.CACHE = Path('/tmp/persistent/tavis/lit-search/c1133-publication-alias-probe')
SEEDS = {
    'voisin-published': ('10.1112/S0010437X21007727', 'zbMATH document 7481799'),
    'orr-published': ('10.1515/crelle-2013-0058', 'https://arxiv.org/abs/1209.3653'),
}


def run(job):
    name, service, url = job
    result = probe.probe(job)
    result['seed'] = 'doi:' + SEEDS[name][0]
    result['alias_verified_at'] = SEEDS[name][1]
    return result


if __name__ == '__main__':
    probe.CACHE.mkdir(exist_ok=True)
    jobs = []
    for name, (doi, _) in SEEDS.items():
        jobs.extend([
            (name, 'OpenAlex', 'https://api.openalex.org/works/https://doi.org/' + doi),
            (name, 'Crossref', 'https://api.crossref.org/works/' + quote(doi, safe='')),
            (name, 'Semantic Scholar', 'https://api.semanticscholar.org/graph/v1/paper/DOI:'
             + doi + '?fields=paperId,title,externalIds,citationCount'),
        ])
    with ThreadPoolExecutor(max_workers=3) as executor:
        rows = list(executor.map(run, jobs))
    Path(__file__).with_suffix('.json').write_text(json.dumps(rows, indent=2) + '\n')
    for row in rows:
        print(row['seed'], row['service'], row['status'], row['citation_count'])
