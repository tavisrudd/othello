"""Resolve title-screened zbMATH leads against arXiv or publication metadata.

Raw primary-source responses are cached; no full-text reading is asserted.
"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.request import Request, urlopen
from datetime import datetime, timezone
import hashlib
import html
import json
import re

HERE = Path(__file__).resolve().parent
CACHE = Path('/tmp/persistent/tavis/lit-search/c1133-intake')
IDS = {6722461, 6490755, 7828755, 7168644, 6999237, 902826367,
       902487887, 8141796, 7319811, 6490757, 902598444, 8197586,
       5530174, 900530165, 6745500, 7822627, 5270821, 7051836, 6194734}


def text(value):
    return ' '.join(html.unescape(re.sub('<[^>]+>', ' ', value)).split())


def run(record):
    arxiv = next((x['identifier'] for x in record['links'] if x['type'] == 'arxiv'), None)
    doi = next((x['identifier'] for x in record['links'] if x['type'] == 'doi'), None)
    result = {'zbmath_id': record['id'], 'zbmath_title': record['title']['title'],
              'queried_utc': datetime.now(timezone.utc).isoformat(),
              'read_depth': 'metadata only', 'arxiv': arxiv, 'doi': doi}
    if not (arxiv or doi):
        return {**result, 'status': 'no linked primary identifier; needs manual resolution'}
    url = 'https://arxiv.org/abs/' + arxiv if arxiv else 'https://api.crossref.org/works/' + doi
    path = CACHE / ('zbmath-lead-' + str(record['id']) + ('.html' if arxiv else '.json'))
    try:
        if not path.exists():
            with urlopen(Request(url, headers={'User-Agent': 'Literature-audit/1.0'}), timeout=45) as response:
                path.write_bytes(response.read())
        body = path.read_bytes()
        result.update(url=url, cache=str(path), sha256=hashlib.sha256(body).hexdigest(), status='retrieved')
        if arxiv:
            page = body.decode()
            match = re.search(r'<blockquote[^>]*class="abstract[^>]*>(.*?)</blockquote>', page, re.S)
            result['abstract'] = text(match.group(1)) if match else None
            title = re.search(r'<meta name="citation_title" content="(.*?)"', page)
            result['title'] = html.unescape(title.group(1)) if title else None
        else:
            data = json.loads(body)['message']
            result['title'] = data.get('title', [])
            result['abstract'] = text(data.get('abstract', '')) or None
            result['authors'] = data.get('author', [])
            result['publication_date'] = data.get('published')
    except Exception as error:
        result.update(url=url, status=type(error).__name__, error=str(error))
    return result


if __name__ == '__main__':
    data = json.loads((HERE / '2026-09-09-c1133-zbmath-pagination.json').read_text())
    records = [r for page in data['pages'] for r in page['records'] if r['id'] in IDS]
    with ThreadPoolExecutor(max_workers=3) as executor:
        output = list(executor.map(run, records))
    for row in output:
        abstract = row.pop('abstract', None)
        row['abstract_present'] = bool(abstract)
        if abstract:
            row['abstract_word_count'] = len(abstract.split())
            row['abstract_sha256'] = hashlib.sha256(abstract.encode()).hexdigest()
    Path(__file__).with_suffix('.json').write_text(json.dumps(output, indent=2) + '\n')
    for row in output:
        print(row['zbmath_id'], row['status'], row.get('title'), 'abstract:', row['abstract_present'])
