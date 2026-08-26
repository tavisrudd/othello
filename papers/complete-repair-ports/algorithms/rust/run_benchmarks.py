#!/usr/bin/env python3
"""Run rotated interleaved release benchmarks."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import platform
import statistics
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "evidence" / "benchmarks.json"
BINARY = Path(
    os.environ.get("ERGO_BENCH_BINARY", ROOT / "target" / "release" / "bench_kernels")
)


def command(variant: str, repetitions: int) -> list[str]:
    if "cpsat" in variant:
        return [
            "taskset",
            "-c",
            "2",
            "nix",
            "shell",
            "nixpkgs#uv",
            "--command",
            "uv",
            "run",
            "--no-project",
            "--with",
            "ortools==9.14.6206",
            "python3",
            str(ROOT / "benchmark_python.py"),
            variant,
            str(repetitions),
        ]
    if variant.endswith("-python"):
        return [
            "taskset",
            "-c",
            "2",
            "nix",
            "shell",
            "nixpkgs#python3",
            "--command",
            "python3",
            str(ROOT / "benchmark_python.py"),
            variant,
            str(repetitions),
        ]
    return ["taskset", "-c", "2", str(BINARY), variant, str(repetitions)]


def run_group(variants: tuple[str, ...], repetitions: int, rounds: int):
    samples = {variant: [] for variant in variants}
    for round_index in range(rounds):
        rotated = variants[round_index % len(variants) :] + variants[: round_index % len(variants)]
        for variant in rotated:
            completed = subprocess.run(
                command(variant, repetitions),
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            )
            sample = json.loads(completed.stdout)
            if sample["variant"] != variant:
                raise RuntimeError("benchmark variant mismatch")
            samples[variant].append(sample)
    summaries = {}
    for variant, values in samples.items():
        summaries[variant] = {
            "median_ns_per_solve": statistics.median(
                value["elapsed_ns"] / value["repetitions"] for value in values
            ),
            "median_peak_rss_kib": statistics.median(
                value["peak_rss_kib"] for value in values
            ),
            "work_per_solve": values[0]["work"] // values[0]["repetitions"],
            "peak_states": values[0]["peak_states"],
            "checksum_per_solve": values[0]["checksum"] // values[0]["repetitions"],
            "samples": values,
        }
    return summaries


def run_binary_ab(
    variant: str, repetitions: int, rounds: int, baseline: Path, candidate: Path
):
    binaries = (("baseline", baseline), ("candidate", candidate))
    samples = {label: [] for label, _ in binaries}
    for round_index in range(rounds):
        rotated = binaries[round_index % 2 :] + binaries[: round_index % 2]
        for label, binary in rotated:
            completed = subprocess.run(
                ["taskset", "-c", "2", str(binary), variant, str(repetitions)],
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            )
            sample = json.loads(completed.stdout)
            if sample["variant"] != variant:
                raise RuntimeError("binary A/B variant mismatch")
            samples[label].append(sample)
    return {
        label: {
            "median_ns_per_solve": statistics.median(
                value["elapsed_ns"] / value["repetitions"] for value in values
            ),
            "median_peak_rss_kib": statistics.median(
                value["peak_rss_kib"] for value in values
            ),
            "work_per_solve": values[0]["work"] // values[0]["repetitions"],
            "peak_states": values[0]["peak_states"],
            "checksum_per_solve": values[0]["checksum"] // values[0]["repetitions"],
            "samples": values,
        }
        for label, values in samples.items()
    }


def ratio(numerator: float, denominator: float) -> float:
    return round(numerator / denominator, 3)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--ab-rounds", type=int, default=11)
    parser.add_argument("--competitors-only", action="store_true")
    parser.add_argument("--tuning-only", action="store_true")
    parser.add_argument("--scheduler-tuning-only", action="store_true")
    parser.add_argument("--phase-only", action="store_true")
    parser.add_argument("--phase-rounds", type=int, default=5)
    parser.add_argument("--nonuniform-phase-only", action="store_true")
    parser.add_argument("--workspace-only", action="store_true")
    parser.add_argument("--locality-only", action="store_true")
    parser.add_argument("--structured-cpsat-only", action="store_true")
    parser.add_argument("--transfer-only", action="store_true")
    parser.add_argument("--baseline-binary", type=Path)
    parser.add_argument("--candidate-binary", type=Path, default=BINARY)
    parser.add_argument("--locality-key", default="scheduler_locality_ab")
    args = parser.parse_args()
    if not args.write:
        raise SystemExit("pass --write to record a fresh noncanonical benchmark")
    if not BINARY.exists():
        raise SystemExit("build target/release/bench_kernels first")

    if args.transfer_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --transfer-only")
        value = json.loads(OUTPUT.read_text())
        profiles = {}
        for name, depth, fanout, profile_rounds in (
            ("two-by-two", 2, 2, args.ab_rounds),
            ("three-by-three", 3, 3, args.ab_rounds),
            ("four-by-three", 4, 3, args.ab_rounds),
            ("five-by-four", 5, 4, min(args.ab_rounds, 7)),
        ):
            variants = (
                f"transfer-tower:rust:{depth}:{fanout}",
                f"transfer-tower:cpsat-direct:{depth}:{fanout}",
                f"transfer-tower:cpsat:{depth}:{fanout}",
            )
            measured = run_group(variants, 1, profile_rounds)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"transfer CP-SAT checksum mismatch: {variants}")
            profiles[name] = {
                "depth": depth,
                "fanout": fanout,
                "leaf_blocks": fanout**depth,
                "rounds": profile_rounds,
                "rust_speedup_over_direct_cpsat": ratio(
                    measured[variants[1]]["median_ns_per_solve"],
                    measured[variants[0]]["median_ns_per_solve"],
                ),
                "rust_speedup_over_structured_cpsat": ratio(
                    measured[variants[2]]["median_ns_per_solve"],
                    measured[variants[0]]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["transfer_tower_cpsat"] = {
            "rounds": args.ab_rounds,
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": {
                "common": "rotated interleave; deterministic single worker; one end-to-end solve",
                "rust": "compile exact GF(4) labelled tables and tower; expand canonical witness",
                "direct_cpsat": "binary coefficient variables; row-support objective; GF(4) parity constraints",
                "structured_cpsat": "same exact labelled tables; one-hot leaf choices; GF(4) parity constraints",
            },
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.structured_cpsat_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --structured-cpsat-only")
        value = json.loads(OUTPUT.read_text())
        cases = {
            "shell-large-box": (4, 4_096, 8, 4, 0xA17E5EED, 100),
            "balanced": (6, 3, 11, 4, 0xA17E5EED, 50),
            "small-state": (4, 2, 80, 4, 0xA17E5EED, 50),
            "large-nonuniform": (8, 4, 8, 4, 1, 50),
        }
        profiles = {}
        for name, (resources, capacity, demands, options, seed, repetitions) in cases.items():
            prefix = (
                f"scheduler-graded-grid:{{}}:{resources}:{capacity}:"
                f"{demands}:{options}:{seed}"
            )
            variants = (
                prefix.format("graded-dense-workspace"),
                prefix.format("cpsat"),
                prefix.format("cpsat-structured"),
            )
            measured = run_group(variants, repetitions, args.ab_rounds)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"structured CP-SAT checksum mismatch: {variants}")
            profiles[name] = {
                "rust_speedup_over_raw_cpsat": ratio(
                    measured[variants[1]]["median_ns_per_solve"],
                    measured[variants[0]]["median_ns_per_solve"],
                ),
                "rust_speedup_over_structured_cpsat": ratio(
                    measured[variants[2]]["median_ns_per_solve"],
                    measured[variants[0]]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["scheduler_structured_cpsat"] = {
            "rounds": args.ab_rounds,
            "protocol": {
                "common": "rotated interleave; deterministic single worker; reused model",
                "raw_cpsat": "raw generated options; fresh solver object per solve",
                "structured_cpsat": (
                    "canonical feasible Pareto-minimal options; exact grading repair bound; "
                    "reusable solver object"
                ),
                "rust": "canonical options; certified grading; reusable allocation workspace",
            },
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.locality_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --locality-only")
        if args.baseline_binary is None or not args.baseline_binary.exists():
            raise SystemExit("--locality-only requires an existing --baseline-binary")
        if not args.candidate_binary.exists():
            raise SystemExit("--candidate-binary does not exist")
        value = json.loads(OUTPUT.read_text())
        cases = {
            "balanced": (6, 3, 11, 4, 0xA17E5EED, 100),
            "small-state": (4, 2, 80, 4, 0xA17E5EED, 100),
            "large-nonuniform": (8, 4, 8, 4, 1, 50),
        }
        profiles = {}
        for name, (resources, capacity, demands, options, seed, repetitions) in cases.items():
            variant = (
                f"scheduler-graded-grid:graded-adaptive-workspace:{resources}:"
                f"{capacity}:{demands}:{options}:{seed}"
            )
            measured = run_binary_ab(
                variant,
                repetitions,
                args.ab_rounds,
                args.baseline_binary,
                args.candidate_binary,
            )
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"locality checksum mismatch: {variant}")
            if len({entry["work_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"locality work mismatch: {variant}")
            profiles[name] = {
                "speedup": ratio(
                    measured["baseline"]["median_ns_per_solve"],
                    measured["candidate"]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value[args.locality_key] = {
            "rounds": args.ab_rounds,
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.workspace_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --workspace-only")
        value = json.loads(OUTPUT.read_text())
        cases = {
            "balanced": (6, 3, 11, 4, 0xA17E5EED, 100),
            "small-state": (4, 2, 80, 4, 0xA17E5EED, 100),
            "large-nonuniform": (8, 4, 8, 4, 1, 50),
        }
        profiles = {}
        for name, (resources, capacity, demands, options, seed, repetitions) in cases.items():
            prefix = (
                f"scheduler-graded-grid:{{}}:{resources}:{capacity}:"
                f"{demands}:{options}:{seed}"
            )
            variants = (
                prefix.format("graded-adaptive"),
                prefix.format("graded-adaptive-workspace"),
            )
            measured = run_group(variants, repetitions, args.ab_rounds)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"workspace checksum mismatch: {variants}")
            if len({entry["work_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"workspace work mismatch: {variants}")
            profiles[name] = {
                "speedup": ratio(
                    measured[variants[0]]["median_ns_per_solve"],
                    measured[variants[1]]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["scheduler_workspace"] = {
            "rounds": args.ab_rounds,
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.nonuniform_phase_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --nonuniform-phase-only")
        value = json.loads(OUTPUT.read_text())
        shapes = (
            (4, 4, 4),
            (4, 4, 10),
            (4, 4, 30),
            (6, 4, 4),
            (6, 4, 7),
            (6, 4, 11),
            (8, 4, 4),
            (8, 4, 6),
            (8, 4, 8),
        )
        profiles = []
        certificate_speedups = []
        cpsat_speedups = []
        planner_correct = 0
        for resources, capacity, demands in shapes:
            for seed in (1, 0xA17E5EED):
                repetitions = 3 if resources == 8 and demands == 8 else 10
                prefix = (
                    f"scheduler-graded-grid:{{}}:{resources}:{capacity}:"
                    f"{demands}:4:{seed}"
                )
                backends = (
                    "graded-flat",
                    "graded-dense",
                    "adaptive",
                    "graded-adaptive",
                    "cpsat",
                )
                variants = tuple(prefix.format(backend) for backend in backends)
                measured = run_group(variants, repetitions, args.phase_rounds)
                checksums = {
                    summary["checksum_per_solve"] for summary in measured.values()
                }
                if len(checksums) != 1:
                    raise RuntimeError(f"nonuniform phase checksum mismatch: {variants}")
                rust_work = {
                    measured[prefix.format(backend)]["work_per_solve"]
                    for backend in backends[:-1]
                }
                if len(rust_work) != 1:
                    raise RuntimeError(f"nonuniform phase work mismatch: {variants}")
                flat_ns = measured[prefix.format("graded-flat")]["median_ns_per_solve"]
                dense_ns = measured[prefix.format("graded-dense")]["median_ns_per_solve"]
                adaptive_ns = measured[prefix.format("adaptive")]["median_ns_per_solve"]
                graded_ns = measured[prefix.format("graded-adaptive")][
                    "median_ns_per_solve"
                ]
                cpsat_ns = measured[prefix.format("cpsat")]["median_ns_per_solve"]
                predicted_dense = measured[prefix.format("graded-adaptive")]["samples"][0][
                    "planner_dense"
                ]
                winner_dense = dense_ns < flat_ns
                planner_correct += predicted_dense == winner_dense
                certificate_speedups.append(adaptive_ns / graded_ns)
                cpsat_speedups.append(cpsat_ns / graded_ns)
                profiles.append(
                    {
                        "resources": resources,
                        "capacity": capacity,
                        "demands": demands,
                        "options": 4,
                        "seed": seed,
                        "state_space": (capacity + 1) ** resources,
                        "repetitions": repetitions,
                        "grading_weights": [
                            1 if resource % 2 == 0 else 2
                            for resource in range(resources)
                        ],
                        "option_mass": 4,
                        "predicted_dense": predicted_dense,
                        "winner_dense": winner_dense,
                        "certificate_speedup": round(adaptive_ns / graded_ns, 3),
                        "graded_speedup_over_cpsat": round(cpsat_ns / graded_ns, 3),
                        "measurements": measured,
                    }
                )
        value["scheduler_nonuniform_phase"] = {
            "rounds": args.phase_rounds,
            "profiles": profiles,
            "planner_correct": planner_correct,
            "planner_total": len(profiles),
            "median_certificate_speedup": round(
                statistics.median(certificate_speedups), 3
            ),
            "max_certificate_speedup": round(max(certificate_speedups), 3),
            "rust_beats_cpsat": sum(speedup > 1 for speedup in cpsat_speedups),
            "median_graded_speedup_over_cpsat": round(
                statistics.median(cpsat_speedups), 3
            ),
            "min_graded_speedup_over_cpsat": round(min(cpsat_speedups), 3),
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.phase_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --phase-only")
        value = json.loads(OUTPUT.read_text())
        shapes = (
            (4, 2, 4),
            (4, 2, 12),
            (4, 2, 40),
            (6, 3, 3),
            (6, 3, 4),
            (6, 3, 7),
            (6, 3, 11),
            (8, 3, 4),
            (8, 3, 5),
            (8, 3, 7),
            (10, 3, 4),
            (10, 3, 5),
            (10, 3, 6),
        )
        profiles = []
        regrets = []
        correct = 0
        for resources, capacity, demands in shapes:
            for seed in (1, 0xA17E5EED):
                state_space = (capacity + 1) ** resources
                repetitions = 10
                prefix = f"scheduler-grid:{{}}:{resources}:{capacity}:{demands}:4:{seed}"
                variants = tuple(
                    prefix.format(backend)
                    for backend in ("flat", "dense", "adaptive", "cpsat")
                )
                measured = run_group(variants, repetitions, args.phase_rounds)
                checksums = {
                    summary["checksum_per_solve"] for summary in measured.values()
                }
                if len(checksums) != 1:
                    raise RuntimeError(f"phase checksum mismatch: {variants}")
                rust_work = {
                    measured[prefix.format(backend)]["work_per_solve"]
                    for backend in ("flat", "dense", "adaptive")
                }
                if len(rust_work) != 1:
                    raise RuntimeError(f"phase work mismatch: {variants}")
                flat_ns = measured[prefix.format("flat")]["median_ns_per_solve"]
                dense_ns = measured[prefix.format("dense")]["median_ns_per_solve"]
                adaptive_ns = measured[prefix.format("adaptive")]["median_ns_per_solve"]
                predicted_dense = measured[prefix.format("adaptive")]["samples"][0][
                    "planner_dense"
                ]
                winner_dense = dense_ns < flat_ns
                correct += predicted_dense == winner_dense
                regret = adaptive_ns / min(flat_ns, dense_ns)
                regrets.append(regret)
                profiles.append(
                    {
                        "resources": resources,
                        "capacity": capacity,
                        "demands": demands,
                        "options": 4,
                        "seed": seed,
                        "state_space": state_space,
                        "repetitions": repetitions,
                        "predicted_dense": predicted_dense,
                        "winner_dense": winner_dense,
                        "adaptive_regret": round(regret, 3),
                        "measurements": measured,
                    }
                )
        value["scheduler_phase"] = {
            "rounds": args.phase_rounds,
            "profiles": profiles,
            "planner_correct": correct,
            "planner_total": len(profiles),
            "median_adaptive_regret": round(statistics.median(regrets), 3),
            "max_adaptive_regret": round(max(regrets), 3),
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.tuning_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --tuning-only")
        value = json.loads(OUTPUT.read_text())
        meet_preallocation = run_group(
            ("orbit-meet-unreserved", "orbit-meet"), 1000, args.ab_rounds
        )
        split_balance = run_group(
            ("orbit-split-count", "orbit-split-balanced"), 1000, args.ab_rounds
        )
        value["orbit_meet_preallocation"] = meet_preallocation
        value["orbit_split_balance"] = split_balance
        value["comparisons"]["orbit_meet_preallocation_speedup"] = ratio(
            meet_preallocation["orbit-meet-unreserved"]["median_ns_per_solve"],
            meet_preallocation["orbit-meet"]["median_ns_per_solve"],
        )
        value["comparisons"]["orbit_product_split_speedup"] = ratio(
            split_balance["orbit-split-count"]["median_ns_per_solve"],
            split_balance["orbit-split-balanced"]["median_ns_per_solve"],
        )
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.scheduler_tuning_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --scheduler-tuning-only")
        value = json.loads(OUTPUT.read_text())
        balanced = run_group(
            (
                "scheduler-cpsat",
                "scheduler-flat",
                "scheduler-dense-unpacked",
                "scheduler-dense-wide",
                "scheduler-dense",
            ),
            10,
            args.ab_rounds,
        )
        small = run_group(
            ("scheduler-cpsat-small", "scheduler-flat-small", "scheduler-dense-small"),
            20,
            args.ab_rounds,
        )
        value["scheduler_dense_balanced"] = balanced
        value["scheduler_dense_small_state"] = small
        value["comparisons"].update(
            {
                "scheduler_dense_speedup_over_flat_balanced": ratio(
                    balanced["scheduler-flat"]["median_ns_per_solve"],
                    balanced["scheduler-dense"]["median_ns_per_solve"],
                ),
                "scheduler_dense_packing_speedup_balanced": ratio(
                    balanced["scheduler-dense-unpacked"]["median_ns_per_solve"],
                    balanced["scheduler-dense"]["median_ns_per_solve"],
                ),
                "scheduler_dense_u64_speedup_over_u128_balanced": ratio(
                    balanced["scheduler-dense-wide"]["median_ns_per_solve"],
                    balanced["scheduler-dense"]["median_ns_per_solve"],
                ),
                "scheduler_dense_speedup_over_cpsat_balanced": ratio(
                    balanced["scheduler-cpsat"]["median_ns_per_solve"],
                    balanced["scheduler-dense"]["median_ns_per_solve"],
                ),
                "scheduler_dense_speedup_over_flat_small_state": ratio(
                    small["scheduler-flat-small"]["median_ns_per_solve"],
                    small["scheduler-dense-small"]["median_ns_per_solve"],
                ),
                "scheduler_dense_speedup_over_cpsat_small_state": ratio(
                    small["scheduler-cpsat-small"]["median_ns_per_solve"],
                    small["scheduler-dense-small"]["median_ns_per_solve"],
                ),
            }
        )
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.competitors_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --competitors-only")
        value = json.loads(OUTPUT.read_text())
        scheduler = value["scheduler"]
        orbit = value["orbit"]
        scheduler_ab = value["scheduler_rust_ab"]
        orbit_ab = value["orbit_rust_ab"]
    else:
        scheduler = run_group(
        ("scheduler-python", "scheduler-flat", "scheduler-mixed"), 1, args.rounds
        )
        orbit = run_group(
            ("orbit-python", "orbit-coordinate", "orbit-correlated"), 20, args.rounds
        )
        scheduler_ab = run_group(
            ("scheduler-flat", "scheduler-mixed"), 20, args.ab_rounds
        )
        orbit_ab = run_group(
            ("orbit-coordinate", "orbit-correlated"), 100, args.ab_rounds
        )
        value = {
        "schema": "ergo-comp-rust-benchmark-v1",
        "noncanonical": True,
        "method": {
            "rounds": args.rounds,
            "rust_ab_rounds": args.ab_rounds,
            "ordering": "rotated interleaving",
            "cpu_affinity": 2,
            "timing": "in-process monotonic elapsed time including input compilation",
            "memory": "process VmHWM/resource ru_maxrss",
            "machine": platform.uname()._asdict(),
        },
        "scheduler": scheduler,
        "orbit": orbit,
        "scheduler_rust_ab": scheduler_ab,
        "orbit_rust_ab": orbit_ab,
        "comparisons": {
            "scheduler_flat_speedup_over_python": ratio(
                scheduler["scheduler-python"]["median_ns_per_solve"],
                scheduler["scheduler-flat"]["median_ns_per_solve"],
            ),
            "scheduler_mixed_speedup_over_python": ratio(
                scheduler["scheduler-python"]["median_ns_per_solve"],
                scheduler["scheduler-mixed"]["median_ns_per_solve"],
            ),
            "scheduler_mixed_speedup_over_flat": ratio(
                scheduler_ab["scheduler-flat"]["median_ns_per_solve"],
                scheduler_ab["scheduler-mixed"]["median_ns_per_solve"],
            ),
            "orbit_coordinate_speedup_over_python": ratio(
                orbit["orbit-python"]["median_ns_per_solve"],
                orbit["orbit-coordinate"]["median_ns_per_solve"],
            ),
            "orbit_correlated_speedup_over_coordinate": ratio(
                orbit_ab["orbit-coordinate"]["median_ns_per_solve"],
                orbit_ab["orbit-correlated"]["median_ns_per_solve"],
            ),
        },
        }
    cpsat_balanced = run_group(
        ("scheduler-cpsat", "scheduler-flat"), 10, args.ab_rounds
    )
    cpsat_small = run_group(
        ("scheduler-cpsat-small", "scheduler-flat-small"), 20, args.ab_rounds
    )
    orbit_competitors = run_group(
        ("orbit-coordinate", "orbit-meet", "orbit-correlated"), 100, args.ab_rounds
    )
    value["scheduler_cpsat_balanced"] = cpsat_balanced
    value["scheduler_cpsat_small_state"] = cpsat_small
    value["orbit_competitors"] = orbit_competitors
    value["method"]["ortools"] = (
        "9.14.6206; CP-SAT; one worker; random seed zero; "
        "model reused across repetitions"
    )
    value["comparisons"].update(
        {
            "scheduler_cpsat_speedup_over_flat_balanced": ratio(
                cpsat_balanced["scheduler-flat"]["median_ns_per_solve"],
                cpsat_balanced["scheduler-cpsat"]["median_ns_per_solve"],
            ),
            "scheduler_flat_speedup_over_cpsat_small_state": ratio(
                cpsat_small["scheduler-cpsat-small"]["median_ns_per_solve"],
                cpsat_small["scheduler-flat-small"]["median_ns_per_solve"],
            ),
            "orbit_meet_speedup_over_coordinate": ratio(
                orbit_competitors["orbit-coordinate"]["median_ns_per_solve"],
                orbit_competitors["orbit-meet"]["median_ns_per_solve"],
            ),
            "orbit_meet_speedup_over_correlated": ratio(
                orbit_competitors["orbit-correlated"]["median_ns_per_solve"],
                orbit_competitors["orbit-meet"]["median_ns_per_solve"],
            ),
            "orbit_meet_speedup_over_python": ratio(
                orbit["orbit-python"]["median_ns_per_solve"],
                orbit_competitors["orbit-meet"]["median_ns_per_solve"],
            ),
        }
    )
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
