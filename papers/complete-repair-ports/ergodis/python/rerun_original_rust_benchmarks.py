#!/usr/bin/env python3
"""Rerun the six original headline application benchmarks on the Rust side."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import statistics
import subprocess
from pathlib import Path


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
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--baseline", type=Path, default=DEFAULT_BASELINE)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=11)
    parser.add_argument("--cpu", default="2")
    args = parser.parse_args()

    baseline_document = json.loads(args.baseline.read_text())
    recorded = baseline_document["application_formulation_specific_comparisons"][
        "measurements"
    ]
    names = (
        "ceph_recursive_xor",
        "azure_lrc_batch",
        "repair_dag",
        "qc_ldpc_codeword",
        "vector_node_span",
        "gpu_checkpoint_mds",
    )
    cases = []
    for name in names:
        prior = recorded[name]["rust"]
        sample = prior["samples"][0]
        cases.append((name, sample["variant"], sample["repetitions"], prior))

    samples: dict[str, list[dict[str, object]]] = {name: [] for name in names}
    for round_index in range(args.rounds):
        rotated = cases[round_index % len(cases) :] + cases[: round_index % len(cases)]
        for name, variant, repetitions, _ in rotated:
            completed = subprocess.run(
                [
                    "taskset",
                    "-c",
                    args.cpu,
                    str(args.binary),
                    variant,
                    str(repetitions),
                ],
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            )
            sample = json.loads(completed.stdout)
            if sample["variant"] != variant or sample["repetitions"] != repetitions:
                raise RuntimeError(f"benchmark identity mismatch: {name}")
            samples[name].append(sample)

    results = {}
    for name, variant, repetitions, prior in cases:
        values = samples[name]
        current_ns = statistics.median(
            value["elapsed_ns"] / value["repetitions"] for value in values
        )
        current_rss = statistics.median(value["peak_rss_kib"] for value in values)
        checksum = values[0]["checksum"] // values[0]["repetitions"]
        work = values[0]["work"] // values[0]["repetitions"]
        if any(
            value["checksum"] // value["repetitions"] != checksum
            or value["work"] // value["repetitions"] != work
            for value in values
        ):
            raise RuntimeError(f"nondeterministic result or work count: {name}")
        if checksum != prior["checksum_per_solve"]:
            raise RuntimeError(f"checksum changed from recorded result: {name}")
        prior_ns = prior["median_ns_per_solve"]
        prior_rss = prior["median_peak_rss_kib"]
        results[name] = {
            "variant": variant,
            "repetitions": repetitions,
            "recorded_median_ns_per_solve": prior_ns,
            "current_median_ns_per_solve": current_ns,
            "time_delta_percent": 100.0 * (current_ns / prior_ns - 1.0),
            "speedup": prior_ns / current_ns,
            "recorded_median_peak_rss_kib": prior_rss,
            "current_median_peak_rss_kib": current_rss,
            "rss_delta_kib": current_rss - prior_rss,
            "rss_delta_percent": 100.0 * (current_rss / prior_rss - 1.0),
            "checksum_per_solve": checksum,
            "work_per_solve": work,
            "samples": values,
        }

    output = {
        "schema": "ergodis-original-rust-rerun-v1",
        "scope": "six original headline application benchmarks; Ergodis side only",
        "protocol": {
            "rounds": args.rounds,
            "ordering": "rotated interleave",
            "cpu_affinity": args.cpu,
            "timing": "in-process monotonic elapsed time including input compilation",
            "memory": "process VmHWM/resource ru_maxrss",
            "machine": platform.uname()._asdict(),
        },
        "artifacts": {
            "binary_sha256": sha256(args.binary),
            "baseline_sha256": sha256(args.baseline),
            "runner_sha256": sha256(Path(__file__).resolve()),
            "git_head": subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=ROOT,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip(),
        },
        "results": results,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
