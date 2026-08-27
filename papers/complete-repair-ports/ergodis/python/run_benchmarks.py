#!/usr/bin/env python3
"""Run rotated interleaved release benchmarks."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import platform
import re
import statistics
import subprocess
from pathlib import Path

PYTHON_ROOT = Path(__file__).resolve().parent
ROOT = PYTHON_ROOT.parent
OUTPUT = ROOT / "evidence" / "benchmarks.json"
BINARY = Path(
    os.environ.get("ergodis_bench_binary", ROOT / "target" / "release" / "bench_kernels")
)


def command(variant: str, repetitions: int) -> list[str]:
    cpu_set = "0-23" if "parallel-" in variant else "2"
    if any(
        f":{backend}:" in variant
        for backend in ("cpsat", "maxflow", "highs", "cryptominisat", "zdd")
    ):
        dependencies = []
        if "highs" in variant:
            dependencies.extend(("--with", "scipy==1.16.1"))
        elif "cryptominisat" in variant:
            dependencies.extend(("--with", "pycryptosat==5.14.7"))
        elif "zdd" in variant:
            dependencies.extend(("--with", "graphillion==2.1"))
        else:
            dependencies.extend(("--with", "ortools==9.14.6206"))
        return [
            "taskset",
            "-c",
            cpu_set,
            "nix",
            "shell",
            "nixpkgs#uv",
            "--command",
            "uv",
            "run",
            "--no-project",
            *dependencies,
            "python3",
            str(PYTHON_ROOT / "benchmark_python.py"),
            variant,
            str(repetitions),
        ]
    if variant.endswith("-python"):
        return [
            "taskset",
            "-c",
            cpu_set,
            "nix",
            "shell",
            "nixpkgs#python3",
            "--command",
            "python3",
            str(PYTHON_ROOT / "benchmark_python.py"),
            variant,
            str(repetitions),
        ]
    return ["taskset", "-c", cpu_set, str(BINARY), variant, str(repetitions)]


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


def run_perf_group(variant: str, group: str):
    perf_command = ["perf", "stat", "-M", group, "-x,"] + command(variant, 1)
    completed = subprocess.run(
        perf_command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    sample = json.loads(completed.stdout)
    metrics = {}
    for line in completed.stderr.splitlines():
        fields = line.split(",", 6)
        if len(fields) != 7:
            continue
        match = re.search(r"%\S*\s+([a-z_]+)$", fields[6])
        if match is not None:
            metrics[match.group(1)] = float(fields[5])
    return {
        "command": perf_command,
        "sample": sample,
        "percent": metrics,
        "raw_perf_csv": completed.stderr.splitlines(),
    }


def run_tma(variant: str):
    pipeline = run_perf_group(variant, "PipelineL1")
    backend = run_perf_group(variant, "backend_bound_group")
    return {
        "command": pipeline["command"],
        "sample": pipeline["sample"],
        "pipeline_l1_percent": pipeline["percent"],
        "backend_breakdown_percent": backend["percent"],
        "raw_pipeline_l1_csv": pipeline["raw_perf_csv"],
        "raw_backend_csv": backend["raw_perf_csv"],
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
    parser.add_argument("--transfer-deep-only", action="store_true")
    parser.add_argument("--jin-fu-only", action="store_true")
    parser.add_argument("--jin-fu-hamming-only", action="store_true")
    parser.add_argument("--scheduler-scaling-only", action="store_true")
    parser.add_argument("--orbit-scaling-only", action="store_true")
    parser.add_argument("--orbit-iterative-ab", action="store_true")
    parser.add_argument("--ergodis-limits-only", action="store_true")
    parser.add_argument("--tma-large-only", action="store_true")
    parser.add_argument("--tower-stream-only", action="store_true")
    parser.add_argument("--ergodis-thread-sweep-only", action="store_true")
    parser.add_argument("--streaming-input-only", action="store_true")
    parser.add_argument("--applications-only", action="store_true")
    parser.add_argument("--application-sota-only", action="store_true")
    parser.add_argument("--ceph-rust-only", action="store_true")
    parser.add_argument("--baseline-binary", type=Path)
    parser.add_argument("--candidate-binary", type=Path, default=BINARY)
    parser.add_argument("--locality-key", default="scheduler_locality_ab")
    args = parser.parse_args()
    if not args.write:
        raise SystemExit("pass --write to record a fresh noncanonical benchmark")
    if not BINARY.exists():
        raise SystemExit("build target/release/bench_kernels first")

    if args.ceph_rust_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --ceph-rust-only")
        value = json.loads(OUTPUT.read_text())
        comparison = value["application_formulation_specific_comparisons"]
        ceph = comparison["measurements"]["ceph_recursive_xor"]
        variant = "application:ceph-zdd:rust:8:2"
        rust = run_group((variant,), 1, args.ab_rounds)[variant]
        if rust["checksum_per_solve"] != ceph["baseline"]["checksum_per_solve"]:
            raise RuntimeError("Ceph Graphillion/Rust checksum mismatch")
        ceph["rust"] = rust
        ceph["rust_speedup"] = ratio(
            ceph["baseline"]["median_ns_per_solve"], rust["median_ns_per_solve"]
        )
        ceph["rounds"]["rust"] = args.ab_rounds
        comparison["artifacts"]["bench_kernels_binary_sha256"] = sha256(BINARY)
        comparison["artifacts"]["bench_kernels_source_sha256"] = sha256(
            ROOT / "src/bin/bench_kernels.rs"
        )
        comparison["artifacts"]["run_benchmarks_sha256"] = sha256(
            Path(__file__).resolve()
        )

        profiles = {}
        for depth, repetitions in ((10, 10), (30, 10), (80, 5)):
            variants = [
                f"application:ceph-reliability:rust:{depth}:2",
                f"application:ceph-aggregate:rust:{depth}:2:2",
            ]
            if depth < 64:
                variants.insert(0, f"application:ceph-zdd:rust:{depth}:2")
            measurements = run_group(tuple(variants), repetitions, args.ab_rounds)
            profiles[f"depth-{depth}"] = {
                "depth": depth,
                "represented_supports": str(1 << depth),
                "measurements": measurements,
            }
        explicit_variant = "application:ceph:rust:10:2"
        profiles["depth-10"]["original_explicit"] = run_group(
            (explicit_variant,), 1, args.rounds
        )[explicit_variant]
        value["ceph_compressed_family_consumers"] = {
            "protocol": {
                "common": "pinned-core deterministic end-to-end Rust runs; compressed family rebuilt for every solve",
                "scope": "Rust-only update; recorded competitor samples are unchanged",
                "reliability": "exact success counts by available-helper cardinality",
                "aggregate": "Pareto-minimal two-domain load frontier, two-demand exact schedule, and representative supports",
            },
            "rounds": {"compressed": args.ab_rounds, "original_explicit": args.rounds},
            "profiles": profiles,
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.application_sota_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --application-sota-only")
        value = json.loads(OUTPUT.read_text())
        cases = {
            "ceph_recursive_xor": (
                "application:ceph:zdd:8",
                "application:ceph:rust:8",
                1,
                args.ab_rounds,
            ),
            "azure_lrc_batch": (
                "application:azure-counted:highs:100000:100000",
                None,
                1,
                args.ab_rounds,
            ),
            "repair_dag": (
                "application:rdag:interval-cpsat:21:3",
                None,
                1,
                args.ab_rounds,
            ),
            "qc_ldpc_codeword": (
                "application:qc:cryptominisat:50000:4",
                None,
                1,
                args.ab_rounds,
            ),
            "vector_node_span": (
                "application:vector:cryptominisat:64:2",
                None,
                1,
                args.ab_rounds,
            ),
            "gpu_checkpoint_mds": (
                "application:gpu-compiled:maxflow:10000:6000:64",
                None,
                1,
                args.ab_rounds,
            ),
        }
        measurements = {}
        application_measurements = value["application_comparisons"]["measurements"]
        for name, (variant, rust_variant, repetitions, rounds) in cases.items():
            result = run_group((variant,), repetitions, rounds)[variant]
            rust = (
                run_group((rust_variant,), repetitions, rounds)[rust_variant]
                if rust_variant is not None
                else application_measurements[name]["rust"]
            )
            if result["checksum_per_solve"] != rust["checksum_per_solve"]:
                raise RuntimeError(f"application SOTA checksum mismatch: {name}")
            measurements[name] = {
                "rust": rust,
                "baseline": result,
                "rust_speedup": ratio(
                    result["median_ns_per_solve"], rust["median_ns_per_solve"]
                ),
                "rounds": {
                    "rust": len(rust["samples"]),
                    "baseline": rounds,
                },
            }
        value["application_formulation_specific_comparisons"] = {
            "protocol": {
                "common": "pinned-core deterministic exact solves; objective/status agreement required",
                "scope": "strong open-source formulation-specific baseline, not a universal SOTA claim",
                "ceph_recursive_xor": "Graphillion 2.1 zero-suppressed decision-diagram family closure",
                "gpu_checkpoint_mds": "OR-Tools 9.14 SimpleMaxFlow on the full failure-survivor bipartite graph",
                "azure_lrc_batch": "SciPy 1.16 milp/HiGHS on the same exact six-type counted formulation",
                "repair_dag": "OR-Tools 9.14 interval variables and NoOverlap constraints",
                "qc_ldpc_codeword": "CryptoMiniSat 5.14 native XOR clauses plus exact-cardinality automaton",
                "vector_node_span": "CryptoMiniSat 5.14 native XOR clauses plus sequential helper-cardinality bounds",
            },
            "artifacts": {
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
                "verify_baseline_encodings_sha256": sha256(
                    PYTHON_ROOT / "verify_baseline_encodings.py"
                ),
            },
            "measurements": measurements,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.applications_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --applications-only")
        value = json.loads(OUTPUT.read_text())
        cases = {
            "azure_lrc_batch": ("azure", (100_000, 100_000), 100_000, 1),
            "repair_dag": ("rdag", (21, 3), 1_000, args.ab_rounds),
            "qc_ldpc_codeword": ("qc", (50_000, 4), 100, args.ab_rounds),
            "vector_node_span": ("vector", (64, 2), 1_000, args.ab_rounds),
            "gpu_checkpoint_mds": ("gpu-compiled", (10_000, 6_000, 64), 100, 1),
        }
        measurements = {}
        for name, (application, parameters, rust_repetitions, cpsat_rounds) in cases.items():
            suffix = ":".join(map(str, parameters))
            rust = f"application:{application}:rust:{suffix}"
            cpsat = f"application:{application}:cpsat:{suffix}"
            rust_result = run_group((rust,), rust_repetitions, args.ab_rounds)[rust]
            cpsat_result = run_group((cpsat,), 1, cpsat_rounds)[cpsat]
            if rust_result["checksum_per_solve"] != cpsat_result["checksum_per_solve"]:
                raise RuntimeError(f"application checksum mismatch: {name}")
            measurements[name] = {
                "rust": rust_result,
                "cpsat": cpsat_result,
                "rust_speedup_over_cpsat": ratio(
                    cpsat_result["median_ns_per_solve"],
                    rust_result["median_ns_per_solve"],
                ),
                "rounds": {"rust": args.ab_rounds, "cpsat": cpsat_rounds},
            }
            if name == "azure_lrc_batch":
                counted = f"application:azure-counted:cpsat:{suffix}"
                counted_result = run_group((counted,), 1, args.ab_rounds)[counted]
                if rust_result["checksum_per_solve"] != counted_result["checksum_per_solve"]:
                    raise RuntimeError("Azure counted CP-SAT checksum mismatch")
                measurements[name]["counted_cpsat"] = counted_result
                measurements[name]["rust_speedup_over_counted_cpsat"] = ratio(
                    counted_result["median_ns_per_solve"],
                    rust_result["median_ns_per_solve"],
                )
                measurements[name]["rounds"]["counted_cpsat"] = args.ab_rounds
        value["application_comparisons"] = {
            "rounds": args.ab_rounds,
            "protocol": {
                "common": "pinned-core deterministic exact solves; checksum agreement required",
                "rust": "application-specific exact structural kernel, including input compilation",
                "cpsat": "single-worker OR-Tools 9.14 model of the same bounded decision or optimization problem",
            },
            "sources": {
                "azure_lrc_batch": "Huang et al. (2012), Azure LRC(12,2,2) placement",
                "repair_dag": "RepairBoost (ATC 2021), repair-DAG scheduling abstraction",
                "qc_ldpc_codeword": "QC-LDPC lifted parity-check codeword decision",
                "vector_node_span": "subpacketized linear repair with one cost per helper node",
                "gpu_checkpoint_mds": "REFT (SC 2023), erasure-coded in-memory checkpoints after placement",
            },
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "measurements": measurements,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.streaming_input_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --streaming-input-only")
        value = json.loads(OUTPUT.read_text())
        profiles = {}
        for name, demands, options in (
            ("demands-10000000", 10_000_000, 4),
            ("options-1000000", 80, 1_000_000),
        ):
            prefix = (
                "scheduler-graded-grid:{}:4:2:"
                f"{demands}:{options}:2719080173"
            )
            variants = (
                prefix.format("graded-adaptive-workspace"),
                prefix.format("graded-stream"),
            )
            measured = run_group(variants, 1, 3)
            if len({entry["work_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"streaming-input work mismatch: {name}")
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"streaming-input checksum mismatch: {name}")
            profiles[name] = {
                "speedup": ratio(
                    measured[variants[0]]["median_ns_per_solve"],
                    measured[variants[1]]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["streaming_input_compilation"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "three-round pinned-core rotated end-to-end comparison; exact work "
                "and optimum parity; generated alternatives are identical"
            ),
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.ergodis_thread_sweep_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --ergodis-thread-sweep-only")
        value = json.loads(OUTPUT.read_text())
        profiles = {}
        for name, demands, options in (
            ("demands-40000000", 40_000_000, 4),
            ("options-14000000", 80, 14_000_000),
        ):
            prefix = (
                "scheduler-graded-grid:{}:4:2:"
                f"{demands}:{options}:2719080173"
            )
            variants = (prefix.format("graded-stream"),) + tuple(
                prefix.format(f"graded-stream-parallel-{threads}")
                for threads in (2, 4, 8, 12, 16, 24)
            )
            measured = run_group(variants, 1, 1)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"scheduler thread-sweep checksum mismatch: {name}")
            profiles[name] = {"variants": variants, "measurements": measured}
        value["ergodis_large_thread_sweep"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "one pinned end-to-end solve per 1/2/4/8/12/16/24-worker point; "
                "streaming problem compilation included; exact optimum parity"
            ),
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.tower_stream_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --tower-stream-only")
        value = json.loads(OUTPUT.read_text())
        eager_variant = "transfer-tower:rust:12:4"
        stream_variant = "transfer-tower:rust-stream:12:4"
        depth_12 = run_group((eager_variant, stream_variant), 1, args.ab_rounds)
        depth_14_variant = "transfer-tower:rust-stream:14:4"
        depth_14 = run_group((depth_14_variant,), 1, min(args.ab_rounds, 3))
        if depth_12[eager_variant]["work_per_solve"] != depth_12[stream_variant]["work_per_solve"]:
            raise RuntimeError("eager/streaming tower witness count mismatch")
        value["tower_streaming_replay"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "pinned-core end-to-end replay; seven-round rotated depth-12 "
                "eager/streaming comparison and three depth-14 streaming rounds"
            ),
            "depth_12_speedup": ratio(
                depth_12[eager_variant]["median_ns_per_solve"],
                depth_12[stream_variant]["median_ns_per_solve"],
            ),
            "depth_12": depth_12,
            "depth_14": depth_14[depth_14_variant],
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.tma_large_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --tma-large-only")
        value = json.loads(OUTPUT.read_text())
        variants = {
            "tower-stream-depth-14": "transfer-tower:rust-stream:14:4",
            "scheduler-demands-10000000": (
                "scheduler-graded-grid:graded-stream:4:2:"
                "10000000:4:2719080173"
            ),
            "scheduler-options-1000000": (
                "scheduler-graded-grid:graded-stream:4:2:"
                "80:1000000:2719080173"
            ),
            "orbit-families-10000000": "orbit-grid:rust:10000000:4:6:2719081239",
        }
        value["large_case_tma"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "Linux perf PipelineL1 and backend_bound_group metrics; pinned core; "
                "one complete end-to-end solve per group; multiplexed Zen 5 "
                "PipelineL1 counters are approximate"
            ),
            "profiles": {name: run_tma(variant) for name, variant in variants.items()},
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.ergodis_limits_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --ergodis-limits-only")
        value = json.loads(OUTPUT.read_text())
        variants = {
            "tower-stream-depth-14": "transfer-tower:rust-stream:14:4",
            "scheduler-demands-40000000": (
                "scheduler-graded-grid:graded-stream:4:2:"
                "40000000:4:2719080173"
            ),
            "scheduler-options-14000000": (
                "scheduler-graded-grid:graded-stream:4:2:"
                "80:14000000:2719080173"
            ),
            "orbit-families-10000000": "orbit-grid:rust:10000000:4:6:2719081239",
        }
        profiles = {
            name: run_group((variant,), 1, 1)[variant]
            for name, variant in variants.items()
        }
        value["ergodis_sub_ten_second_stress"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "pinned-core deterministic single end-to-end solves; largest completed "
                "power-of-ten/geometric probes below ten seconds, not universal limits"
            ),
            "variants": variants,
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.orbit_iterative_ab:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --orbit-iterative-ab")
        if args.baseline_binary is None or not args.baseline_binary.exists():
            raise SystemExit("--orbit-iterative-ab requires an existing --baseline-binary")
        if not args.candidate_binary.exists():
            raise SystemExit("--candidate-binary does not exist")
        value = json.loads(OUTPUT.read_text())
        profiles = {}
        for name, variant, repetitions in (
            ("fixed-coordinate", "orbit-coordinate", 100),
            ("families-8192", "orbit-grid:rust:8192:4:6:2719081239", 50),
        ):
            measured = run_binary_ab(
                variant,
                repetitions,
                args.ab_rounds,
                args.baseline_binary,
                args.candidate_binary,
            )
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"orbit iterative checksum mismatch: {variant}")
            if len({entry["work_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"orbit iterative work mismatch: {variant}")
            profiles[name] = {
                "variant": variant,
                "speedup": ratio(
                    measured["baseline"]["median_ns_per_solve"],
                    measured["candidate"]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["orbit_iterative_ab"] = {
            "rounds": args.ab_rounds,
            "protocol": "saved-binary rotated interleave; exact work and checksum parity",
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.orbit_scaling_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --orbit-scaling-only")
        value = json.loads(OUTPUT.read_text())
        profiles = {}
        for family_count, profile_rounds in (
            (80, args.ab_rounds),
            (320, args.ab_rounds),
            (1_280, min(args.ab_rounds, 7)),
            (8_192, min(args.ab_rounds, 3)),
        ):
            variants = (
                f"orbit-grid:rust:{family_count}:4:6:2719081239",
                f"orbit-grid:cpsat:{family_count}:4:6:2719081239",
            )
            measured = run_group(variants, 1, profile_rounds)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"orbit scaling checksum mismatch: {variants}")
            profiles[str(family_count)] = {
                "families": family_count,
                "options_per_family": 4,
                "syndrome_width": 6,
                "rounds": profile_rounds,
                "rust_speedup_over_cpsat": ratio(
                    measured[variants[1]]["median_ns_per_solve"],
                    measured[variants[0]]["median_ns_per_solve"],
                ),
                "measurements": measured,
            }
        value["orbit_scaling_cpsat"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": {
                "common": "rotated interleave; deterministic single worker; exact feasibility",
                "rust": "coordinate DFS over packed ternary residues",
                "cpsat": "one-hot orbit choices and exact ternary syndrome equations",
            },
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.scheduler_scaling_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --scheduler-scaling-only")
        value = json.loads(OUTPUT.read_text())
        cases = (
            ("demands-80", 4, 2, 80, 4, args.ab_rounds),
            ("demands-320", 4, 2, 320, 4, args.ab_rounds),
            ("demands-1280", 4, 2, 1_280, 4, args.ab_rounds),
            ("demands-8192", 4, 2, 8_192, 4, min(args.ab_rounds, 7)),
            ("options-64", 4, 2, 80, 64, args.ab_rounds),
            ("options-1024", 4, 2, 80, 1_024, min(args.ab_rounds, 7)),
        )
        profiles = {}
        for name, resources, capacity, demands, options, profile_rounds in cases:
            prefix = (
                f"scheduler-graded-grid:{{}}:{resources}:{capacity}:"
                f"{demands}:{options}:2719080173"
            )
            variants = (
                prefix.format("graded-adaptive-workspace"),
                prefix.format("cpsat"),
                prefix.format("cpsat-structured"),
            )
            measured = run_group(variants, 1, profile_rounds)
            if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
                raise RuntimeError(f"scheduler scaling checksum mismatch: {variants}")
            profiles[name] = {
                "resources": resources,
                "capacity": capacity,
                "demands": demands,
                "options_per_demand": options,
                "rounds": profile_rounds,
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
        value["scheduler_scaling_cpsat"] = {
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": {
                "common": "rotated interleave; deterministic single worker; one end-to-end solve",
                "rust": "canonical options; grading certificate; adaptive reusable workspace",
                "raw_cpsat": "raw generated options",
                "structured_cpsat": "Pareto-canonical options and exact grading bound",
            },
            "profiles": profiles,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.transfer_deep_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --transfer-deep-only")
        value = json.loads(OUTPUT.read_text())
        variants = {
            "rust": ("transfer-tower:rust:6:4", 21),
            "direct_cpsat": ("transfer-tower:cpsat-direct:6:4", 1),
            "structured_cpsat": ("transfer-tower:cpsat:6:4", 7),
        }
        measured = {
            name: run_group((variant,), 1, rounds)[variant]
            for name, (variant, rounds) in variants.items()
        }
        if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
            raise RuntimeError("deep transfer CP-SAT checksum mismatch")
        value["transfer_tower_deep_stress"] = {
            "depth": 6,
            "fanout": 4,
            "leaf_blocks": 4**6,
            "witness_nodes": sum(4**level for level in range(7)),
            "rounds": {name: rounds for name, (_, rounds) in variants.items()},
            "rust_speedup_over_direct_cpsat": ratio(
                measured["direct_cpsat"]["median_ns_per_solve"],
                measured["rust"]["median_ns_per_solve"],
            ),
            "rust_speedup_over_structured_cpsat": ratio(
                measured["structured_cpsat"]["median_ns_per_solve"],
                measured["rust"]["median_ns_per_solve"],
            ),
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "single-worker exact stress: 21 Rust samples, seven structured CP-SAT "
                "samples, and one completed direct CP-SAT solve"
            ),
            "measurements": measured,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.jin_fu_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --jin-fu-only")
        value = json.loads(OUTPUT.read_text())
        variants = ("jin-fu:rust", "jin-fu:cpsat-direct", "jin-fu:cpsat")
        measured = run_group(variants, 1, args.ab_rounds)
        if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
            raise RuntimeError(f"Jin--Fu CP-SAT checksum mismatch: {variants}")
        value["jin_fu_concatenated_lrc"] = {
            "source": {
                "paper": "Jin--Fu (2026), arXiv:2605.04618v1, Example 5.7",
                "outer_code": "GF(4) cyclic [43,36,5]",
                "generator_polynomial": "x^7 + a*x^5 + x^4 + x^3 + a^2*x^2 + 1",
                "concatenated_code": "binary [129,72,10;2] LRC",
            },
            "rounds": args.ab_rounds,
            "exact_result": {
                "outer_functionals": 16_383,
                "relative_weight": 2,
                "zero_functional_cost": 5,
                "best_nonzero_functional_cost": 26,
                "gamma": 5,
                "maximum_confined_radius": 4,
            },
            "rust_speedup_over_direct_cpsat": ratio(
                measured[variants[1]]["median_ns_per_solve"],
                measured[variants[0]]["median_ns_per_solve"],
            ),
            "rust_speedup_over_structured_cpsat": ratio(
                measured[variants[2]]["median_ns_per_solve"],
                measured[variants[0]]["median_ns_per_solve"],
            ),
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": {
                "common": "rotated interleave; deterministic single worker; exact optimum",
                "rust": "compile GF(4) labelled costs; enumerate the complete outer functional dual; retain a witness",
                "direct_cpsat": "binary inner coefficients and support objective; GF(4) outer-functional parity constraints",
                "structured_cpsat": "the same labelled costs as ergodis; one-hot labels and GF(4) outer-functional parity constraints",
            },
            "measurements": measured,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

    if args.jin_fu_hamming_only:
        if not OUTPUT.exists():
            raise SystemExit("run the baseline benchmark before --jin-fu-hamming-only")
        value = json.loads(OUTPUT.read_text())
        dimension = 6
        variants = tuple(
            f"jin-fu-hamming:{backend}:{dimension}"
            for backend in ("rust", "cpsat-direct", "cpsat")
        )
        measured = {}
        measured[variants[0]] = run_group((variants[0],), 1, 21)[variants[0]]
        for variant in variants[1:]:
            measured[variant] = run_group((variant,), 1, 1)[variant]
        if len({entry["checksum_per_solve"] for entry in measured.values()}) != 1:
            raise RuntimeError(f"Jin--Fu Hamming CP-SAT checksum mismatch: {variants}")
        value["jin_fu_hamming_lrc_scale"] = {
            "source": {
                "paper": "Jin--Fu (2026), arXiv:2605.04618v1, Corollary 5.4",
                "outer_code": "GF(4) Hamming [1365,1359,3]",
                "concatenated_code": "binary [4095,2718,6;2] perfect LRC",
            },
            "exact_result": {
                "outer_functionals": 4095,
                "relative_weight": 2,
                "zero_functional_cost": 5,
                "best_nonzero_functional_cost": 1023,
                "gamma": 5,
                "maximum_confined_radius": 4,
            },
            "rounds": {"rust": 21, "direct_cpsat": 1, "structured_cpsat": 1},
            "rust_speedup_over_direct_cpsat": ratio(
                measured[variants[1]]["median_ns_per_solve"],
                measured[variants[0]]["median_ns_per_solve"],
            ),
            "rust_speedup_over_structured_cpsat": ratio(
                measured[variants[2]]["median_ns_per_solve"],
                measured[variants[0]]["median_ns_per_solve"],
            ),
            "artifacts": {
                "bench_kernels_binary_sha256": sha256(BINARY),
                "bench_kernels_source_sha256": sha256(ROOT / "src/bin/bench_kernels.rs"),
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
                "run_benchmarks_sha256": sha256(Path(__file__).resolve()),
            },
            "protocol": (
                "pinned-core deterministic exact solves; 21 Rust samples and one "
                "completed proof of optimality from each CP-SAT model"
            ),
            "measurements": measured,
        }
        OUTPUT.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        return

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
                "benchmark_python_sha256": sha256(PYTHON_ROOT / "benchmark_python.py"),
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
        "schema": "ergodis-rust-benchmark-v1",
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
