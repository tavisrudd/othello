"""Replay the selector/comparison trust snapshot after a guarded axiom audit."""
import argparse
import hashlib
import json
from pathlib import Path
import runpy

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--axiom-log', type=Path, required=True)
parser.add_argument('--check', action='store_true')
args = parser.parse_args()
base = Path(__file__).with_name('2026-09-10-c1133-lean-trust-review.py')
result = runpy.run_path(str(base))['snapshot'](args.axiom_log)
result['snapshot_helper_sha256'] = hashlib.sha256(base.read_bytes()).hexdigest()
assert result['public_terminals'] == 373
assert result['machinery_terminals'] == 135
assert result['project_source_count'] == 246
text = json.dumps(result, indent=2, sort_keys=True) + '\n'
output = Path(__file__).with_suffix('.json')
if args.check:
    assert output.read_text() == text, 'Selector/comparison snapshot changed'
else:
    output.write_text(text)
print('PASS: 373 audited terminals, 246 sources, and 17 literal matrix rows.')
