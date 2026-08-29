#!/usr/bin/env python3
"""Multi-round Ergodis/Z3 weighted-trace comparison on the official corpus."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import platform
import statistics
import subprocess
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def run_json(command: list[str], timeout: float, environment: dict[str, str] | None = None) -> dict:
    completed = subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
        env=environment,
    )
    return json.loads(completed.stdout)


def parse_prepare(output: str) -> dict[str, int]:
    fields = output.strip().split("\t")
    if len(fields) != 5 or fields[0] != "prepared":
        raise ValueError(f"malformed preparation output: {output!r}")
    return {
        "nfa_states": int(fields[1]),
        "nfa_transitions": int(fields[2]),
        "dfa_states": int(fields[3]),
        "dfa_transitions": int(fields[4]),
    }


def median(values: list[int]) -> float:
    return statistics.median(values)


def log_stats(ratios: list[float]) -> tuple[float, float]:
    logs = [math.log(value) for value in ratios]
    mean = statistics.fmean(logs)
    t_score = (
        mean / math.sqrt(statistics.variance(logs) / len(logs))
        if len(logs) > 1
        else math.nan
    )
    return math.exp(mean), t_score


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-list", type=Path, required=True)
    parser.add_argument("--nfa-bench-root", type=Path, required=True)
    parser.add_argument("--mata-driver", type=Path, required=True)
    parser.add_argument("--ergodis-driver", type=Path, required=True)
    parser.add_argument("--z3-script", type=Path, required=True)
    parser.add_argument("--z3-python-path", type=Path, required=True)
    parser.add_argument("--z3-library-path", type=Path, required=True)
    parser.add_argument("--cxx-library-path", type=Path, required=True)
    parser.add_argument("--work-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--query-repetitions", type=int, default=31)
    parser.add_argument("--z3-timeout-ms", type=int, default=5_000)
    parser.add_argument("--process-timeout", type=float, default=10.0)
    parser.add_argument("--maximum-instances", type=int)
    parser.add_argument("--mata-revision", required=True)
    parser.add_argument("--nfa-bench-revision", required=True)
    parser.add_argument("--comparison-revision", required=True)
    parser.add_argument("--z3-version", required=True)
    parser.add_argument("--z3-archive-sha256", required=True)
    args = parser.parse_args()
    if args.rounds < 3 or args.query_repetitions < 1 or args.z3_timeout_ms < 1:
        raise SystemExit("invalid measurement parameters")

    raw_inputs = [line.strip() for line in args.input_list.read_text().splitlines() if line.strip()]
    if args.maximum_instances is not None:
        raw_inputs = raw_inputs[: args.maximum_instances]
    args.work_dir.mkdir(parents=True, exist_ok=True)
    environment = dict(__import__("os").environ)
    environment["PYTHONPATH"] = str(args.z3_python_path)
    environment["LD_LIBRARY_PATH"] = f"{args.z3_library_path}:{args.cxx_library_path}"

    records: list[dict[str, object]] = []
    failures: list[dict[str, object]] = []
    for index, relative in enumerate(raw_inputs):
        marker = "./nfa-bench/"
        if not relative.startswith(marker):
            raise SystemExit(f"unexpected official input path: {relative}")
        source = args.nfa_bench_root / relative.removeprefix(marker)
        derived = args.work_dir / f"{index:03}-{source.stem}.dfa.mata"
        try:
            prepared = subprocess.run(
                [str(args.mata_driver), "prepare", str(source), str(derived)],
                check=True,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=args.process_timeout,
            )
            preparation = parse_prepare(prepared.stdout)
            ergodis_rounds: list[dict] = []
            z3_rounds: list[dict] = []
            terminal_status = "optimal"
            for round_index in range(args.rounds):
                commands = ["ergodis", "z3"]
                if round_index & 1:
                    commands.reverse()
                measured: dict[str, dict] = {}
                for name in commands:
                    if name == "ergodis":
                        measured[name] = run_json(
                            [
                                str(args.ergodis_driver),
                                str(derived),
                                str(args.query_repetitions),
                            ],
                            args.process_timeout,
                        )
                    else:
                        measured[name] = run_json(
                            [
                                "python3",
                                str(args.z3_script),
                                str(derived),
                                "--timeout-ms",
                                str(args.z3_timeout_ms),
                            ],
                            args.process_timeout,
                            environment,
                        )
                ergodis = measured["ergodis"]
                z3_result = measured["z3"]
                if ergodis["status"] != "optimal":
                    raise ValueError("Ergodis failed to return an optimum")
                if z3_result["status"] != "optimal":
                    terminal_status = str(z3_result["status"])
                    z3_rounds.append(z3_result)
                    break
                if ergodis["optimum"] != z3_result["oracle_optimum"]:
                    raise ValueError("Ergodis disagrees with independent Dijkstra oracle")
                if z3_result["optimum"] != ergodis["optimum"]:
                    raise ValueError("Z3 and Ergodis optima disagree")
                ergodis_rounds.append(ergodis)
                z3_rounds.append(z3_result)

            record: dict[str, object] = {
                "official_index": index,
                "input": relative,
                "source_sha256": sha256(source),
                "derived_sha256": sha256(derived),
                **preparation,
                "status": terminal_status,
                "ergodis_rounds": ergodis_rounds,
                "z3_rounds": z3_rounds,
            }
            if terminal_status == "optimal" and len(z3_rounds) == args.rounds:
                ergodis_total = [
                    int(item["compile_ns"]) + int(item["plan_ns"]) + int(item["query_ns"])
                    for item in ergodis_rounds
                ]
                z3_total = [int(item["build_ns"]) + int(item["solve_ns"]) for item in z3_rounds]
                query_ratios = [
                    int(z3_item["solve_ns"]) / int(ergodis_item["query_ns"])
                    for ergodis_item, z3_item in zip(ergodis_rounds, z3_rounds, strict=True)
                ]
                total_ratios = [
                    z3_time / ergodis_time
                    for ergodis_time, z3_time in zip(ergodis_total, z3_total, strict=True)
                ]
                total_speedup, total_t = log_stats(total_ratios)
                query_speedup, query_t = log_stats(query_ratios)
                record.update(
                    ergodis_total_median_ns=median(ergodis_total),
                    z3_total_median_ns=median(z3_total),
                    total_speedup=total_speedup,
                    total_paired_log_t=total_t,
                    query_speedup=query_speedup,
                    query_paired_log_t=query_t,
                )
            records.append(record)
        except subprocess.TimeoutExpired:
            failures.append({"official_index": index, "input": relative, "status": "process_timeout"})
        except (subprocess.SubprocessError, ValueError, OSError, json.JSONDecodeError) as error:
            failures.append(
                {
                    "official_index": index,
                    "input": relative,
                    "status": "error",
                    "reason": type(error).__name__,
                }
            )

    paired = [record for record in records if "total_speedup" in record]
    suite_total, suite_total_t = log_stats([float(record["total_speedup"]) for record in paired])
    suite_query, suite_query_t = log_stats([float(record["query_speedup"]) for record in paired])
    document = {
        "schema": "ergodis-z3-weighted-trace-suite-v1",
        "scope": "MATA TACAS'24 Presburger-complement explicit corpus; minimum positive-cost accepted trace",
        "cost": "1 + HammingWeight(bit-vector alphabet symbol)",
        "method": {
            "rounds": args.rounds,
            "ordering": "alternating adjacent process order",
            "query_repetitions": args.query_repetitions,
            "z3_timeout_ms": args.z3_timeout_ms,
            "timed_regions": {
                "ergodis_total": "SplitTranscript compile + weighted-plan compile + one query",
                "ergodis_query": "one fixed-plan Dijkstra query",
                "z3_total": "Boolean unit-flow model construction + Optimize solve",
                "z3_query": "Optimize solve on a constructed model",
            },
            "validation": "independent Python Dijkstra oracle plus concrete Ergodis witness replay",
        },
        "host": {"platform": platform.platform(), "processor": platform.processor()},
        "artifacts": {
            "mata_revision": args.mata_revision,
            "nfa_bench_revision": args.nfa_bench_revision,
            "comparison_revision": args.comparison_revision,
            "z3_version": args.z3_version,
            "z3_archive_sha256": args.z3_archive_sha256,
            "input_list_sha256": sha256(args.input_list),
            "mata_driver_sha256": sha256(args.mata_driver),
            "ergodis_driver_sha256": sha256(args.ergodis_driver),
            "z3_script_sha256": sha256(args.z3_script),
        },
        "attempted_instances": len(raw_inputs),
        "recorded_instances": len(records),
        "paired_optimal_instances": len(paired),
        "failures": failures,
        "suite_total_geometric_mean_speedup": suite_total,
        "suite_total_instance_log_t": suite_total_t,
        "suite_query_geometric_mean_speedup": suite_query,
        "suite_query_instance_log_t": suite_query_t,
        "ergodis_total_wins": sum(float(record["total_speedup"]) > 1 for record in paired),
        "z3_total_wins": sum(float(record["total_speedup"]) < 1 for record in paired),
        "instances": records,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
