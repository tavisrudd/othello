"""Offline integrity replay for the C1136 literature-screen evidence, not proof of novelty."""
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def read(name):
    return json.loads((ROOT / name).read_text())


def key(title):
    return re.sub('[^a-z0-9]', '', title.lower())


counts = read('graph-counts.json')
assert len(counts) == 27
assert all(x['status'] == 'ok' for x in counts)
seeds = sorted({x['seed'] for x in counts})
titles = set()
retrieved = 0
for seed in seeds:
    assert {x['service'] for x in counts if x['seed'] == seed} == {
        'openalex', 'crossref', 'semantic_scholar'}
    for service in ['openalex', 'semantic_scholar']:
        entry = read(f'{seed}-{service}-citations.json')
        assert entry['status'] == 'ok'
        assert entry['count_retrieved'] == len(entry['records'])
        assert entry['queries']
        retrieved += len(entry['records'])
        titles.update(key(x['title']) for x in entry['records'])
corpus = read('citation-screen.json')
assert {key(x['title']) for x in corpus} == titles
assert len(corpus) == len(titles) == 602
assert [x['screen_id'] for x in corpus] == list(range(1, 603))
assert sum(not bool(x['title']) for x in corpus) == 1
zb = read('zbmath-search.json')
assert all(x['status'] == 'ok' and len(x['records']) == x['total'] for x in zb)
assert sum(len(x['records']) for x in zb) == 61
assert len(read('scholar-search.json')['records']) == 10
assert len(read('source-cache-manifest.json')) == 17
for line in (ROOT / 'SHA256SUMS').read_text().splitlines():
    digest, name = line.split('  ', 1)
    assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == digest, name
print(f'PASS: 27 graph counts; 18 citing lists ({retrieved} records); '
      '602 title keys; 61 zbMATH records; 10 Scholar results; evidence hashes')
print('LIMIT: one blank record, inaccessible Crossref largest list and MathSciNet; no priority closure')
