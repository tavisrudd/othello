"""Retrieve the remaining pages of the recorded quantum/birational zbMATH query.

The API's OpenAPI schema specifies zero-based `page` and `results_per_page`.
Raw responses are retained on persistent disk; this script records exact hashes
and identifiers. Retrieval is not evidence that titles or full texts were read.
"""
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import Request, urlopen
from datetime import datetime, timezone
import hashlib
import json

HERE = Path(__file__).resolve().parent
CACHE = Path('/tmp/persistent/tavis/lit-search/c1133-intake')
QUERY = '"quantum" & "birational"'


def run():
    initial = next(x for x in json.loads((HERE / '2026-09-09-c1133-zbmath-probe.json').read_text())
                   if x['query'] == QUERY)
    rows = []
    for page in (0, 1, 2):
        url = 'https://api.zbmath.org/v1/document/_search?' + urlencode({
            'search_string': QUERY, 'page': page, 'results_per_page': 100})
        path = Path(initial['cache']) if page == 0 else CACHE / f'zbmath-quantum-birational-page-{page}.json'
        fetched = not path.exists()
        if fetched:
            with urlopen(Request(url, headers={'User-Agent': 'Literature-audit/1.0'}), timeout=60) as response:
                body = response.read()
            json.loads(body)
            path.write_bytes(body)
        body = path.read_bytes()
        data = json.loads(body)
        records = data.get('result', data.get('results', []))
        if not isinstance(records, list):
            raise ValueError(f'Unexpected result schema: {type(records)}')
        rows.append({'page': page, 'url': initial['url'] if page == 0 else url,
                     'checked_utc': datetime.now(timezone.utc).isoformat(),
                     'fetched_this_run': fetched, 'status': data.get('status'),
                     'cache': str(path), 'sha256': hashlib.sha256(body).hexdigest(),
                     'records': [{'id': r['id'], 'title': r['title'], 'year': r['year'],
                                  'authors': [a['name'] for a in r.get('contributors', {}).get('authors', [])],
                                  'links': r.get('links', []), 'zbmath_url': r.get('zbmath_url')}
                                 for r in records]})
    ids = [record['id'] for page in rows for record in page['records']]
    output = {'query': QUERY, 'pagination_schema_cache': str(CACHE / 'zbmath-openapi.json'),
              'read_depth': 'retrieved metadata; screening is recorded separately',
              'retrieved': len(ids), 'unique_ids': len(set(ids)), 'pages': rows}
    Path(__file__).with_suffix('.json').write_text(json.dumps(output, indent=2) + '\n')
    print('records', len(ids), 'unique IDs', len(set(ids)))
    for page in rows:
        print('page', page['page'], 'records', len(page['records']), 'status', page['status'])


if __name__ == '__main__':
    run()
