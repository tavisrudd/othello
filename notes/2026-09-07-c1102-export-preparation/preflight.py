"""Private pre-export approval check, kept outside the scholarly artifact."""
import json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
approval=json.loads((ROOT/'notes/2026-09-07-c1102-forward-citations/gate-approval.json').read_text())
assert approval['drafting_authorized'] and approval['crossref_count'] is None
subprocess.run(['python3',str(ROOT/'papers/scripts/export-paper-repos.py'),'audit','--source-ref','HEAD','--repository','clebsch-cubic-phase'],check=True)
print('PASS: approved citation exception retained; committed export audit passed.')
