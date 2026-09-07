"""Reproducible title/abstract triage; promoted works still require human reading."""
import json
import re
from pathlib import Path
ROOT = Path(__file__).resolve().parent
PATTERN = r'qudit|qutrit|ququint|cubic|triorthogon|divisib|synthillation|synthesis|diagonal|transversal|invariant|hypergraph|mutually unbiased|maximal magic|maximum magic|nonlocal magic|non-local magic|multipartite|product state|Waring|Alltop'
records = []
for counts in json.loads((ROOT / 'counts.json').read_text()):
    for service, status in counts['services'].items():
        if not status.get('enumeration_cache'):
            continue
        path = Path(status['enumeration_cache'])
        for row in json.loads(path.read_text()):
            abstract = row.get('abstract') or ' '.join((row.get('abstract_inverted_index') or {}).keys())
            matches = sorted(set(re.findall(PATTERN, row.get('title', '') + ' ' + abstract, re.I)))
            records.append(dict(seed=counts['seed'], service=service, title=row.get('title'),
                id=row.get('id', row.get('paperId')), doi=row.get('doi'), externalIds=row.get('externalIds'),
                abstract_available=bool(abstract), matches=matches,
                disposition='PROMOTE' if matches else 'NO_PATTERN_MATCH'))
(ROOT / 'screening.json').write_text(json.dumps(dict(pattern=PATTERN, fields=['title','abstract'],
    warning='NO_PATTERN_MATCH is triage, not a full-text exclusion.', records=records), indent=2) + '\n')
unique = {}
for row in records:
    if row['disposition'] == 'PROMOTE':
        key = re.sub(r'\W', '', row['title'].lower())
        unique.setdefault(key, row)
(ROOT / 'promoted.json').write_text(json.dumps(list(unique.values()), indent=2) + '\n')
print(f'{len(records)} graph memberships screened; {len(unique)} distinct normalized-title promotions')
