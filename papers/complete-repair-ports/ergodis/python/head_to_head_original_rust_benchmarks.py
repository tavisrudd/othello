#!/usr/bin/env python3
"""Paired saved-binary comparison for the six headline Rust benchmarks."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import platform
import statistics
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CASES = ROOT / "evidence" / "benchmarks.json"
TRIALS_PER_PAIR = {
    "ceph_recursive_xor": 25,
    "azure_lrc_batch": 9,
    "repair_dag": 5,
    "qc_ldpc_codeword": 1,
    "vector_node_span": 3,
    "gpu_checkpoint_mds": 3,
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def summarize(pairs: list[dict[str, float]], repetitions: int) -> dict[str, object]:
    baseline = [pair["baseline_elapsed_ns"] / repetitions for pair in pairs]
    candidate = [pair["candidate_elapsed_ns"] / repetitions for pair in pairs]
    differences = [right - left for left, right in zip(baseline, candidate)]
    log_ratios = [math.log(right / left) for left, right in zip(baseline, candidate)]
    count = len(pairs)
    mean_difference = statistics.mean(differences)
    difference_sd = statistics.stdev(differences)
    mean_log_ratio = statistics.mean(log_ratios)
    log_ratio_sd = statistics.stdev(log_ratios)
    raw_t = mean_difference / (difference_sd / math.sqrt(count))
    log_t = mean_log_ratio / (log_ratio_sd / math.sqrt(count))
    # Accurate to much better than the timing precision for df=100.  Keep the
    # protocol fixed at 101 pairs so the evidence does not silently misuse it.
    t_critical_95 = 1.983971518
    log_half_width = t_critical_95 * log_ratio_sd / math.sqrt(count)
    # Two-sided alpha=.05, 80% normal-approximation sensitivity on log ratios.
    detectable_log_effect = (t_critical_95 + 0.841621234) * log_ratio_sd / math.sqrt(count)
    return {
        "pairs": count,
        "degrees_of_freedom": count - 1,
        "baseline_median_ns_per_solve": statistics.median(baseline),
        "candidate_median_ns_per_solve": statistics.median(candidate),
        "paired_mean_delta_ns_per_solve": mean_difference,
        "paired_raw_t_score": raw_t,
        "geometric_mean_candidate_over_baseline": math.exp(mean_log_ratio),
        "geometric_mean_ratio_ci95": [
            math.exp(mean_log_ratio - log_half_width),
            math.exp(mean_log_ratio + log_half_width),
        ],
        "paired_log_ratio_t_score": log_t,
        "paired_log_ratio_sd": log_ratio_sd,
        "estimated_mde80_percent": 100.0 * math.expm1(detectable_log_effect),
        "candidate_faster_pairs": sum(right < left for left, right in zip(baseline, candidate)),
        "baseline_faster_pairs": sum(left < right for left, right in zip(baseline, candidate)),
        "ties": sum(left == right for left, right in zip(baseline, candidate)),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline-binary", type=Path, required=True)
    parser.add_argument("--candidate-binary", type=Path, required=True)
    parser.add_argument("--cases", type=Path, default=DEFAULT_CASES)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=101)
    parser.add_argument("--cpu", default="2")
    parser.add_argument("--baseline-revision", required=True)
    args = parser.parse_args()
    if args.rounds != 101:
        raise SystemExit("this protocol fixes 101 pairs and 100 degrees of freedom")

    recorded = json.loads(args.cases.read_text())[
        "application_formulation_specific_comparisons"
    ]["measurements"]
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
        sample = recorded[name]["rust"]["samples"][0]
        cases.append((name, sample["variant"], sample["repetitions"]))

    paired = {name: [] for name in names}
    identities: dict[str, tuple[int, int]] = {}
    binaries = (("baseline", args.baseline_binary), ("candidate", args.candidate_binary))
    for round_index in range(args.rounds):
        rotated_cases = cases[round_index % len(cases) :] + cases[: round_index % len(cases)]
        for name, variant, repetitions in rotated_cases:
            trial_values = {"baseline": [], "candidate": []}
            for trial_index in range(TRIALS_PER_PAIR[name]):
                order_index = (round_index + trial_index) % 2
                binary_order = binaries[order_index:] + binaries[:order_index]
                for label, binary in binary_order:
                    completed = subprocess.run(
                        ["taskset", "-c", args.cpu, str(binary), variant, str(repetitions)],
                        check=True,
                        text=True,
                        stdout=subprocess.PIPE,
                    )
                    sample = json.loads(completed.stdout)
                    if sample["variant"] != variant or sample["repetitions"] != repetitions:
                        raise RuntimeError(f"benchmark identity mismatch: {name}/{label}")
                    identity = (
                        sample["checksum"] // repetitions,
                        sample["work"] // repetitions,
                    )
                    if name in identities and identities[name] != identity:
                        raise RuntimeError(f"result/work mismatch: {name}/{label}")
                    identities[name] = identity
                    trial_values[label].append(sample)
            paired[name].append(
                {
                    "round": round_index,
                    "first": binaries[round_index % 2][0],
                    "trials": TRIALS_PER_PAIR[name],
                    "baseline_elapsed_ns": statistics.median(
                        value["elapsed_ns"] for value in trial_values["baseline"]
                    ),
                    "candidate_elapsed_ns": statistics.median(
                        value["elapsed_ns"] for value in trial_values["candidate"]
                    ),
                    "baseline_peak_rss_kib": statistics.median(
                        value["peak_rss_kib"] for value in trial_values["baseline"]
                    ),
                    "candidate_peak_rss_kib": statistics.median(
                        value["peak_rss_kib"] for value in trial_values["candidate"]
                    ),
                    "baseline_trial_elapsed_ns": [
                        value["elapsed_ns"] for value in trial_values["baseline"]
                    ],
                    "candidate_trial_elapsed_ns": [
                        value["elapsed_ns"] for value in trial_values["candidate"]
                    ],
                }
            )

    results = {}
    for name, variant, repetitions in cases:
        results[name] = {
            "variant": variant,
            "repetitions": repetitions,
            "fresh_process_trials_per_pair": TRIALS_PER_PAIR[name],
            "checksum_per_solve": identities[name][0],
            "work_per_solve": identities[name][1],
            "statistics": summarize(paired[name], repetitions),
            "paired_samples": paired[name],
        }
    output = {
        "schema": "ergodis-original-rust-paired-v1",
        "scope": "six original headline application benchmarks; saved baseline versus HEAD",
        "protocol": {
            "rounds": args.rounds,
            "ordering": "case rotation plus alternating adjacent baseline/candidate order",
            "cpu_affinity": args.cpu,
            "timing": "in-process monotonic elapsed time including input compilation",
            "aggregation": "original repetition counts; case-specific odd counts of fresh-process trials; per-pair median",
            "machine": platform.uname()._asdict(),
            "inference": "paired t scores on raw differences and log ratios; ratio CI uses t(100)",
        },
        "artifacts": {
            "baseline_revision": args.baseline_revision,
            "baseline_binary_sha256": sha256(args.baseline_binary),
            "candidate_revision": subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=ROOT,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip(),
            "candidate_binary_sha256": sha256(args.candidate_binary),
            "cases_sha256": sha256(args.cases),
            "runner_sha256": sha256(Path(__file__).resolve()),
        },
        "results": results,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
