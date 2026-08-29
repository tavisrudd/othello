#!/usr/bin/env python3
"""Check full-suite VLSAT-2 coverage and replay every emitted clique."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path

from check_vlsat2_prefix import replay_clique
from run_satcomp24_portfolio import sha256


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    manifest = json.loads(args.manifest.read_text())
    if document["schema"] != "ergodis-vlsat2-full-coverage-v1":
        raise SystemExit("unexpected evidence schema")
    artifacts = document["artifacts"]
    expected_hashes = {
        "manifest_sha256": sha256(args.manifest),
        "raw_jsonl_sha256": sha256(args.raw_jsonl),
        "runner_sha256": sha256(Path(__file__).with_name("run_vlsat2_coverage.py")),
        "checker_sha256": sha256(Path(__file__)),
        "clique_replay_sha256": sha256(
            Path(__file__).with_name("check_vlsat2_prefix.py")
        ),
        "process_runner_sha256": sha256(
            Path(__file__).with_name("run_satcomp24_portfolio.py")
        ),
        "ergodis_sha256": sha256(args.ergodis),
    }
    for key, expected in expected_hashes.items():
        if artifacts.get(key) != expected:
            raise SystemExit(f"artifact hash mismatch: {key}")
    if manifest["builder_sha256"] != sha256(
        Path(__file__).with_name("build_vlsat2_full_manifest.py")
    ):
        raise SystemExit("manifest builder hash mismatch")
    entries = {entry["filename"]: entry for entry in manifest["instances"]}
    counts: Counter[tuple[str, str]] = Counter()
    observed = set()
    with args.raw_jsonl.open() as source:
        for line in source:
            record = json.loads(line)
            filename = record["filename"]
            if filename in observed or filename not in entries:
                raise SystemExit(f"duplicate or unknown instance: {filename}")
            observed.add(filename)
            entry = entries[filename]
            if record["expected"] != entry["expected"]:
                raise SystemExit(f"outcome metadata mismatch: {filename}")
            cnf = args.cache_dir / filename
            if sha256(cnf) != record["cnf_sha256"]:
                raise SystemExit(f"CNF hash mismatch: {filename}")
            outcome = record["outcome"]
            counts[(entry["expected"], outcome)] += 1
            if outcome == "hit":
                if entry["expected"] != "unsat" or record["certificate"] is None:
                    raise SystemExit(f"invalid theorem hit: {filename}")
                replay_clique(cnf, record["certificate"])
            elif record["certificate"] is not None:
                raise SystemExit(f"certificate attached to non-hit: {filename}")
    if observed != set(entries):
        raise SystemExit("coverage evidence does not span the manifest")
    expected_summary = {
        expected: {
            outcome: counts[(expected, outcome)]
            for outcome in ("hit", "miss", "timeout", "error")
        }
        for expected in ("sat", "unsat")
    }
    if document["summary"] != expected_summary:
        raise SystemExit("coverage summary mismatch")
    if expected_summary["sat"]["hit"]:
        raise SystemExit("a SAT instance received an UNSAT certificate")
    print(json.dumps(expected_summary, sort_keys=True))


if __name__ == "__main__":
    main()
