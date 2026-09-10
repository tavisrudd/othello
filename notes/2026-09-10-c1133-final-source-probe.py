"""Pinned-source access and citation metadata; errors never mean zero citations.

Replay cached responses by default. --refresh writes a new timestamped cache run.
No title search is used to resolve citation seeds. Counts are not a screen verdict.
"""
import argparse
import concurrent.futures
import datetime
import hashlib
import html
import json
from pathlib import Path
import re
import urllib.error
import urllib.parse
import urllib.request

HERE = Path(__file__).resolve().parent
OUT = Path(__file__).with_suffix('.json')
CACHE = Path('/tmp/persistent/tavis/lit-search/c1133-final-probe')
ARXIV = ['2307.13555', '2307.03696', '2604.10028', '2508.05105',
         '2605.29143', '2608.01577', '2411.02266', '2606.17884',
         '2509.15831', '2607.26718', '2607.22074', '2510.21222',
         '2510.23143']
DOIS = ['10.1007/978-3-031-17859-7_20', '10.1090/pspum/088/01473']


def fetch(job):
    name, url = job
    row = {'name': name, 'url': url,
           'utc': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    try:
        with urllib.request.urlopen(urllib.request.Request(
                url, headers={'User-Agent': 'C1133 source audit/1.0'}), timeout=25) as r:
            data = r.read()
            row.update(status=r.status, content_type=r.headers.get('Content-Type'))
    except urllib.error.HTTPError as e:
        data = e.read()
        row.update(status=e.code)
    except Exception as e:
        return {**row, 'error': str(e)}
    path = CACHE / (hashlib.sha256(url.encode()).hexdigest()[:20] + '.response')
    path.write_bytes(data)
    return {**row, 'path': str(path), 'sha256': hashlib.sha256(data).hexdigest(),
            'bytes': len(data), 'pdf': data.startswith(b'%PDF')}


def batch(jobs):
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as ex:
        return list(ex.map(fetch, jobs))


def count(row, service):
    if row.get('status') != 200:
        return {**row, 'service': service, 'count': None}
    try:
        m = json.loads(Path(row['path']).read_bytes())
        if service == 'Crossref':
            m = m['message']
            fields = dict(count=m.get('is-referenced-by-count'),
                          title=m.get('title'), resolved_id=m.get('DOI'))
        elif service == 'OpenAlex':
            fields = dict(count=m.get('cited_by_count'), title=m.get('title'),
                          resolved_id=m.get('id'))
        else:
            fields = dict(count=m.get('citationCount'), title=m.get('title'),
                          resolved_id=m.get('paperId'), external_ids=m.get('externalIds'))
        return {**row, 'service': service, **fields}
    except Exception as e:
        return {**row, 'service': service, 'count': None, 'parse_error': str(e)}


def main():
    global CACHE
    parser = argparse.ArgumentParser()
    parser.add_argument('--refresh', action='store_true')
    args = parser.parse_args()
    if OUT.exists() and not args.refresh:
        data = json.loads(OUT.read_text())
        for row in data['landing'] + data['graphs'] + data['body_access']:
            if 'path' in row:
                assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest() == row['sha256']
        print('Cached response hashes verified:', len(data['graphs']), 'graph requests')
        return
    CACHE = CACHE / datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S')
    CACHE.mkdir(parents=True)
    land = batch([('arXiv:' + x, 'https://arxiv.org/abs/' + x) for x in ARXIV])
    seeds = []
    for row in land:
        body = Path(row['path']).read_text(errors='replace') if row.get('status') == 200 else ''
        aliases = re.findall(r'<meta\s+name="citation_doi"\s+content="([^"]+)"', body)
        row['publication_dois'] = [html.unescape(x) for x in aliases]
        row['version_ids'] = list(dict.fromkeys(re.findall(r'arXiv:(\d{4}\.\d{4,5}v\d+)', body)))
        arxiv_id = row['name'].split(':', 1)[1]
        seeds.append((row['name'], '10.48550/arXiv.' + arxiv_id, 'ARXIV:' + arxiv_id))
        seeds += [(row['name'] + ' publication', x, 'DOI:' + x) for x in row['publication_dois']]
    seeds += [('DOI:' + x, x, 'DOI:' + x) for x in DOIS]
    jobs = []
    services = []
    for name, doi, s2 in seeds:
        urls = {
            'OpenAlex': 'https://api.openalex.org/works/https://doi.org/' + doi,
            'Crossref': 'https://api.crossref.org/works/' + urllib.parse.quote(doi, safe=''),
            'Semantic Scholar': 'https://api.semanticscholar.org/graph/v1/paper/' + s2 +
                '?fields=paperId,title,externalIds,citationCount',
        }
        for service, url in urls.items():
            jobs.append((name, url))
            services.append(service)
    graphs = [count(r, s) for r, s in zip(batch(jobs), services)]
    body = batch([
        ('spectra-published', 'https://link.springer.com/content/pdf/10.1007/978-3-031-17859-7_20'),
        ('base-ams', 'https://www.ams.org/books/pspum/088/01473/pspum088-01473.pdf'),
        ('base-ams-ebook', 'https://www.ams.org/books/pspum/088/pspum088-endmatter.pdf'),
    ])
    OUT.write_text(json.dumps({'landing': land, 'graphs': graphs, 'body_access': body}, indent=2) + '\n')
    print('Recorded', len(land), 'arXiv identities;', len(graphs), 'independent graph requests')
    print('Published body probes:', [(r['name'], r.get('status'), r.get('pdf')) for r in body])


if __name__ == '__main__':
    main()
