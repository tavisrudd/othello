#!/usr/bin/env python3
"""Check paired saved-binary benchmark evidence and derived statistics."""

from __future__ import annotations

import argparse
import json
import math
import statistics
from pathlib import Path

import head_to_head_original_rust_benchmarks as head_to_head


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    if document["schema"] != "ergodis-original-rust-paired-v1":
        raise SystemExit("unexpected schema")
    if document["protocol"]["rounds"] != 101:
        raise SystemExit("unexpected round count")
    if set(document["results"]) != set(head_to_head.TRIALS_PER_PAIR):
        raise SystemExit("application set mismatch")
    for name, result in document["results"].items():
        repetitions = result["repetitions"]
        trials = head_to_head.TRIALS_PER_PAIR[name]
        if result["fresh_process_trials_per_pair"] != trials:
            raise SystemExit(f"trial count mismatch: {name}")
        pairs = result["paired_samples"]
        if len(pairs) != 101:
            raise SystemExit(f"pair count mismatch: {name}")
        for index, pair in enumerate(pairs):
            if pair["round"] != index or pair["trials"] != trials:
                raise SystemExit(f"pair identity mismatch: {name}/{index}")
            for label in ("baseline", "candidate"):
                values = pair[f"{label}_trial_elapsed_ns"]
                if len(values) != trials:
                    raise SystemExit(f"raw trial count mismatch: {name}/{index}/{label}")
                if pair[f"{label}_elapsed_ns"] != statistics.median(values):
                    raise SystemExit(f"pair median mismatch: {name}/{index}/{label}")
        expected = head_to_head.summarize(pairs, repetitions)
        for field, expected_value in expected.items():
            actual = result["statistics"][field]
            if isinstance(expected_value, list):
                if any(
                    not math.isclose(left, right, rel_tol=1e-12)
                    for left, right in zip(actual, expected_value)
                ):
                    raise SystemExit(f"statistic mismatch: {name}/{field}")
            elif isinstance(expected_value, float):
                if not math.isclose(actual, expected_value, rel_tol=1e-12):
                    raise SystemExit(f"statistic mismatch: {name}/{field}")
            elif actual != expected_value:
                raise SystemExit(f"statistic mismatch: {name}/{field}")
    print("checked 6 applications x 101 paired rounds")


if __name__ == "__main__":
    main()
