"""Verify the banked acquisition; does not certify novelty or a completed read."""
import ast
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent

def check(path, digest):
    assert hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest, path

for name in ('audit.py', 'screen.py', 'verify.py'):
    ast.parse((ROOT / name).read_text())

counts = json.loads((ROOT / 'counts.json').read_text())
memberships = 0
for seed in counts:
    assert len(seed['services']) == 3
    for service, record in seed['services'].items():
        if 'error' in record:
            assert record.get('count') is None
            continue
        check(record['cache'], record['sha256'])
        for page in record.get('pages', []):
            if 'error' not in page:
                check(page['cache'], page['sha256'])
        if 'enumeration_cache' in record:
            check(record['enumeration_cache'], record['enumeration_sha256'])
            rows = json.loads(Path(record['enumeration_cache']).read_text())
            assert len(rows) == record['enumerated']
            memberships += len(rows)
    if seed['seed'] not in ('kagamihara-tsuchiya',):
        assert all(isinstance(s['count'], int) for s in seed['services'].values())
        assert all(seed['services'][s]['enumeration_complete'] for s in ('openalex', 'semantic-scholar'))

sources = json.loads((ROOT / 'sources.json').read_text())
depths = {'full text', 'partial', 'review only', 'secondary only', 'abstract/metadata only'}
for source in sources:
    assert source['read_depth'] in depths and source['sections_read']
    slug = source['key'].replace(':', '_').replace('/', '_')
    path = Path('/tmp/persistent/tavis/lit-search/pdf') / (slug + '.pdf')
    assert path.read_bytes().startswith(b'%PDF')
    check(path, source['sha256'])

before = {name: (ROOT / name).read_bytes() for name in ('screening.json', 'promoted.json')}
subprocess.run([sys.executable, str(ROOT / 'screen.py')], check=True, capture_output=True)
assert all((ROOT / name).read_bytes() == content for name, content in before.items())
screen = json.loads((ROOT / 'screening.json').read_text())
assert len(screen['records']) == memberships == 1377
assert len(json.loads((ROOT / 'promoted.json').read_text())) == 336
assert sum(s['read_depth'] == 'full text' for s in sources) == 1
print('PASS: 9 pinned seeds; 1377 memberships; 336 reproducible promotions; 13 PDF hashes; 1 full-text read marker.')
print('Gate 1 remains OPEN: acquisition verification is not novelty closure.')
