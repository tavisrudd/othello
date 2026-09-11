#!/usr/bin/env python3
"""Record or verify this exact software/evidence bundle (no self-hash cycle)."""
import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FILES = ('README.md', 'recognition.py', 'test_recognition.py', 'example.json',
         'test-results.json', 'bundle.py')


def main():
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument('--write', action='store_true')
    action.add_argument('--check', action='store_true')
    args = parser.parse_args()
    data = {'schema': 1, 'files': {name: {'bytes': len((ROOT/name).read_bytes()),
             'sha256': hashlib.sha256((ROOT/name).read_bytes()).hexdigest()} for name in FILES}}
    text = json.dumps(data, sort_keys=True, indent=2)+'\n'
    manifest = ROOT/'SHA256SUMS.json'
    if args.write:
        manifest.write_text(text)
    elif manifest.read_text() != text:
        raise SystemExit('software/evidence bundle hash mismatch')
    print('verified' if args.check else 'recorded', len(FILES), 'software/evidence artifacts')


if __name__ == '__main__':
    main()
