"""Refresh named statements only after reviewing each changed statement."""
import json
import sys
from check import V, statements
rows=json.loads((V/'claim-map.json').read_text())
current=statements()
if len(sys.argv)<2: raise SystemExit('name reviewed semantic labels explicitly')
for label in sys.argv[1:]:
    rows[label]['statement_sha256']=current[label]['digest']
(V/'claim-map.json').write_text(json.dumps(rows,indent=2,sort_keys=True)+'\n')
