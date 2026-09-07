"""Check the citation record, not novelty or permission to draft."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
CACHE = Path('/tmp/persistent/tavis/lit-search')
DEPTHS = {'full text', 'partial', 'review only', 'secondary only', 'abstract/metadata only'}


def check(path, digest):
    assert hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest, path


promoted = json.loads((ROOT / 'promoted.json').read_text())
payload = json.loads((ROOT / 'adjudication.json').read_text())
check(ROOT / 'promoted.json', payload['promoted_sha256'])
rows = payload['records']
assert payload['count'] == len(rows) == len(promoted) == 336
assert [r['index'] for r in rows] == list(range(336))
for original, row in zip(promoted, rows):
    assert (row['title'], row['id']) == (original['title'], original['id'])
    assert row['read_depth'] in DEPTHS
    assert row['fields_read'] and row['reason'] and row['disposition']
assert sum(r['disposition'] == 'ACCESS_GAP' for r in rows) == 0
assert rows[19]['read_depth'] == 'secondary only'
assert rows[272]['read_depth'] == 'full text'
assert rows[272]['disposition'] == 'PRIMARY_COMPARISON'

sources = json.loads((ROOT / 'adjudication-sources.json').read_text())
assert len(sources) == len({s['key'] for s in sources}) == 33
assert sum(s['read_depth'] == 'full text' for s in sources) == 3
assert sum(s['reading_pass'] == 'current adjudication' and s['read_depth'] == 'partial'
           for s in sources) == 20
assert not any(s['reading_pass'] == 'current adjudication' and s['read_depth'] == 'full text'
               for s in sources)
for source in sources:
    assert source['read_depth'] in DEPTHS and source['sections_read'] and source['comparison']
    if 'files' in source:
        directory = Path(source['cache_directory'])
        check(directory / 'manifest.json', source['manifest_sha256'])
        for item in source['files']:
            path = directory / item['file']
            check(path, item['sha256'])
            assert path.stat().st_size == item['bytes']
    else:
        slug = source['key'].replace(':', '_').replace('/', '_')
        path = CACHE / 'pdf' / (slug + '.pdf')
        assert path.read_bytes().startswith(b'%PDF')
        check(path, source['sha256'])
for row in rows:
    if 'source_key' in row:
        assert row['source_key'] in {s['key'] for s in sources}

access = json.loads((ROOT / 'adjudication-graph-access.json').read_text())
for record in access:
    check(record['cache'], record['sha256'])
    if record['status'] != 200:
        assert record.get('count') is None
assert next(r for r in access if r['name'] == 'crossref-retry')['status'] == 404
s2 = next(r for r in access if r['name'] == 's2-arxiv-retry')
assert s2['status'] == 200 and s2['count'] == 0
enum = json.loads((ROOT / 'adjudication-hessian-enumeration.json').read_text())
check(enum['cache'], enum['sha256'])
data = json.loads(Path(enum['cache']).read_text())
assert data['data'] == [] and 'next' not in data
assert enum['status'] == 200 and enum['complete'] and enum['count'] == 0

before = (ROOT / 'adjudication.json').read_bytes()
subprocess.run([sys.executable, str(ROOT / 'adjudicate.py')], check=True, capture_output=True)
assert (ROOT / 'adjudication.json').read_bytes() == before
ledger = (ROOT / 'CLAIM-PROOF-NOVELTY.md').read_text()
assert all(f'| N{i} |' in ledger for i in range(1, 10))
assert 'Gate 1 remains OPEN' in ledger
print('PASS: 336 dispositions; 33 source records and hashes; 20 original new partial readings plus 1 user-scan full reading; graph errors distinguished from zeros.')
print('Gate 1 remains OPEN: Crossref coverage; Feng–Luo primary access resolved.')
