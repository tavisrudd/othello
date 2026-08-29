#!/usr/bin/env python3
"""Stream exact theorem-coverage records over all official VLSAT-2 cases."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path

from run_satcomp24_portfolio import host_metadata, run, sha256


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--timeout", type=float, default=120.0)
    parser.add_argument("--cpu", type=int, default=3)
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text())
    counts: Counter[tuple[str, str]] = Counter()
    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for index, entry in enumerate(manifest["instances"], 1):
            cnf = args.cache_dir / entry["filename"]
            if not cnf.exists():
                raise SystemExit(f"missing input: {cnf}")
            cnf_hash = sha256(cnf)
            result = run([str(args.ergodis), str(cnf)], args.timeout, args.cpu)
            certificate = None
            if result["status"] == "timeout":
                outcome = "timeout"
            elif result["exit_code"] == 0:
                certificate = json.loads(result["stdout_tail"])
                if certificate.get("status") != "unsat":
                    raise RuntimeError(f"bad certificate output: {entry['filename']}")
                if entry["expected"] == "sat":
                    raise RuntimeError(f"false UNSAT certificate: {entry['filename']}")
                outcome = "hit"
            elif "no coloring-clique obstruction found" in result["stderr_tail"]:
                certificate = None
                outcome = "miss"
            else:
                certificate = None
                outcome = "error"
            counts[(entry["expected"], outcome)] += 1
            record = {
                **entry,
                "cnf_sha256": cnf_hash,
                "outcome": outcome,
                "certificate": certificate,
                "process": result,
            }
            raw.write(json.dumps(record, sort_keys=True) + "\n")
            raw.flush()
            print(
                f"[{index}/{len(manifest['instances'])}] {entry['expected']} "
                f"{entry['filename']} {outcome}",
                flush=True,
            )
    summary = {
        expected: {
            outcome: counts[(expected, outcome)]
            for outcome in ("hit", "miss", "timeout", "error")
        }
        for expected in ("sat", "unsat")
    }
    document = {
        "schema": "ergodis-vlsat2-full-coverage-v1",
        "scope": "all 100 official VLSAT-2 instances in table order",
        "method": {
            "purpose": "logical theorem coverage only; elapsed fields are diagnostic, not benchmark claims",
            "timeout_s": args.timeout,
            "raw_samples": str(args.raw_jsonl),
        },
        "host": host_metadata(args.cpu),
        "artifacts": {
            "manifest_sha256": sha256(args.manifest),
            "raw_jsonl_sha256": sha256(args.raw_jsonl),
            "runner_sha256": sha256(Path(__file__)),
            "checker_sha256": sha256(Path(__file__).with_name("check_vlsat2_coverage.py")),
            "clique_replay_sha256": sha256(
                Path(__file__).with_name("check_vlsat2_prefix.py")
            ),
            "process_runner_sha256": sha256(
                Path(__file__).with_name("run_satcomp24_portfolio.py")
            ),
            "ergodis_sha256": sha256(args.ergodis),
        },
        "summary": summary,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
