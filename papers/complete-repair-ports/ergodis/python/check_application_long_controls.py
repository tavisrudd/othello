#!/usr/bin/env python3
"""Independent checker for the long application-control evidence."""

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


def t_score(samples: list[float]) -> float | None:
    if len(samples) < 2:
        return None
    deviation = statistics.stdev(samples)
    return (
        None
        if deviation == 0
        else statistics.mean(samples) / (deviation / math.sqrt(len(samples)))
    )


def close(left: float | None, right: float | None) -> bool:
    if left is None or right is None:
        return left is right
    return math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--summary", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--python-source", type=Path, required=True)
    parser.add_argument("--runner", type=Path, required=True)
    args = parser.parse_args()
    summary = json.loads(args.summary.read_text())
    if summary["schema"] != "ergodis-application-long-controls-v1":
        raise SystemExit("wrong schema")
    expected_hashes = {
        "ergodis_sha256": sha256(args.ergodis),
        "benchmark_python_sha256": sha256(args.python_source),
        "runner_sha256": sha256(args.runner),
        "checker_sha256": sha256(Path(__file__).resolve()),
        "raw_jsonl_sha256": sha256(args.raw_jsonl),
    }
    if summary["artifacts"] != expected_hashes:
        raise SystemExit("artifact hash mismatch")
    protocol = summary["protocol"]
    rounds = int(protocol["rounds"])
    repetitions = int(protocol["repetitions_per_process"])
    timeout_ns = float(protocol["timeout_s"]) * 1_000_000_000
    records = [json.loads(line) for line in args.raw_jsonl.read_text().splitlines()]
    if len(records) != 2 * rounds * len(summary["cases"]):
        raise SystemExit("wrong record count")
    cursor = 0
    suite_logs: list[float] = []
    counts = {"completed_pair": 0, "timeout_lower_bound": 0}
    for case_index, case in enumerate(summary["cases"]):
        by_impl = {"ergodis": [], "competitor": []}
        for round_index in range(rounds):
            order = ("ergodis", "competitor")
            if (case_index + round_index) & 1:
                order = tuple(reversed(order))
            for order_position, implementation in enumerate(order):
                record = records[cursor]
                cursor += 1
                variant = case[implementation]
                if not (
                    record["case"] == case["name"]
                    and record["case_index"] == case_index
                    and record["profile"] == protocol["profile"]
                    and record["repetitions"] == repetitions
                    and record["round"] == round_index
                    and record["order_position"] == order_position
                    and record["implementation"] == implementation
                    and record["variant"] == variant
                ):
                    raise SystemExit("record sequence mismatch")
                payload = record["payload"]
                if payload is not None and not (
                    record["result"]["status"] == "completed"
                    and record["result"]["exit_code"] == 0
                    and payload["variant"] == variant
                    and payload["repetitions"] == repetitions
                ):
                    raise SystemExit("bad completed payload")
                by_impl[implementation].append(record)
        ergodis = by_impl["ergodis"]
        competitor = by_impl["competitor"]
        if any(record["payload"] is None for record in ergodis):
            raise SystemExit("Ergodis did not complete")
        completed = [record for record in competitor if record["payload"] is not None]
        checksums = {
            int(record["payload"]["checksum"]) // repetitions
            for record in ergodis + completed
        }
        if len(checksums) != 1:
            raise SystemExit("checksum mismatch")
        ergodis_batch = [int(record["result"]["elapsed_ns"]) for record in ergodis]
        classification = case["classification"]
        counts[classification] += 1
        if len(completed) == rounds:
            if classification != "completed_pair":
                raise SystemExit("wrong classification")
            ratios = [
                int(competitor[index]["result"]["elapsed_ns"]) / ergodis_batch[index]
                for index in range(rounds)
            ]
            logs = [math.log(value) for value in ratios]
            suite_logs.extend(logs)
            if not (
                close(case["median_speedup"], statistics.median(ratios))
                and close(
                    case["geometric_mean_speedup"], math.exp(statistics.mean(logs))
                )
                and close(case["log_ratio_t_score"], t_score(logs))
            ):
                raise SystemExit("paired statistic mismatch")
        else:
            bound = timeout_ns / statistics.median(ergodis_batch)
            if classification != "timeout_lower_bound" or not close(
                case["speedup_lower_bound"], bound
            ):
                raise SystemExit("lower-bound mismatch")
    expected_geomean = math.exp(statistics.mean(suite_logs)) if suite_logs else None
    if not (
        close(summary["completed_pair_geometric_mean_speedup"], expected_geomean)
        and close(summary["completed_pair_log_ratio_t_score"], t_score(suite_logs))
    ):
        raise SystemExit("suite statistic mismatch")
    print(
        f"verified={len(summary['cases'])}; "
        f"completed_pairs={counts['completed_pair']}; "
        f"timeout_lower_bounds={counts['timeout_lower_bound']}"
    )


if __name__ == "__main__":
    main()
