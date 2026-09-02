#!/usr/bin/env bash
# Validate the C1038 negative-control tier evidence bundle.
#
# Checks the recorded artifact hashes against the tracked files, that every
# declared row is present, that answers agree wherever both sides returned one,
# and that the acceptance gate holds: at least one predicted loss and one
# predicted win landed on the predicted side.
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$script_dir/.." && pwd)
summary=${1:-$root/evidence/c1038-negative-control-tier.json}

python3 - "$root" "$summary" <<'PYTHON'
import hashlib
import json
import sys

root, summary_path = sys.argv[1], sys.argv[2]
with open(summary_path, "r", encoding="utf-8") as handle:
    summary = json.load(handle)

failures = []

def digest(path):
    with open(path, "rb") as handle:
        return hashlib.sha256(handle.read()).hexdigest()

for name in ("classifier", "example_source", "control_source"):
    entry = summary["artifacts"][name]
    actual = digest(f"{root}/{entry['path']}")
    if actual != entry["sha256"]:
        failures.append(f"{name}: recorded {entry['sha256']} but file hashes {actual}")

raw = summary["artifacts"]["raw_jsonl"]
actual = digest(f"{root}/evidence/{raw['path']}")
if actual != raw["sha256"]:
    failures.append(f"raw transcript: recorded {raw['sha256']} but file hashes {actual}")

predicted = {"L1": "ergodis loses", "L2": "ergodis loses", "L3": "ergodis loses",
             "W1": "ergodis wins", "W2": "ergodis wins", "W3": "ergodis wins"}
rows = summary["rows"]
for row in predicted:
    if row not in rows:
        failures.append(f"row {row} is missing from the summary")

matched_loss = matched_win = 0
for row, expected in predicted.items():
    entry = rows.get(row)
    if entry is None:
        continue
    if entry["direction"] == expected:
        if expected == "ergodis loses":
            matched_loss += 1
        else:
            matched_win += 1
    if entry["agreement"].startswith("disagreement"):
        failures.append(f"row {row}: {entry['agreement']}")

if matched_loss < 1:
    failures.append("gate: no predicted loss landed as predicted")
if matched_win < 1:
    failures.append("gate: no predicted win landed as predicted")

for failure in failures:
    print(f"FAIL {failure}")
if failures:
    raise SystemExit(1)
print(
    f"c1038 negative-control tier: {len(rows)} rows, "
    f"{matched_loss} predicted losses and {matched_win} predicted wins landed as predicted"
)
PYTHON
