#!/usr/bin/env python3
"""Check a six-application Rust rerun evidence document."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
from pathlib import Path


EXPECTED = {
    "ceph_recursive_xor",
    "azure_lrc_batch",
    "repair_dag",
    "qc_ldpc_codeword",
    "vector_node_span",
    "gpu_checkpoint_mds",
}
ROOT = Path(__file__).resolve().parent.parent
DEFAULT_BASELINE = ROOT / "evidence" / "benchmarks.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    parser.add_argument("--baseline", type=Path, default=DEFAULT_BASELINE)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    baseline = json.loads(args.baseline.read_text())[
        "application_formulation_specific_comparisons"
    ]["measurements"]
    if document["schema"] != "ergodis-original-rust-rerun-v1":
        raise SystemExit("unexpected schema")
    if set(document["results"]) != EXPECTED:
        raise SystemExit("application set mismatch")
    rounds = document["protocol"]["rounds"]
    if document["artifacts"]["baseline_sha256"] != sha256(args.baseline):
        raise SystemExit("baseline hash mismatch")
    for name, result in document["results"].items():
        if len(result["samples"]) != rounds:
            raise SystemExit(f"sample count mismatch: {name}")
        if result["speedup"] <= 0 or result["current_median_ns_per_solve"] <= 0:
            raise SystemExit(f"invalid timing: {name}")
        if result["current_median_peak_rss_kib"] <= 0:
            raise SystemExit(f"invalid RSS: {name}")
        repetitions = result["repetitions"]
        checksum = result["checksum_per_solve"]
        work = result["work_per_solve"]
        for sample in result["samples"]:
            if sample["variant"] != result["variant"]:
                raise SystemExit(f"variant mismatch: {name}")
            if sample["repetitions"] != repetitions:
                raise SystemExit(f"repetition mismatch: {name}")
            if sample["checksum"] // repetitions != checksum:
                raise SystemExit(f"checksum mismatch: {name}")
            if sample["work"] // repetitions != work:
                raise SystemExit(f"work mismatch: {name}")
        current_ns = statistics.median(
            sample["elapsed_ns"] / repetitions for sample in result["samples"]
        )
        current_rss = statistics.median(
            sample["peak_rss_kib"] for sample in result["samples"]
        )
        recorded = baseline[name]["rust"]
        expected = {
            "recorded_median_ns_per_solve": recorded["median_ns_per_solve"],
            "current_median_ns_per_solve": current_ns,
            "time_delta_percent": 100.0
            * (current_ns / recorded["median_ns_per_solve"] - 1.0),
            "speedup": recorded["median_ns_per_solve"] / current_ns,
            "recorded_median_peak_rss_kib": recorded["median_peak_rss_kib"],
            "current_median_peak_rss_kib": current_rss,
            "rss_delta_kib": current_rss - recorded["median_peak_rss_kib"],
            "rss_delta_percent": 100.0
            * (current_rss / recorded["median_peak_rss_kib"] - 1.0),
        }
        if checksum != recorded["checksum_per_solve"]:
            raise SystemExit(f"recorded checksum mismatch: {name}")
        for field, expected_value in expected.items():
            if not math.isclose(result[field], expected_value, rel_tol=1e-12):
                raise SystemExit(f"derived field mismatch: {name}.{field}")
    print(f"checked {len(EXPECTED)} applications x {rounds} rounds")


if __name__ == "__main__":
    main()
