"""Offline replay of C1133 citation evidence; not a mathematical proof check."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def read(name):
    return json.loads((HERE / name).read_text())


def verify_bytes(row):
    if 'path' in row:
        assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest() == row['sha256']


def main():
    batch = read('2026-09-10-c1133-cont-batch.json')
    verify_bytes(batch)
    assert batch['status'] == 200 and batch['method'] == 'POST'
    seeds = json.loads(Path(batch['path']).read_text())
    assert len(seeds) == len(batch['body']['ids']) == 12
    for requested, seed in zip(batch['body']['ids'], seeds):
        assert requested == 'ARXIV:' + seed['externalIds']['ArXiv']
    by_id = {seed['paperId']: seed for seed in seeds}
    for suffix in ['access', 'leads', 'identities']:
        for row in read('2026-09-10-c1133-cont-' + suffix + '.json'):
            verify_bytes(row)
    old = read('2026-09-10-c1133-final-source-probe.json')
    for row in old['graphs']:
        verify_bytes(row)
    screen = read('2026-09-10-c1133-cont-screen.json')
    total, unique = 0, set()
    assert len(screen['sets']) == 12
    for row in screen['sets']:
        s2 = row['counts']['Semantic Scholar']
        seed = by_id[s2['resolved_id']]
        assert row['seed'] == 'arXiv:' + seed['externalIds']['ArXiv']
        assert len(row['members']) == s2['count'] == seed['citationCount']
        if row['retrieval']:
            verify_bytes(row['retrieval'])
            data = json.loads(Path(row['retrieval']['path']).read_text())
            assert data.get('next') is None
            assert row['members'] == [x['citingPaper'] for x in data['data']]
        else:
            assert s2['count'] == 0
        total += len(row['members'])
        unique.update(p['paperId'] for p in row['members'])
    assert total == screen['membership_total'] == 59
    assert len(unique) == screen['unique_papers'] == 39
    register = read('2026-09-09-c1133-literature-sources.json')
    sources = register['sources']
    assert len(sources) == len({s['key'] for s in sources}) == 89
    vocabulary = {'full text', 'partial', 'review only', 'secondary only',
                  'abstract/metadata only'}
    assert all(s['read_depth'] in vocabulary and s['read_scope'] and s['access'] for s in sources)
    assert sum(s['read_depth'] == 'full text' for s in sources) == register['external_full_text_count'] == 9
    additions = {'2501.18849', '2210.08939', '2605.30439', '2605.30450',
                 '2609.06759', '2604.26592'}
    for source in sources:
        if source['key'] in {'arXiv:' + a for a in additions}:
            access = source['access']
            pdf = Path(access['pdf']).read_bytes()
            assert pdf.startswith(b'%PDF')
            assert hashlib.sha256(pdf).hexdigest() == access['sha256']
            assert Path(access['text']).is_file()
    published = read('2026-09-10-c1133-published-spectra-source.json')['source']
    assert hashlib.sha256(Path(published['pdf']).read_bytes()).hexdigest() == published['sha256']
    assert published['pages'] == 37
    print('Verified: 12 identities, 59 memberships, 39 distinct works;')
    print(f'{len(sources)} source records, nine full-text reads; response and new PDF hashes.')


if __name__ == '__main__':
    main()
