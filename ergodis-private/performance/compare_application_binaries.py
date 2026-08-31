#!/usr/bin/env python3
"""Fresh-process cold/warm comparison of two Ergodis application binaries."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
import subprocess
import time
from pathlib import Path


CASES = (
    ("ceph_recursive_xor", "application:ceph-zdd:rust:8:2"),
    ("represented_gf4_tower", "transfer-tower:rust:6:4"),
    ("azure_lrc_batch", "application:azure:rust:100000:100000"),
    ("repair_dag", "application:rdag:rust:21:3"),
    ("qc_ldpc_codeword", "application:qc:rust:50000:4"),
    ("vector_node_span", "application:vector:rust:64:2"),
    ("hamming_outer_lrc", "jin-fu-hamming:rust:6"),
    ("gpu_mds_checkpoint", "application:gpu-compiled:rust:10000:6000:64"),
)
PROFILES = (("cold", 1), ("warm_batch", 8))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def run(binary: Path, variant: str, repetitions: int, cpu: int, timeout: float) -> dict:
    command = [
        "taskset",
        "-c",
        str(cpu),
        "choom",
        "-n",
        "500",
        "--",
        str(binary),
        variant,
        str(repetitions),
    ]
    started = time.perf_counter_ns()
    process = subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
    )
    elapsed_ns = time.perf_counter_ns() - started
    payload = json.loads(process.stdout)
    if payload["variant"] != variant or payload["repetitions"] != repetitions:
        raise RuntimeError(f"unexpected payload for {variant}")
    return {"elapsed_ns": elapsed_ns, "payload": payload}


def distribution(values: list[float]) -> dict[str, float]:
    return {
        "minimum": min(values),
        "median": statistics.median(values),
        "maximum": max(values),
    }


def paired_summary(old: list[dict], new: list[dict], repetitions: int) -> dict:
    old_wall = [sample["elapsed_ns"] / repetitions for sample in old]
    new_wall = [sample["elapsed_ns"] / repetitions for sample in new]
    old_internal = [sample["payload"]["elapsed_ns"] / repetitions for sample in old]
    new_internal = [sample["payload"]["elapsed_ns"] / repetitions for sample in new]
    wall_logs = [math.log(left / right) for left, right in zip(old_wall, new_wall)]
    internal_logs = [
        math.log(left / right) for left, right in zip(old_internal, new_internal)
    ]

    def summarize_logs(logs: list[float]) -> dict[str, float]:
        mean = statistics.mean(logs)
        standard_error = statistics.stdev(logs) / math.sqrt(len(logs))
        return {
            "old_over_new_geometric_mean": math.exp(mean),
            "paired_log_t_score": mean / standard_error,
        }

    return {
        "old_wall_ns_per_solve": distribution(old_wall),
        "new_wall_ns_per_solve": distribution(new_wall),
        "wall_ratio": summarize_logs(wall_logs),
        "old_internal_ns_per_solve": distribution(old_internal),
        "new_internal_ns_per_solve": distribution(new_internal),
        "internal_ratio": summarize_logs(internal_logs),
        "old_peak_rss_kib": distribution(
            [sample["payload"]["peak_rss_kib"] for sample in old]
        ),
        "new_peak_rss_kib": distribution(
            [sample["payload"]["peak_rss_kib"] for sample in new]
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--old", type=Path, required=True)
    parser.add_argument("--new", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--cpu", type=int, required=True)
    parser.add_argument("--timeout", type=float, default=60.0)
    args = parser.parse_args()
    if args.rounds < 3:
        raise SystemExit("at least three rounds are required")
    if args.output.exists():
        raise SystemExit(f"refusing to overwrite {args.output}")

    result: dict[str, object] = {
        "protocol": {
            "fresh_process_per_sample": True,
            "profiles": {name: repetitions for name, repetitions in PROFILES},
            "rounds": args.rounds,
            "cpu": args.cpu,
            "rotated_order": True,
        },
        "binaries": {
            "old": {"path": str(args.old), "sha256": sha256(args.old)},
            "new": {"path": str(args.new), "sha256": sha256(args.new)},
        },
        "cases": {},
        "raw": [],
    }
    all_ratios: dict[str, list[float]] = {name: [] for name, _ in PROFILES}
    for case_index, (name, variant) in enumerate(CASES):
        case_result: dict[str, object] = {}
        for profile_index, (profile, repetitions) in enumerate(PROFILES):
            samples: dict[str, list[dict]] = {"old": [], "new": []}
            for round_index in range(args.rounds):
                order = ("old", "new")
                if (case_index + profile_index + round_index) & 1:
                    order = tuple(reversed(order))
                for version in order:
                    sample = run(
                        args.old if version == "old" else args.new,
                        variant,
                        repetitions,
                        args.cpu,
                        args.timeout,
                    )
                    samples[version].append(sample)
                    result["raw"].append(
                        {
                            "case": name,
                            "profile": profile,
                            "round": round_index,
                            "version": version,
                            **sample,
                        }
                    )
            for old, new in zip(samples["old"], samples["new"]):
                old_payload = old["payload"]
                new_payload = new["payload"]
                for field in ("work", "peak_states", "checksum"):
                    if old_payload[field] != new_payload[field]:
                        raise RuntimeError(f"{name} {profile} differs in {field}")
                all_ratios[profile].append(
                    old["elapsed_ns"] / new["elapsed_ns"]
                )
            case_result[profile] = paired_summary(
                samples["old"], samples["new"], repetitions
            )
        result["cases"][name] = case_result
    result["suite_wall_ratio"] = {
        profile: math.exp(statistics.mean(math.log(value) for value in ratios))
        for profile, ratios in all_ratios.items()
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x") as target:
        json.dump(result, target, indent=2, sort_keys=True)
        target.write("\n")
    print(json.dumps({"output": str(args.output), **result["suite_wall_ratio"]}))


if __name__ == "__main__":
    main()
