#!/usr/bin/env python3
"""Long-timeout paired controls for the tower and Hamming application rows."""

from __future__ import annotations

import argparse
import json
import math
import statistics
from pathlib import Path

from run_application_readme_ab import (
    BENCHMARK_PYTHON,
    CASES,
    implementation_metadata,
    parse_sample,
)
from run_satcomp24_portfolio import distribution, host_metadata, run, sha256, t_score


ROOT = Path(__file__).resolve().parent.parent
SELECTED_NAMES = {"represented_gf4_tower", "hamming_outer_lrc"}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--python", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--profile", required=True)
    parser.add_argument("--repetitions", type=int, required=True)
    parser.add_argument("--rounds", type=int, default=3)
    parser.add_argument("--timeout", type=float, required=True)
    parser.add_argument("--cpu", type=int, required=True)
    args = parser.parse_args()
    if args.rounds < 3 or args.repetitions < 1 or args.timeout <= 0:
        raise SystemExit("invalid rounds, repetitions, or timeout")
    selected = [case for case in CASES if case["name"] in SELECTED_NAMES]
    host = host_metadata(args.cpu)
    if not host["canonical_host_ready"]:
        raise SystemExit("require performance governor and boost disabled")

    summaries = []
    suite_logs: list[float] = []
    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for case_index, case in enumerate(selected):
            samples: dict[str, list[dict[str, object]]] = {
                "ergodis": [],
                "competitor": [],
            }
            for round_index in range(args.rounds):
                order = ("ergodis", "competitor")
                if (case_index + round_index) & 1:
                    order = tuple(reversed(order))
                for order_position, implementation in enumerate(order):
                    variant = str(case[implementation])
                    command = (
                        [str(args.ergodis), variant, str(args.repetitions)]
                        if implementation == "ergodis"
                        else [
                            str(args.python),
                            str(BENCHMARK_PYTHON),
                            variant,
                            str(args.repetitions),
                        ]
                    )
                    result = run(command, args.timeout, args.cpu)
                    payload = parse_sample(result, variant, args.repetitions)
                    record = {
                        "case": case["name"],
                        "case_index": case_index,
                        "profile": args.profile,
                        "repetitions": args.repetitions,
                        "round": round_index,
                        "order_position": order_position,
                        "implementation": implementation,
                        "variant": variant,
                        "result": result,
                        "payload": payload,
                    }
                    raw.write(json.dumps(record, sort_keys=True) + "\n")
                    samples[implementation].append(record)

            ergodis = samples["ergodis"]
            competitor = samples["competitor"]
            if any(record["payload"] is None for record in ergodis):
                raise RuntimeError(f"Ergodis failed in {case['name']}")
            completed = [
                record for record in competitor if record["payload"] is not None
            ]
            ergodis_batch = [int(record["result"]["elapsed_ns"]) for record in ergodis]
            summary: dict[str, object] = {
                **case,
                "ergodis_wall_per_solve": distribution(
                    [value / args.repetitions for value in ergodis_batch]
                ),
                "competitor_completed_rounds": len(completed),
                "competitor_timeout_rounds": args.rounds - len(completed),
            }
            if completed:
                checksums = {
                    int(record["payload"]["checksum"]) // args.repetitions
                    for record in ergodis + completed
                }
                if len(checksums) != 1:
                    raise RuntimeError(f"checksum mismatch in {case['name']}")
                summary["competitor_wall_per_solve"] = distribution(
                    [
                        int(record["result"]["elapsed_ns"]) / args.repetitions
                        for record in completed
                    ]
                )
            if len(completed) == args.rounds:
                ratios = [
                    int(competitor[index]["result"]["elapsed_ns"])
                    / ergodis_batch[index]
                    for index in range(args.rounds)
                ]
                logs = [math.log(value) for value in ratios]
                suite_logs.extend(logs)
                summary.update(
                    {
                        "classification": "completed_pair",
                        "median_speedup": statistics.median(ratios),
                        "geometric_mean_speedup": math.exp(statistics.mean(logs)),
                        "log_ratio_t_score": t_score(logs),
                    }
                )
            else:
                summary.update(
                    {
                        "classification": "timeout_lower_bound",
                        "speedup_lower_bound": args.timeout
                        * 1_000_000_000
                        / statistics.median(ergodis_batch),
                    }
                )
            summaries.append(summary)

    output = {
        "schema": "ergodis-application-long-controls-v1",
        "protocol": {
            "profile": args.profile,
            "repetitions_per_process": args.repetitions,
            "rounds": args.rounds,
            "timeout_s": args.timeout,
            "cpu": args.cpu,
            "fresh_process_per_sample": True,
            "rotated_interleave": True,
            "metric": "external wall time including implementation startup",
        },
        "host": host,
        "implementations": implementation_metadata(args.python),
        "artifacts": {
            "ergodis_sha256": sha256(args.ergodis),
            "benchmark_python_sha256": sha256(BENCHMARK_PYTHON),
            "runner_sha256": sha256(Path(__file__).resolve()),
            "checker_sha256": sha256(
                ROOT / "python/check_application_long_controls.py"
            ),
            "raw_jsonl_sha256": sha256(args.raw_jsonl),
        },
        "cases": summaries,
        "completed_pair_geometric_mean_speedup": (
            math.exp(statistics.mean(suite_logs)) if suite_logs else None
        ),
        "completed_pair_log_ratio_t_score": t_score(suite_logs),
    }
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
