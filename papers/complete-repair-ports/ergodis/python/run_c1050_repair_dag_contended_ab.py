#!/usr/bin/env python3
"""C1050 diagnostic row: contended repair DAG, ergodis against CP-SAT intervals.

Same paired protocol as the published application table: fresh process per
sample, rotated A/B order, both sides pinned to one CPU under `choom -n 1000`,
model construction and interpreter startup inside the timed region, process
high-water RSS recorded, medians of unrounded samples. Cold runs one solve per
process; warm-batch runs eight on both sides and normalizes per solve.

Exact agreement of the optimal makespan is required for every sample.
"""

from __future__ import annotations

import argparse
import json
import statistics
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "python"))

from run_satcomp24_portfolio import host_metadata, sha256  # noqa: E402

CONTROL = ROOT / "python" / "c1050_repair_dag_contended_control.py"
PROFILES = (("cold", 1), ("warm_batch", 8))
CELL_TIMEOUT_S = 600.0


def sample(command: list[str], repetitions: int, cpu: int) -> dict[str, object]:
    wrapped = [
        "/usr/bin/time",
        "-f",
        "C1050RUSAGE %M",
        "choom",
        "-n",
        "1000",
        "--",
        "taskset",
        "-c",
        str(cpu),
        *command,
    ]
    start = time.perf_counter_ns()
    process = subprocess.run(
        wrapped, capture_output=True, text=True, timeout=CELL_TIMEOUT_S
    )
    external_ns = time.perf_counter_ns() - start
    if process.returncode != 0:
        raise RuntimeError(f"{command[0]}: {process.stderr[-400:]}")
    peak_rss_kb = None
    for line in process.stderr.splitlines():
        if line.startswith("C1050RUSAGE "):
            peak_rss_kb = int(line.split()[1])
    payload = json.loads(process.stdout)
    return {
        "external_ns_per_solve": external_ns / repetitions,
        "internal_ns_per_solve": payload["elapsed_ns"] / repetitions,
        "peak_rss_kb": peak_rss_kb,
        "work": payload["work"],
        "checksum": payload["checksum"] / repetitions,
    }


def median(records: list[dict[str, object]], field: str) -> float:
    return statistics.median(float(record[field]) for record in records)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--python", type=Path, required=True)
    parser.add_argument("--width", type=int, default=12)
    parser.add_argument("--layers", type=int, default=3)
    parser.add_argument("--capacity", type=int, default=3)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--cpu", type=int, default=3)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    shape = [str(args.width), str(args.layers), str(args.capacity)]
    profiles: dict[str, object] = {}
    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for profile_index, (profile, repetitions) in enumerate(PROFILES):
            samples: dict[str, list[dict[str, object]]] = {"ergodis": [], "control": []}
            for round_index in range(args.rounds):
                order = ("ergodis", "control")
                if (profile_index + round_index) & 1:
                    order = tuple(reversed(order))
                for side in order:
                    command = (
                        [str(args.ergodis), *shape, str(repetitions)]
                        if side == "ergodis"
                        else [str(args.python), str(CONTROL), *shape, str(repetitions)]
                    )
                    record = sample(command, repetitions, args.cpu)
                    record.update({"profile": profile, "round": round_index, "side": side})
                    raw.write(json.dumps(record, sort_keys=True) + "\n")
                    samples[side].append(record)
            makespans = {r["checksum"] for side in samples.values() for r in side}
            if len(makespans) != 1:
                raise RuntimeError(f"exact disagreement on the optimum: {makespans}")
            profiles[profile] = {
                "repetitions": repetitions,
                "rounds": args.rounds,
                "optimal_makespan": makespans.pop(),
                "ergodis_median_ns_per_solve": median(
                    samples["ergodis"], "external_ns_per_solve"
                ),
                "control_median_ns_per_solve": median(
                    samples["control"], "external_ns_per_solve"
                ),
                "ergodis_median_peak_rss_kb": median(samples["ergodis"], "peak_rss_kb"),
                "control_median_peak_rss_kb": median(samples["control"], "peak_rss_kb"),
                "ergodis_states_examined": median(samples["ergodis"], "work"),
                "speedup": (
                    median(samples["control"], "external_ns_per_solve")
                    / median(samples["ergodis"], "external_ns_per_solve")
                ),
            }

    value = {
        "task": "C1050",
        "row": "repair DAG, contended",
        "predeclared": (
            "ready sets do not fit, so the subset descent runs on every popped "
            "state; predicted states_examined far above the published row's four, "
            "makespan above the layer count, and an ergodis win visibly smaller "
            "than the published row's 167x"
        ),
        "instance": {
            "width": args.width,
            "layers": args.layers,
            "capacity": args.capacity,
            "resource_dimensions": 2,
        },
        "host": host_metadata(args.cpu),
        "protocol": (
            "fresh process per sample; rotated paired A/B order; both sides pinned "
            "to one CPU under choom -n 1000; model construction and interpreter "
            "startup inside the timed region; process high-water RSS recorded; "
            "medians of unrounded samples"
        ),
        "ergodis": {"path": str(args.ergodis), "sha256": sha256(args.ergodis)},
        "control": {
            "name": "OR-Tools 9.14 CP-SAT cumulative intervals, one worker",
            "source": str(CONTROL),
            "sha256": sha256(CONTROL),
        },
        "profiles": profiles,
    }
    args.output.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")

    for profile, entry in profiles.items():
        print(
            f"{profile:<11} ergodis {entry['ergodis_median_ns_per_solve'] / 1e6:>9.3f} ms  "
            f"control {entry['control_median_ns_per_solve'] / 1e6:>9.3f} ms  "
            f"{entry['speedup']:>7.2f}x  "
            f"RSS {entry['ergodis_median_peak_rss_kb'] / 1024:>6.1f} / "
            f"{entry['control_median_peak_rss_kb'] / 1024:>6.1f} MiB  "
            f"states {entry['ergodis_states_examined']:>8.0f}  "
            f"makespan {entry['optimal_makespan']:.0f}"
        )


if __name__ == "__main__":
    main()
