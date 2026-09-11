"""Pinned-identifier citation queries; errors never become zero counts."""
import concurrent.futures
import datetime
import json
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

SEEDS = [
    ('TZ', '2608.20029', '10.48550/arXiv.2608.20029'),
    ('Roulleau', '1001.4855', '10.1307/mmj/1310667979'),
    ('vanGeemenYamauchi', '1506.05346', '10.48550/arXiv.1506.05346'),
    ('CMZ', '2210.14397', '10.1093/imrn/rnad113'),
]

def fetch(url):
    record = {'url': url, 'accessed_utc': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'LiteratureAudit/1.0'})
        with urllib.request.urlopen(req, timeout=35) as response:
            record['http_status'] = response.status
            record['data'] = json.load(response)
        record['outcome'] = 'success'
    except urllib.error.HTTPError as error:
        record.update(http_status=error.code, outcome='http_error', error=error.read(1200).decode(errors='replace'))
    except Exception as error:
        record.update(outcome='transport_or_parse_error', error=str(error))
    return record

def query(seed):
    name, arxiv, doi = seed
    result = {'seed': name, 'arxiv': arxiv, 'doi': doi, 'services': {}}
    oa = fetch('https://api.openalex.org/works/https://doi.org/' + doi)
    result['services']['OpenAlex'] = oa
    if oa.get('outcome') == 'success':
        data = oa['data']; oa['count'] = data.get('cited_by_count')
        wid = data['id'].rsplit('/', 1)[-1]
        oa['citing_pages'] = []
        cursor = '*'
        while cursor:
            page = fetch('https://api.openalex.org/works?' + urllib.parse.urlencode({
                'filter': 'cites:' + wid, 'per-page': 200, 'cursor': cursor,
                'select': 'id,doi,title,publication_year,abstract_inverted_index,primary_location'}))
            oa['citing_pages'].append(page)
            if page.get('outcome') != 'success': break
            cursor = page['data']['meta'].get('next_cursor')
            if not page['data'].get('results'): break
    cr = fetch('https://api.crossref.org/works/' + doi)
    if cr.get('outcome') == 'success': cr['count'] = cr['data']['message'].get('is-referenced-by-count')
    cr['enumeration_note'] = 'Public works API supplies a count, not the citing works list.'
    result['services']['Crossref'] = cr
    s2 = fetch('https://api.semanticscholar.org/graph/v1/paper/ARXIV:' + arxiv + '?fields=paperId,title,externalIds,citationCount')
    result['services']['SemanticScholar'] = s2
    if s2.get('outcome') == 'success':
        s2['count'] = s2['data'].get('citationCount'); s2['citing_pages'] = []
        offset = 0
        while True:
            page = fetch('https://api.semanticscholar.org/graph/v1/paper/' + s2['data']['paperId'] + '/citations?' + urllib.parse.urlencode({'fields': 'title,year,externalIds,abstract', 'limit': 1000, 'offset': offset}))
            s2['citing_pages'].append(page)
            if page.get('outcome') != 'success' or page['data'].get('next') is None: break
            offset = page['data']['next']
    return result

if __name__ == '__main__':
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        results = list(executor.map(query, SEEDS))
    output = Path(__file__).with_name('2026-09-11-c1141-citation-results.json')
    output.write_text(json.dumps({'schema': 1, 'seeds': results}, indent=2) + '\n')
    for result in results:
        print(result['seed'], {name: {'outcome': row['outcome'], 'count': row.get('count')} for name, row in result['services'].items()})
