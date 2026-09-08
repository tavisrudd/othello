#!/usr/bin/env python3
"""Record reviewed claim digests. Use exact labels; --all establishes a baseline.

Re-examine the correspondence row before using this command after a statement
change. Hashing neither runs Lean nor increases the recorded coverage.
"""
import json
import sys
from pathlib import Path

PAPER = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PAPER / "verification"))
from annotation_support import statement_digest, terminal_digest
from check_formal_artifact import manuscript_environments

def main() -> None:
    requested = set(sys.argv[1:])
    path = PAPER / "lean/verification/claims.json"
    data = json.loads(path.read_text())
    known = {r["manuscript_label"] for r in data["claims"]}
    if not requested or (requested != {"--all"} and not requested <= known):
        raise SystemExit("supply existing manuscript labels or --all after review")
    env = manuscript_environments()
    changed = 0
    for row in data["claims"]:
        label = row["manuscript_label"]
        if requested != {"--all"} and label not in requested:
            continue
        row["statement_digest"] = statement_digest(env[label])
        if row["terminals"]:
            row["terminal_digest"] = terminal_digest(row["terminals"])
        changed += 1
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    print(f"recorded {changed} reviewed claim digests")

if __name__ == "__main__":
    main()
