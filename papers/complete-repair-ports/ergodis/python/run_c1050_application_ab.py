#!/usr/bin/env python3
"""C1050: paired old/new A/B of the application rows across the C1038 change.

Compares the retained pre-counted-type-reduction `bench_kernels` executable
against the current one on every application variant that backs a row in
`BENCHMARKS.md`, under the documented paired-round protocol: fresh process per
sample, rotated A/B order, both sides pinned to the same CPU, `choom -n 1000`,
model construction and startup inside the timed region, process high-water RSS
recorded, medians of unrounded samples.

Only the ergodis side is measured. The external controls (Graphillion, HiGHS,
CP-SAT, CryptoMiniSat, OR-Tools max-flow) are unchanged by the kernel edit, so
re-running them would add host noise without adding evidence; a row whose
ergodis side is unchanged keeps its published ratio.
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

# (row, variant, cold repetitions, warm repetitions, stress repetitions or None)
ROWS = (
    ("ceph_recursive_xor", "application:ceph-zdd:rust:8:2", 1, 8, None),
    ("represented_gf4_tower", "transfer-tower:rust:6:4", 1, 8, None),
    ("azure_lrc_batch", "application:azure:rust:100000:100000", 1, 8, 100_000),
    ("repair_dag", "application:rdag:rust:21:3", 1, 8, 1_000),
    ("qc_ldpc_codeword", "application:qc:rust:50000:4", 1, 8, 100),
    ("vector_node_span", "application:vector:rust:64:2", 1, 8, 1_000),
    ("hamming_outer_lrc", "jin-fu-hamming:rust:6", 1, 8, None),
    ("gpu_mds_checkpoint", "application:gpu-compiled:rust:10000:6000:64", 1, 8, 100),
    # The one application variant that reaches WeightedRepairProblem's adaptive
    # entry points, and therefore the only place the counted-type reduction can
    # act: the Ceph scheduling-quotient column.
    ("ceph_scheduling_quotient_10", "application:ceph-aggregate:rust:10:2:2", 1, 8, None),
    ("ceph_scheduling_quotient_30", "application:ceph-aggregate:rust:30:2:2", 1, 8, None),
    ("ceph_scheduling_quotient_80", "application:ceph-aggregate:rust:80:2:2", 1, 8, None),
)

CELL_TIMEOUT_S = 600.0


def sample(binary: Path, variant: str, repetitions: int, cpu: int) -> dict[str, object]:
    command = [
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
        str(binary),
        variant,
        str(repetitions),
    ]
    start = time.perf_counter_ns()
    process = subprocess.run(
        command, capture_output=True, text=True, timeout=CELL_TIMEOUT_S
    )
    external_ns = time.perf_counter_ns() - start
    if process.returncode != 0:
        raise RuntimeError(f"{binary.name} {variant} {repetitions}: {process.stderr[-400:]}")
    peak_rss_kb = None
    for line in process.stderr.splitlines():
        if line.startswith("C1050RUSAGE "):
            peak_rss_kb = int(line.split()[1])
    payload = json.loads(process.stdout)
    return {
        "external_ns": external_ns,
        "external_ns_per_solve": external_ns / repetitions,
        "peak_rss_kb": peak_rss_kb,
        "internal_peak_rss_kib": payload.get("peak_rss_kib"),
        "elapsed_ns": payload.get("elapsed_ns"),
        "ns_per_solve": payload["elapsed_ns"] / repetitions,
        "work": payload.get("work"),
        "peak_states": payload.get("peak_states"),
        "checksum": payload.get("checksum"),
        "repetitions": payload.get("repetitions"),
        "variant": payload.get("variant"),
    }


def median(records: list[dict[str, object]], field: str) -> float:
    values = [float(r[field]) for r in records if r[field] is not None]
    return statistics.median(values) if values else float("nan")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--current", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--cpu", type=int, default=3)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rows", default="")
    args = parser.parse_args()

    selected = set(filter(None, args.rows.split(",")))
    rows = [row for row in ROWS if not selected or row[0] in selected]

    profiles: list[tuple[str, int]] = []
    measurements: dict[str, object] = {}
    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for row_index, (name, variant, cold, warm, stress) in enumerate(rows):
            profiles = [("cold", cold), ("warm_batch", warm)]
            if stress is not None:
                profiles.append(("stress_batch", stress))
            row_summary: dict[str, object] = {"variant": variant, "profiles": {}}
            for profile_index, (profile, repetitions) in enumerate(profiles):
                samples: dict[str, list[dict[str, object]]] = {
                    "baseline": [],
                    "current": [],
                }
                for round_index in range(args.rounds):
                    order = ("baseline", "current")
                    if (row_index + profile_index + round_index) & 1:
                        order = tuple(reversed(order))
                    for side in order:
                        binary = args.baseline if side == "baseline" else args.current
                        record = sample(binary, variant, repetitions, args.cpu)
                        record.update(
                            {
                                "row": name,
                                "profile": profile,
                                "round": round_index,
                                "side": side,
                            }
                        )
                        raw.write(json.dumps(record, sort_keys=True) + "\n")
                        samples[side].append(record)
                checksums = {r["checksum"] for side in samples.values() for r in side}
                works = {r["work"] for side in samples.values() for r in side}
                row_summary["profiles"][profile] = {
                    "repetitions": repetitions,
                    "rounds": args.rounds,
                    "exact_agreement": len(checksums) == 1,
                    "checksums": sorted(str(value) for value in checksums),
                    "work_agreement": len(works) == 1,
                    "works": sorted(str(value) for value in works),
                    "baseline": {
                        "median_ns_per_solve": median(samples["baseline"], "ns_per_solve"),
                        "median_external_ns_per_solve": median(
                            samples["baseline"], "external_ns_per_solve"
                        ),
                        "median_peak_rss_kb": median(samples["baseline"], "peak_rss_kb"),
                    },
                    "current": {
                        "median_ns_per_solve": median(samples["current"], "ns_per_solve"),
                        "median_external_ns_per_solve": median(
                            samples["current"], "external_ns_per_solve"
                        ),
                        "median_peak_rss_kb": median(samples["current"], "peak_rss_kb"),
                    },
                    "baseline_over_current": (
                        median(samples["baseline"], "ns_per_solve")
                        / median(samples["current"], "ns_per_solve")
                    ),
                }
            measurements[name] = row_summary

    value = {
        "task": "C1050",
        "host": host_metadata(args.cpu),
        "protocol": (
            "fresh process per sample; rotated paired A/B order; both sides pinned to "
            "one CPU under choom -n 1000; model construction and process startup inside "
            "the timed region; process high-water RSS recorded; medians of unrounded "
            "samples; ergodis side only"
        ),
        "binaries": {
            "baseline": {
                "path": str(args.baseline),
                "sha256": sha256(args.baseline),
            },
            "current": {"path": str(args.current), "sha256": sha256(args.current)},
        },
        "rounds": args.rounds,
        "cpu": args.cpu,
        "measurements": measurements,
    }
    args.output.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")

    print(f"{'row':<22} {'profile':<12} {'base ns/solve':>14} {'new ns/solve':>14} "
          f"{'ratio':>7} {'base RSS':>9} {'new RSS':>9} {'exact':>6} {'work':>6}")
    for name, row in measurements.items():
        for profile, entry in row["profiles"].items():
            print(
                f"{name:<22} {profile:<12} "
                f"{entry['baseline']['median_ns_per_solve']:>14.0f} "
                f"{entry['current']['median_ns_per_solve']:>14.0f} "
                f"{entry['baseline_over_current']:>7.3f} "
                f"{entry['baseline']['median_peak_rss_kb']:>9.0f} "
                f"{entry['current']['median_peak_rss_kb']:>9.0f} "
                f"{str(entry['exact_agreement']):>6} "
                f"{str(entry['work_agreement']):>6}"
            )


if __name__ == "__main__":
    main()
