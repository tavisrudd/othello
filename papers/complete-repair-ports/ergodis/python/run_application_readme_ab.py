#!/usr/bin/env python3
"""Fresh-process A/B benchmark for the four README application highlights."""

from __future__ import annotations

import argparse
import json
import math
import statistics
import subprocess
from pathlib import Path

from run_satcomp24_portfolio import (
    distribution,
    host_metadata,
    rss_distribution,
    run,
    sha256,
    t_score,
)


ROOT = Path(__file__).resolve().parent.parent
BENCHMARK_PYTHON = ROOT / "python" / "benchmark_python.py"

CASES = (
    {
        "name": "ceph_recursive_xor",
        "description": "Ceph-style recursive XOR support, depth 8, binary fanout",
        "ergodis": "application:ceph-zdd:rust:8:2",
        "competitor": "application:ceph:zdd:8",
        "competitor_name": "Graphillion 2.1",
        "historical_ratio": 8.0,
    },
    {
        "name": "represented_gf4_tower",
        "description": "GF(4) represented tower, depth 6, fanout 4",
        "ergodis": "transfer-tower:rust:6:4",
        "competitor": "transfer-tower:cpsat-direct:6:4",
        "competitor_name": "OR-Tools CP-SAT 9.14 direct model",
        "historical_ratio": 344_300.0,
    },
    {
        "name": "azure_lrc_batch",
        "description": "Azure-style LRC batch, 100000 demands, six types",
        "ergodis": "application:azure:rust:100000:100000",
        "competitor": "application:azure-counted:highs:100000:100000",
        "competitor_name": "SciPy 1.16 HiGHS counted MILP",
        "historical_ratio": 173_996.0,
    },
    {
        "name": "repair_dag",
        "description": "Repair DAG, 3 layers by 21 tasks",
        "ergodis": "application:rdag:rust:21:3",
        "competitor": "application:rdag:interval-cpsat:21:3",
        "competitor_name": "OR-Tools 9.14 CP-SAT intervals",
        "historical_ratio": 7_881.0,
    },
    {
        "name": "qc_ldpc_codeword",
        "description": "QC-LDPC, lift 50000, exclude weight four",
        "ergodis": "application:qc:rust:50000:4",
        "competitor": "application:qc:cryptominisat:50000:4",
        "competitor_name": "CryptoMiniSat 5.14 native XOR",
        "historical_ratio": 336.0,
    },
    {
        "name": "vector_node_span",
        "description": "Vector repair, 64 nodes, 2 symbols per node",
        "ergodis": "application:vector:rust:64:2",
        "competitor": "application:vector:cryptominisat:64:2",
        "competitor_name": "CryptoMiniSat 5.14 native XOR",
        "historical_ratio": 4_717.0,
    },
    {
        "name": "hamming_outer_lrc",
        "description": "Jin--Fu Hamming-outer binary [4095,2718,6;2] LRC",
        "ergodis": "jin-fu-hamming:rust:6",
        "competitor": "jin-fu-hamming:cpsat-direct:6",
        "competitor_name": "OR-Tools CP-SAT 9.14 direct model",
        "historical_ratio": 432.0,
    },
    {
        "name": "gpu_mds_checkpoint",
        "description": "GPU MDS checkpoint, 10000/6000 shards, 64 failures",
        "ergodis": "application:gpu-compiled:rust:10000:6000:64",
        "competitor": "application:gpu-compiled:maxflow:10000:6000:64",
        "competitor_name": "OR-Tools 9.14 SimpleMaxFlow",
        "historical_ratio": 1_029.0,
    },
)


PROFILES = (("cold", 1), ("warm_batch", 8))


def parse_sample(
    result: dict[str, object], variant: str, repetitions: int
) -> dict[str, object] | None:
    if result["status"] != "completed" or result["exit_code"] != 0:
        return None
    payload = json.loads(str(result["stdout_tail"]))
    if payload["variant"] != variant or payload["repetitions"] != repetitions:
        raise RuntimeError(f"bad benchmark payload for {variant}")
    return payload


