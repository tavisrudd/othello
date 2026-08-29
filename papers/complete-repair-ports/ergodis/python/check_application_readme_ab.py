#!/usr/bin/env python3
"""Independent replay checker for the README application A/B evidence."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def close(left: float | None, right: float | None) -> bool:
    if left is None or right is None:
        return left is right
    return math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)


def t_score(samples: list[float]) -> float | None:
    if len(samples) < 2:
        return None
    deviation = statistics.stdev(samples)
    if deviation == 0:
        return None
    return statistics.mean(samples) / (deviation / math.sqrt(len(samples)))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--summary", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--bench-source", type=Path, required=True)
    parser.add_argument("--python-source", type=Path, required=True)
    parser.add_argument("--runner", type=Path, required=True)
    args = parser.parse_args()

    summary = json.loads(args.summary.read_text())
    if summary["schema"] != "ergodis-application-readme-ab-v3":
        raise SystemExit("wrong schema")
    artifacts = summary["artifacts"]
    expected_hashes = {
        "ergodis_sha256": sha256(args.ergodis),
        "bench_kernels_source_sha256": sha256(args.bench_source),
        "benchmark_python_sha256": sha256(args.python_source),
        "runner_sha256": sha256(args.runner),
        "checker_sha256": sha256(Path(__file__).resolve()),
        "raw_jsonl_sha256": sha256(args.raw_jsonl),
    }
    if artifacts != expected_hashes:
        raise SystemExit("artifact hash mismatch")
    protocol = summary["protocol"]
    rounds = int(protocol["rounds"])
    timeout_ns = float(protocol["timeout_s"]) * 1_000_000_000
    records = [json.loads(line) for line in args.raw_jsonl.read_text().splitlines()]
    profiles = tuple(summary["protocol"]["profiles"].items())
    if len(records) != 2 * rounds * len(summary["cases"]) * len(profiles):
        raise SystemExit("wrong raw record count")

    suite_logs: dict[str, list[float]] = {name: [] for name, _ in profiles}
    cursor = 0
    classifications = {"completed_pair": 0, "timeout_lower_bound": 0}
    for case_index, case in enumerate(summary["cases"]):
        for profile_index, (profile, repetitions_value) in enumerate(profiles):
            repetitions = int(repetitions_value)
            by_impl: dict[str, list[dict[str, object]]] = {
                "ergodis": [],
                "competitor": [],
            }
            for round_index in range(rounds):
                expected_order = ("ergodis", "competitor")
                if (case_index + profile_index + round_index) & 1:
                    expected_order = tuple(reversed(expected_order))
                for order_position, implementation in enumerate(expected_order):
                    record = records[cursor]
                    cursor += 1
                    expected = (
                        case["ergodis"]
                        if implementation == "ergodis"
                        else case["competitor"]
                    )
                    identity = (
                        record["case"] == case["name"]
                        and record["case_index"] == case_index
                        and record["profile"] == profile
                        and record["profile_index"] == profile_index
                        and record["repetitions"] == repetitions
                        and record["round"] == round_index
                        and record["order_position"] == order_position
                        and record["implementation"] == implementation
                        and record["variant"] == expected
                    )
                    if not identity:
                        raise SystemExit("raw sequence mismatch")
                    payload = record["payload"]
                    result = record["result"]
                    if payload is not None:
                        if (
                            result["status"] != "completed"
                            or result["exit_code"] != 0
                            or payload["variant"] != expected
                            or payload["repetitions"] != repetitions
                        ):
                            raise SystemExit("invalid completed record")
                    by_impl[implementation].append(record)

            ergodis = by_impl["ergodis"]
            competitor = by_impl["competitor"]
            if any(record["payload"] is None for record in ergodis):
                raise SystemExit("incomplete Ergodis record")
            completed = [
                record for record in competitor if record["payload"] is not None
            ]
            checksums = {
                int(record["payload"]["checksum"]) // repetitions
                for record in ergodis + completed
            }
            if len(checksums) != 1:
                raise SystemExit("checksum mismatch")
            ergodis_times = [int(record["result"]["elapsed_ns"]) for record in ergodis]
            profile_summary = case["profiles"][profile]
            classification = profile_summary["classification"]
            classifications[classification] += 1
            if len(completed) == rounds:
                if classification != "completed_pair":
                    raise SystemExit("wrong completed classification")
                ratios = [
                    int(competitor[index]["result"]["elapsed_ns"])
                    / ergodis_times[index]
                    for index in range(rounds)
                ]
                logs = [math.log(value) for value in ratios]
                suite_logs[profile].extend(logs)
                if not (
                    close(profile_summary["median_speedup"], statistics.median(ratios))
                    and close(
                        profile_summary["geometric_mean_speedup"],
                        math.exp(statistics.mean(logs)),
                    )
                    and close(profile_summary["log_ratio_t_score"], t_score(logs))
                ):
                    raise SystemExit("completed-pair statistic mismatch")
            else:
                if classification != "timeout_lower_bound":
                    raise SystemExit("wrong timeout classification")
                bound = timeout_ns / statistics.median(ergodis_times)
                if not close(profile_summary["speedup_lower_bound"], bound):
                    raise SystemExit("timeout lower-bound mismatch")

    for profile, logs in suite_logs.items():
        expected_geomean = math.exp(statistics.mean(logs)) if logs else None
        aggregate = summary["completed_case_aggregates"][profile]
        if not (
            close(aggregate["geometric_mean_speedup"], expected_geomean)
            and close(aggregate["log_ratio_t_score"], t_score(logs))
        ):
            raise SystemExit("suite statistic mismatch")
    print(
        f"verified={len(summary['cases'])}; "
        f"completed_pairs={classifications['completed_pair']}; "
        f"timeout_lower_bounds={classifications['timeout_lower_bound']}"
    )


if __name__ == "__main__":
    main()
