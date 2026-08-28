#!/usr/bin/env python3
"""Run ergodis and MATA on the official TACAS'24 Presburger corpus."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
import subprocess
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def run(command: list[str], timeout: float) -> str:
    return subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
    ).stdout.strip()


def parse_bench(output: str) -> tuple[int, int]:
    fields = output.split("\t")
    if len(fields) < 3:
        raise ValueError(f"malformed benchmark output: {output!r}")
    return int(fields[-2]), int(fields[-1])


def paired_stats(left: list[int], right: list[int]) -> tuple[float, float]:
    logs = [math.log(a / b) for a, b in zip(left, right, strict=True)]
    mean = statistics.fmean(logs)
    if len(logs) == 1:
        return math.exp(mean), math.inf
    return math.exp(mean), mean / math.sqrt(statistics.variance(logs) / len(logs))


def parse_prepare(output: str) -> dict[str, int]:
    fields = output.split("\t")
    if len(fields) != 5 or fields[0] != "prepared":
        raise ValueError(f"malformed preparation output: {output!r}")
    return {
        "nfa_states": int(fields[1]),
        "nfa_transitions": int(fields[2]),
        "dfa_states": int(fields[3]),
        "dfa_transitions": int(fields[4]),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-list", type=Path, required=True)
    parser.add_argument("--nfa-bench-root", type=Path, required=True)
    parser.add_argument("--mata-driver", type=Path, required=True)
    parser.add_argument("--ergodis-driver", type=Path, required=True)
    parser.add_argument("--mata-revision", required=True)
    parser.add_argument("--nfa-bench-revision", required=True)
    parser.add_argument("--comparison-revision", required=True)
    parser.add_argument("--work-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=15)
    parser.add_argument("--target-ns", type=int, default=20_000_000)
    parser.add_argument("--maximum-repetitions", type=int, default=10_000)
    parser.add_argument("--prepare-timeout", type=float, default=30.0)
    parser.add_argument("--bench-timeout", type=float, default=30.0)
    parser.add_argument("--maximum-instances", type=int)
    args = parser.parse_args()
    if args.rounds < 3 or args.target_ns <= 0 or args.maximum_repetitions <= 0:
        raise SystemExit("invalid measurement parameters")

    args.work_dir.mkdir(parents=True, exist_ok=True)
    raw_inputs = [line.strip() for line in args.input_list.read_text().splitlines() if line.strip()]
    if args.maximum_instances is not None:
        raw_inputs = raw_inputs[: args.maximum_instances]
    records: list[dict[str, object]] = []
    skipped: list[dict[str, object]] = []
    for index, relative in enumerate(raw_inputs):
        marker = "./nfa-bench/"
        if not relative.startswith(marker):
            raise SystemExit(f"unexpected official input path: {relative}")
        source = args.nfa_bench_root / relative.removeprefix(marker)
        derived = args.work_dir / f"{index:03}-{source.stem}.dfa.mata"
        try:
            preparation = parse_prepare(
                run(
                    [str(args.mata_driver), "prepare", str(source), str(derived)],
                    args.prepare_timeout,
                )
            )
            mata_probe, mata_classes = parse_bench(
                run([str(args.mata_driver), "bench", str(derived), "1"], args.bench_timeout)
            )
            ergodis_probe, ergodis_classes = parse_bench(
                run([str(args.ergodis_driver), str(derived), "1"], args.bench_timeout)
            )
            repetitions = min(
                args.maximum_repetitions,
                max(1, math.ceil(args.target_ns / min(mata_probe, ergodis_probe))),
            )
            mata_ns: list[int] = []
            ergodis_ns: list[int] = []
            for round_index in range(args.rounds):
                commands = [
                    ("mata", [str(args.mata_driver), "bench", str(derived), str(repetitions)]),
                    ("ergodis", [str(args.ergodis_driver), str(derived), str(repetitions)]),
                ]
                if round_index & 1:
                    commands.reverse()
                measured: dict[str, int] = {}
                measured_classes: dict[str, int] = {}
                for name, command in commands:
                    elapsed, classes = parse_bench(run(command, args.bench_timeout))
                    measured[name] = elapsed
                    measured_classes[name] = classes
                if measured_classes != {"mata": mata_classes, "ergodis": ergodis_classes}:
                    raise ValueError("class counts changed between rounds")
                mata_ns.append(measured["mata"])
                ergodis_ns.append(measured["ergodis"])
            speedup, t_score = paired_stats(mata_ns, ergodis_ns)
            added_sink = ergodis_classes - mata_classes
            if added_sink not in (0, 1):
                raise ValueError("ergodis and MATA quotient sizes disagree")
            records.append(
                {
                    "official_index": index,
                    "input": relative,
                    "source_sha256": sha256(source),
                    "derived_sha256": sha256(derived),
                    **preparation,
                    "added_rejecting_sink_class": added_sink,
                    "mata_classes": mata_classes,
                    "ergodis_classes": ergodis_classes,
                    "repetitions": repetitions,
                    "mata_ns": mata_ns,
                    "ergodis_ns": ergodis_ns,
                    "mata_median_ns": statistics.median(mata_ns),
                    "ergodis_median_ns": statistics.median(ergodis_ns),
                    "ergodis_speedup": speedup,
                    "paired_log_t": t_score,
                }
            )
        except (subprocess.SubprocessError, ValueError, OSError) as error:
            skipped.append(
                {
                    "official_index": index,
                    "input": relative,
                    "reason": type(error).__name__,
                }
            )

    instance_logs = [math.log(float(record["ergodis_speedup"])) for record in records]
    suite_speedup = math.exp(statistics.fmean(instance_logs)) if instance_logs else math.nan
    suite_t = (
        statistics.fmean(instance_logs)
        / math.sqrt(statistics.variance(instance_logs) / len(instance_logs))
        if len(instance_logs) > 1
        else math.nan
    )
    document = {
        "schema": "ergodis-mata-official-ab-v1",
        "scope": "MATA TACAS'24 explicit Presburger-complement input list; shared determinized trimmed DFAs",
        "method": {
            "rounds": args.rounds,
            "ordering": "alternating adjacent process order",
            "timed_region": "minimization only; parsing and official-NFA determinization excluded",
            "ergodis_policy": "SplitTranscript including quotient construction and independent replay",
            "mata_algorithm": "algorithms::minimize_hopcroft",
            "target_ns": args.target_ns,
            "maximum_repetitions": args.maximum_repetitions,
        },
        "artifacts": {
            "mata_revision": args.mata_revision,
            "nfa_bench_revision": args.nfa_bench_revision,
            "comparison_revision": args.comparison_revision,
            "input_list_sha256": sha256(args.input_list),
            "mata_driver_sha256": sha256(args.mata_driver),
            "ergodis_driver_sha256": sha256(args.ergodis_driver),
        },
        "attempted_instances": len(raw_inputs),
        "measured_instances": len(records),
        "skipped_instances": skipped,
        "suite_geometric_mean_speedup": suite_speedup,
        "suite_instance_log_t": suite_t,
        "ergodis_wins": sum(float(record["ergodis_speedup"]) > 1 for record in records),
        "mata_wins": sum(float(record["ergodis_speedup"]) < 1 for record in records),
        "instances": records,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w") as output:
        json.dump(document, output, indent=2)
        output.write("\n")


if __name__ == "__main__":
    main()