def implementation_metadata(python: Path) -> dict[str, object]:
    frozen = subprocess.run(
        [
            str(python),
            "-c",
            (
                "import importlib.metadata as m; "
                "print('\\n'.join(sorted(f'{d.metadata[\"Name\"]}=={d.version}' "
                "for d in m.distributions())))"
            ),
        ],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    ).stdout.splitlines()
    version = subprocess.run(
        [str(python), "--version"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    ).stdout.strip()
    return {"python": version, "packages": sorted(frozen)}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--python", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--timeout", type=float, default=10.0)
    parser.add_argument("--cpu", type=int, required=True)
    parser.add_argument("--diagnostic-host", action="store_true")
    args = parser.parse_args()
    if args.rounds < 3 or args.timeout <= 0:
        raise SystemExit("need at least three rounds and a positive timeout")

    host = host_metadata(args.cpu)
    if not host["canonical_host_ready"] and not args.diagnostic_host:
        raise SystemExit(
            "refusing canonical evidence: require performance governor and boost disabled"
        )

    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    summaries = []
    suite_logs: dict[str, list[float]] = {name: [] for name, _ in PROFILES}
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for case_index, case in enumerate(CASES):
            case_summary: dict[str, object] = {**case, "profiles": {}}
            for profile_index, (profile, repetitions) in enumerate(PROFILES):
                samples: dict[str, list[dict[str, object]]] = {
                    "ergodis": [],
                    "competitor": [],
                }
                for round_index in range(args.rounds):
                    order = ("ergodis", "competitor")
                    if (case_index + profile_index + round_index) & 1:
                        order = tuple(reversed(order))
                    for order_position, implementation in enumerate(order):
                        variant = str(case[implementation])
                        command = (
                            [str(args.ergodis), variant, str(repetitions)]
                            if implementation == "ergodis"
                            else [
                                str(args.python),
                                str(BENCHMARK_PYTHON),
                                variant,
                                str(repetitions),
                            ]
                        )
                        result = run(command, args.timeout, args.cpu)
                        payload = parse_sample(result, variant, repetitions)
                        record = {
                            "case": case["name"],
                            "case_index": case_index,
                            "profile": profile,
                            "profile_index": profile_index,
                            "repetitions": repetitions,
                            "round": round_index,
                            "order_position": order_position,
                            "implementation": implementation,
                            "variant": variant,
                            "result": result,
                            "payload": payload,
                        }
                        raw.write(json.dumps(record, sort_keys=True) + "\n")
                        samples[implementation].append(record)

                ergodis_completed = [
                    record
                    for record in samples["ergodis"]
                    if record["payload"] is not None
                ]
                competitor_completed = [
                    record
                    for record in samples["competitor"]
                    if record["payload"] is not None
                ]
                if len(ergodis_completed) != args.rounds:
                    raise RuntimeError(
                        f"ergodis did not complete every {case['name']} {profile} round"
                    )
                ergodis_times = [
                    int(record["result"]["elapsed_ns"]) / repetitions
                    for record in ergodis_completed
                ]
                profile_summary: dict[str, object] = {
                    "repetitions_per_process": repetitions,
                    "ergodis_wall_per_solve": distribution(ergodis_times),
                    "ergodis_peak_rss": rss_distribution(
                        [
                            int(record["result"]["peak_rss_kb"])
                            for record in ergodis_completed
                        ]
                    ),
                    "ergodis_internal_per_solve": distribution(
                        [
                            int(record["payload"]["elapsed_ns"]) / repetitions
                            for record in ergodis_completed
                        ]
                    ),
                    "competitor_completed_rounds": len(competitor_completed),
                    "competitor_timeout_rounds": args.rounds
                    - len(competitor_completed),
                }
                if competitor_completed:
                    profile_summary["competitor_wall_per_solve"] = distribution(
                        [
                            int(record["result"]["elapsed_ns"]) / repetitions
                            for record in competitor_completed
                        ]
                    )
                    profile_summary["competitor_peak_rss"] = rss_distribution(
                        [
                            int(record["result"]["peak_rss_kb"])
                            for record in competitor_completed
                        ]
                    )
                    profile_summary["competitor_internal_per_solve"] = distribution(
                        [
                            int(record["payload"]["elapsed_ns"]) / repetitions
                            for record in competitor_completed
                        ]
                    )
                    checksums = {
                        int(record["payload"]["checksum"]) // repetitions
                        for record in ergodis_completed + competitor_completed
                    }
                    if len(checksums) != 1:
                        raise RuntimeError(f"checksum mismatch for {case['name']}")
                if len(competitor_completed) == args.rounds:
                    ratios = [
                        int(samples["competitor"][index]["result"]["elapsed_ns"])
                        / int(samples["ergodis"][index]["result"]["elapsed_ns"])
                        for index in range(args.rounds)
                    ]
                    logs = [math.log(value) for value in ratios]
                    suite_logs[profile].extend(logs)
                    profile_summary.update(
                        {
                            "classification": "completed_pair",
                            "median_speedup": statistics.median(ratios),
                            "geometric_mean_speedup": math.exp(statistics.mean(logs)),
                            "log_ratio_t_score": t_score(logs),
                        }
                    )
                else:
                    profile_summary.update(
                        {
                            "classification": "timeout_lower_bound",
                            "speedup_lower_bound": args.timeout
                            * 1_000_000_000
                            / (statistics.median(ergodis_times) * repetitions),
                        }
                    )
                case_summary["profiles"][profile] = profile_summary
            summaries.append(case_summary)

    output = {
        "schema": "ergodis-application-readme-ab-v3",
        "protocol": {
            "rounds": args.rounds,
            "timeout_s": args.timeout,
            "cpu": args.cpu,
            "fresh_process_per_sample": True,
            "profiles": {name: repetitions for name, repetitions in PROFILES},
            "rotated_interleave": True,
            "metric": "external wall time including implementation startup",
            "dependency_setup_excluded": True,
            "timeout_policy": "report timeout/Ergodis-median lower bound",
        },
        "host": host,
        "implementations": implementation_metadata(args.python),
        "artifacts": {
            "ergodis_sha256": sha256(args.ergodis),
            "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
            "benchmark_python_sha256": sha256(BENCHMARK_PYTHON),
            "runner_sha256": sha256(Path(__file__).resolve()),
            "checker_sha256": sha256(ROOT / "python/check_application_readme_ab.py"),
            "raw_jsonl_sha256": sha256(args.raw_jsonl),
        },
        "cases": summaries,
        "completed_case_aggregates": {
            profile: {
                "geometric_mean_speedup": (
                    math.exp(statistics.mean(logs)) if logs else None
                ),
                "log_ratio_t_score": t_score(logs),
            }
            for profile, logs in suite_logs.items()
        },
    }
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
