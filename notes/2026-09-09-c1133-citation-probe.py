"""Pinned-ID citation coverage probe. HTTP failures are never zero counts.

Raw service responses live in the persistent cache; metadata is git-visible.
This probe does not enumerate or screen citing sets and licenses no negative.
"""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path
from urllib.error import HTTPError
from urllib.parse import quote
from urllib.request import Request, urlopen
import json

SEEDS = ['2307.13555', '2307.03696', '2604.10028', '2508.05105',
         '2605.29143', '2608.01577', '2411.02266', '2606.17884',
         '2004.09310', '1209.3653', '2509.15831']
CACHE = Path('/tmp/persistent/tavis/lit-search/c1133-citation-probe')


def urls(seed):
    doi = '10.48550/arXiv.'+seed
    return {
        'OpenAlex': 'https://api.openalex.org/works/https://doi.org/'+doi,
        'Crossref': 'https://api.crossref.org/works/'+quote(doi, safe=''),
        'Semantic Scholar': 'https://api.semanticscholar.org/graph/v1/paper/ARXIV:'+seed+'?fields=paperId,title,externalIds,citationCount',
    }


def probe(job):
    seed, service, url = job
    record = {'seed':'arXiv:'+seed, 'service':service, 'query':url,
              'queried_utc':datetime.now(timezone.utc).isoformat(), 'citation_count':None}
    stem = seed+'-'+service.lower().replace(' ','-')
    try:
        req = Request(url, headers={'User-Agent':'C1133 literature audit (pinned identifier coverage)'})
        with urlopen(req, timeout=25) as response:
            data = response.read()
            record['http_status'] = response.status
        p = CACHE/(stem+'.json'); p.write_bytes(data)
        obj = json.loads(data)
        record.update(raw_path=str(p), raw_sha256=sha256(data).hexdigest())
        if service == 'OpenAlex':
            record.update(resolved_id=obj.get('id'), title=obj.get('title'),
                          citation_count=obj.get('cited_by_count'), ids=obj.get('ids'))
        elif service == 'Crossref':
            m = obj.get('message', {})
            record.update(resolved_id=m.get('DOI'), title=m.get('title'),
                          citation_count=m.get('is-referenced-by-count'))
        else:
            record.update(resolved_id=obj.get('paperId'), title=obj.get('title'),
                          citation_count=obj.get('citationCount'), ids=obj.get('externalIds'))
        record['status'] = 'resolved-count' if record['citation_count'] is not None else 'no-count-in-response'
    except HTTPError as e:
        data = e.read()
        p = CACHE/(stem+'.error'); p.write_bytes(data)
        record.update(status='http-error', http_status=e.code, error=str(e),
                      raw_path=str(p),raw_sha256=sha256(data).hexdigest())
    except Exception as e:
        record.update(status='access-error',error=str(e))
    return record


if __name__ == '__main__':
    CACHE.mkdir(exist_ok=True)
    jobs = [(seed,service,url) for seed in SEEDS for service,url in urls(seed).items()]
    with ThreadPoolExecutor(max_workers=4) as executor:
        rows = list(executor.map(probe,jobs))
    out = {'scope':'identifier resolution and independent citation counts only; no citing-set screen',
           'records':rows}
    Path(__file__).with_suffix('.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
    summary = {}
    for r in rows:
        key = r['service']+':'+r['status']
        summary[key] = summary.get(key,0)+1
    print(json.dumps(summary,sort_keys=True))
