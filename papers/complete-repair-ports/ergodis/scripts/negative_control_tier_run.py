#!/usr/bin/env python3
"""Paired-round runner for the C1038 negative-control benchmark tier.

Follows the corrected protocol already documented in ``BENCHMARKS.md``: a fresh
process per sample, both sides pinned to the same CPU, rotated A/B order across
rounds, construction and startup inside the timed region, process high-water
resident set size recorded, and medians reported from unrounded samples.

Each instance is emitted once by the ergodis example and handed to both sides,
so the two solvers read identical bytes.

usage: negative_control_tier_run.py --ergodis BIN --python PY --output JSON \
         --raw-jsonl JSONL [--rounds N] [--timeout S] [--cpu N] [--rows L1,...]
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import statistics
import subprocess
import sys
import tempfile
import time

ROWS = [
    "L1", "L2", "L3", "W1", "W2", "W3",
    # Crossover ladder for the bounded subset-sum width cap.
    "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8",
]
SCHEMA_VERSION = 1


def sha256_file(path: str) -> tuple[str, int]:
    digest = hashlib.sha256()
    total = 0
    with open(path, "rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
            total += len(block)
    return digest.hexdigest(), total


def choom(command: list[str], cpu: int) -> list[str]:
    """Wrap a command with the documented out-of-memory and affinity guards."""
    wrapped = list(command)
    if shutil.which("taskset"):
        wrapped = ["taskset", "-c", str(cpu)] + wrapped
    if shutil.which("choom"):
        wrapped = ["choom", "-n", "1000", "--"] + wrapped
    return wrapped


def run_json(command: list[str], timeout: float) -> dict:
    started = time.perf_counter_ns()
    try:
        completed = subprocess.run(
            command,
            check=False,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return {
            "status": "timeout",
            "detail": f"exceeded {timeout} s",
            "elapsed_ns": str(int(timeout * 1e9)),
            "answer": None,
            "work": 0,
            "representation": 0,
            "certificate_bytes": 0,
            "replay_ns": "0",
            "peak_rss_kib": 0,
        }
    external_ns = time.perf_counter_ns() - started
    if completed.returncode != 0:
        return {
            "status": "error",
            "detail": completed.stderr.strip()[-400:],
            "elapsed_ns": str(external_ns),
            "answer": None,
            "work": 0,
            "representation": 0,
            "certificate_bytes": 0,
            "replay_ns": "0",
            "peak_rss_kib": 0,
        }
    record = json.loads(completed.stdout.strip().splitlines()[-1])
    record["external_ns"] = str(external_ns)
    return record


def median_ns(samples: list[dict], key: str = "elapsed_ns") -> float | None:
    values = [int(sample[key]) for sample in samples if sample.get(key) is not None]
    return statistics.median(values) if values else None


def median_int(samples: list[dict], key: str) -> int | None:
    values = [int(sample[key]) for sample in samples if sample.get(key) is not None]
    return int(statistics.median(values)) if values else None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ergodis", required=True)
    parser.add_argument("--python", required=True)
    parser.add_argument("--control", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--raw-jsonl", required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--timeout", type=float, default=600.0)
    parser.add_argument("--cpu", type=int, default=3)
    parser.add_argument("--rows", default=",".join(ROWS))
    arguments = parser.parse_args()

    rows = [row.strip() for row in arguments.rows.split(",") if row.strip()]
    workdir = tempfile.mkdtemp(prefix="c1038-")
    raw = open(arguments.raw_jsonl, "w", encoding="utf-8", buffering=1)
    results = {}

    for row in rows:
        instance_path = os.path.join(workdir, f"{row}.json")
        with open(instance_path, "w", encoding="utf-8") as handle:
            subprocess.run(
                [arguments.ergodis, "emit", row], check=True, stdout=handle
            )
        instance_hash, instance_bytes = sha256_file(instance_path)

        ergodis_samples: list[dict] = []
        control_samples: list[dict] = []
        for round_index in range(arguments.rounds):
            ergodis_command = choom([arguments.ergodis, "solve", row, "1"], arguments.cpu)
            control_command = choom(
                [arguments.python, arguments.control, instance_path, "--workers", "1"],
                arguments.cpu,
            )
            order = (
                [("ergodis", ergodis_command), ("control", control_command)]
                if round_index % 2 == 0
                else [("control", control_command), ("ergodis", ergodis_command)]
            )
            for side, command in order:
                record = run_json(command, arguments.timeout)
                record["row"] = row
                record["side"] = side
                record["round"] = round_index
                raw.write(json.dumps(record, sort_keys=True, separators=(",", ":")) + "\n")
                (ergodis_samples if side == "ergodis" else control_samples).append(record)

        ergodis_answers = {sample.get("answer") for sample in ergodis_samples}
        control_answers = {sample.get("answer") for sample in control_samples}
        ergodis_declined = all(
            sample.get("status") == "declined" for sample in ergodis_samples
        )
        control_timeout = any(sample.get("status") == "timeout" for sample in control_samples)

        if ergodis_declined:
            agreement = "ergodis declined the instance under its declared bounds"
        elif control_timeout:
            agreement = "control did not finish inside the cell budget"
        elif len(ergodis_answers) == 1 and ergodis_answers == control_answers:
            agreement = "exact agreement"
        else:
            agreement = f"disagreement: ergodis {sorted(map(str, ergodis_answers))} control {sorted(map(str, control_answers))}"

        ergodis_ns = None if ergodis_declined else median_ns(ergodis_samples)
        control_ns = median_ns(control_samples)
        speedup = None
        if ergodis_ns and control_ns and ergodis_ns > 0:
            speedup = control_ns / ergodis_ns

        results[row] = {
            "instance_sha256": instance_hash,
            "instance_bytes": instance_bytes,
            "rounds": arguments.rounds,
            "timeout_s": arguments.timeout,
            "ergodis_status": "declined" if ergodis_declined else "ok",
            "ergodis_detail": ergodis_samples[0].get("detail", ""),
            "ergodis_answer": sorted(
                str(answer) for answer in ergodis_answers if answer is not None
            ),
            "control_answer": sorted(
                str(answer) for answer in control_answers if answer is not None
            ),
            "agreement": agreement,
            "ergodis_median_ns": ergodis_ns,
            "control_median_ns": control_ns,
            "ergodis_peak_rss_kib": median_int(ergodis_samples, "peak_rss_kib"),
            "control_peak_rss_kib": median_int(control_samples, "peak_rss_kib"),
            "ergodis_representation": median_int(ergodis_samples, "representation"),
            "ergodis_certificate_bytes": median_int(ergodis_samples, "certificate_bytes"),
            "ergodis_replay_ns": median_int(ergodis_samples, "replay_ns"),
            "control_certificate_bytes": 0,
            "ergodis_over_control": speedup,
            "direction": (
                "ergodis loses"
                if ergodis_declined or (speedup is not None and speedup < 1.0)
                else "ergodis wins"
                if speedup is not None
                else "unresolved"
            ),
        }
        print(f"{row}: {results[row]['direction']} ({agreement})", file=sys.stderr)

    raw.close()
    raw_hash, raw_bytes = sha256_file(arguments.raw_jsonl)
    ergodis_hash, ergodis_bytes = sha256_file(arguments.ergodis)
    control_hash, control_bytes = sha256_file(arguments.control)
    root = os.path.dirname(os.path.dirname(os.path.abspath(arguments.control)))
    example_source = os.path.join(root, "examples", "negative_control_tier.rs")
    classifier = os.path.join(root, "docs", "ergodis-shape-classifier.md")
    source_hash, source_bytes = sha256_file(example_source)
    classifier_hash, classifier_bytes = sha256_file(classifier)

    summary = {
        "schema_version": SCHEMA_VERSION,
        "task": "C1038",
        "what_this_certifies": (
            "Paired fresh-process timings, peak resident set size, and exact answer "
            "agreement for six declared instances against a single-worker CP-SAT "
            "control on one host. It does not certify a general solver comparison, "
            "any result outside these instances, or that the shape classifier is "
            "complete."
        ),
        "protocol": {
            "rounds": arguments.rounds,
            "timeout_s": arguments.timeout,
            "cpu": arguments.cpu,
            "fresh_process_per_sample": True,
            "rotated_order": True,
            "control_workers": 1,
        },
        "artifacts": {
            "classifier": {
                "path": "docs/ergodis-shape-classifier.md",
                "sha256": classifier_hash,
                "bytes": classifier_bytes,
            },
            "example_source": {
                "path": "examples/negative_control_tier.rs",
                "sha256": source_hash,
                "bytes": source_bytes,
            },
            "control_source": {
                "path": "scripts/negative_control_tier_control.py",
                "sha256": control_hash,
                "bytes": control_bytes,
            },
            "ergodis_binary": {"sha256": ergodis_hash, "bytes": ergodis_bytes},
            "raw_jsonl": {
                "path": os.path.basename(arguments.raw_jsonl),
                "sha256": raw_hash,
                "bytes": raw_bytes,
            },
        },
        "rows": results,
    }
    with open(arguments.output, "w", encoding="utf-8") as handle:
        json.dump(summary, handle, indent=2, sort_keys=True)
        handle.write("\n")
    shutil.rmtree(workdir, ignore_errors=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
