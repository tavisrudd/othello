"""Pinned-seed citation acquisition; no failed request is a zero count.

Replay: python3 notes/2026-09-07-c1102-forward-citations/audit.py
Raw responses stay in the persistent literature cache; compact records live here.
"""
import concurrent.futures
import datetime
import hashlib
import json
from pathlib import Path
import urllib.error
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parent
CACHE = Path('/tmp/persistent/tavis/lit-search/c1102-forward-citations')
SEEDS = {
    'haah': '10.1103/PhysRevA.97.042327',
    'campbell-howard': '10.1103/PhysRevA.95.022316',
    'krishna-tillich': '10.1103/PhysRevLett.123.070507',
    'prakash-saha': '10.22331/q-2025-06-12-1768',
    'campbell-anwar-browne': '10.1103/PhysRevX.2.041021',
    'leone-oliviero-hamma': '10.1103/PhysRevLett.128.050402',
    'wang-li': '10.1007/s11128-023-04186-9',
    'kagamihara-tsuchiya': '10.48550/arXiv.2602.23687',
    'chen-yan-zhou': '10.22331/q-2024-05-21-1351',
}

def fetch(name, url):
    rec = dict(url=url, timestamp=datetime.datetime.now(datetime.timezone.utc).isoformat())
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers={'User-Agent': 'C1102-literature-audit/1.0'}), timeout=30) as response:
            data = response.read()
            rec['status'] = response.status
        path = CACHE / (name + '.json')
        path.write_bytes(data)
        rec.update(sha256=hashlib.sha256(data).hexdigest(), cache=str(path))
        return rec, json.loads(data)
    except Exception as error:
        rec['error'] = str(error)
        return rec, None

def seed(item):
    name, doi = item
    result = dict(seed=name, doi=doi, services={})
    urls = {
        'openalex': 'https://api.openalex.org/works/doi:' + doi,
        'crossref': 'https://api.crossref.org/works/' + doi,
        'semantic-scholar': 'https://api.semanticscholar.org/graph/v1/paper/' +
            ('ARXIV:' + doi.split('arXiv.')[1] if 'arXiv.' in doi else 'DOI:' + doi) +
            '?fields=title,citationCount,externalIds',
    }
    for service, url in urls.items():
        rec, data = fetch(name + '-' + service, url)
        if data is not None:
            data = data.get('message', data)
            rec.update(title=data.get('title'), count=data.get('cited_by_count', data.get('is-referenced-by-count', data.get('citationCount'))),
                       id=data.get('id', data.get('paperId')), identifiers=data.get('ids', data.get('externalIds', {'DOI': data.get('DOI')})))
        result['services'][service] = rec
    # Enumerate both accessible graphs, so the largest can be screened and discrepancies retained.
    for service in ('openalex', 'semantic-scholar'):
        rec = result['services'][service]
        if not rec.get('id'):
            continue
        rows, pages, cursor = [], [], '*'
        while True:
            if service == 'openalex':
                url = 'https://api.openalex.org/works?' + urllib.parse.urlencode(dict(
                    filter='cites:' + rec['id'].rsplit('/', 1)[-1], per_page=200,
                    cursor=cursor, select='id,doi,title,publication_year,abstract_inverted_index'))
            else:
                url = 'https://api.semanticscholar.org/graph/v1/paper/' + rec['id'] + '/citations?' + urllib.parse.urlencode(dict(
                    fields='title,abstract,year,externalIds', limit=1000, offset=len(rows)))
            page, data = fetch(name + '-' + service + '-citations-' + str(len(pages)), url)
            pages.append(page)
            if data is None:
                break
            if service == 'openalex':
                rows.extend(data.get('results', []))
                cursor = data.get('meta', {}).get('next_cursor')
                if not cursor or not data.get('results'):
                    break
            else:
                rows.extend(x['citingPaper'] for x in data.get('data', []))
                if 'next' not in data:
                    break
        rec.update(pages=pages, enumerated=len(rows), enumeration_complete=all('error' not in p for p in pages))
        target = CACHE / (name + '-' + service + '-citing.json')
        target.write_text(json.dumps(rows, indent=2) + '\n')
        rec.update(enumeration_cache=str(target), enumeration_sha256=hashlib.sha256(target.read_bytes()).hexdigest())
    return result

if __name__ == '__main__':
    CACHE.mkdir(parents=True, exist_ok=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
        records = list(pool.map(seed, SEEDS.items()))
    (ROOT / 'counts.json').write_text(json.dumps(records, indent=2) + '\n')
    for rec in records:
        print(rec['seed'], ' | '.join(f"{s}: count={v.get('count', 'UNAVAILABLE')}, retrieved={v.get('enumerated', '-')}, error={v.get('error', '-') }" for s, v in rec['services'].items()))
