#!/usr/bin/env python3
"""Run an interleaved, streaming Ergodis-to-Kissat SATComp comparison."""

from __future__ import annotations

import argparse
import hashlib
import json
import lzma
import math
import os
import platform
import statistics
import subprocess
import time
from pathlib import Path


TIME = "/usr/bin/time"
TIME_MARKER = "ERGODIS_RUSAGE"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def materialize(source: Path) -> tuple[Path, bool]:
    if source.suffix != ".xz":
        return source, False
    target = source.with_suffix("")
    if target.exists():
        return target, False
    partial = target.with_suffix(target.suffix + ".partial")
    with lzma.open(source, "rb") as compressed, partial.open("wb") as output:
        while block := compressed.read(1 << 20):
            output.write(block)
    partial.replace(target)
    return target, True


def read_optional(path: Path) -> str | None:
    try:
        return path.read_text().strip()
    except OSError:
        return None


def cpu_frequency_khz(cpu: int | None) -> int | None:
    if cpu is None:
        return None
    value = read_optional(
        Path(f"/sys/devices/system/cpu/cpu{cpu}/cpufreq/scaling_cur_freq")
    )
    return int(value) if value is not None else None


def host_metadata(cpu: int) -> dict[str, object]:
    cpu_root = Path(f"/sys/devices/system/cpu/cpu{cpu}")
    governor = read_optional(cpu_root / "cpufreq/scaling_governor")
    boost = read_optional(Path("/sys/devices/system/cpu/cpufreq/boost"))
    no_turbo = read_optional(Path("/sys/devices/system/cpu/intel_pstate/no_turbo"))
    model = None
    for line in Path("/proc/cpuinfo").read_text().splitlines():
        if line.startswith("model name"):
            model = line.split(":", 1)[1].strip()
            break
    rustc = subprocess.run(
        ["rustc", "-vV"], check=True, text=True, stdout=subprocess.PIPE
    ).stdout
    lscpu = subprocess.run(
        ["lscpu", "-J"], check=True, text=True, stdout=subprocess.PIPE
    ).stdout
    stable = governor == "performance" and (boost == "0" or no_turbo == "1")
    return {
        "platform": platform.platform(),
        "cpu": cpu,
        "cpu_model": model,
        "thread_siblings": read_optional(cpu_root / "topology/thread_siblings_list"),
        "governor": governor,
        "boost": boost,
        "intel_no_turbo": no_turbo,
        "stable_frequency_policy": stable,
        "loadavg_before": Path("/proc/loadavg").read_text().strip(),
        "rustc_vv": rustc,
        "rustflags": os.environ.get("RUSTFLAGS", ""),
        "lscpu_json": json.loads(lscpu),
    }


def kissat_metadata(binary: Path) -> dict[str, str]:
    def output(option: str) -> str:
        return subprocess.run(
            [str(binary), option],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        ).stdout.strip()

    return {
        "version": output("--version"),
        "compiler": output("--compiler"),
        "build": output("--build"),
    }


def distribution(samples: list[int]) -> dict[str, float | int]:
    quartiles = statistics.quantiles(samples, n=4, method="inclusive")
    return {
        "min_ns": min(samples),
        "q1_ns": quartiles[0],
        "median_ns": statistics.median(samples),
        "q3_ns": quartiles[2],
        "max_ns": max(samples),
    }


def run(command: list[str], timeout_s: float, cpu: int | None = None) -> dict[str, object]:
    pinned = ["taskset", "-c", str(cpu), *command] if cpu is not None else command
    timed = [TIME, "-f", f"{TIME_MARKER} %M %U %S %c %w", *pinned]
    frequency_before = cpu_frequency_khz(cpu)
    start = time.perf_counter_ns()
    process = subprocess.Popen(
        timed,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=True,
    )
    try:
        stdout, stderr = process.communicate(timeout=timeout_s)
        status = "completed"
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, 9)
        stdout, stderr = process.communicate()
        status = "timeout"
    elapsed_ns = time.perf_counter_ns() - start
    frequency_after = cpu_frequency_khz(cpu)
    peak_rss_kb = None
    user_s = system_s = None
    involuntary_context_switches = voluntary_context_switches = None
    retained_stderr = []
    for line in stderr.splitlines():
        if line.startswith(TIME_MARKER + " "):
            fields = line.split()
            peak_rss_kb = int(fields[1])
            user_s = float(fields[2])
            system_s = float(fields[3])
            involuntary_context_switches = int(fields[4])
            voluntary_context_switches = int(fields[5])
        elif not line.startswith("Command terminated by signal"):
            retained_stderr.append(line)
    return {
        "status": status,
        "exit_code": process.returncode if status == "completed" else None,
        "elapsed_ns": elapsed_ns,
        "peak_rss_kb": peak_rss_kb,
        "user_s": user_s,
        "system_s": system_s,
        "involuntary_context_switches": involuntary_context_switches,
        "voluntary_context_switches": voluntary_context_switches,
        "cpu_frequency_before_khz": frequency_before,
        "cpu_frequency_after_khz": frequency_after,
        "stdout_tail": stdout[-4096:],
        "stderr_tail": "\n".join(retained_stderr)[-4096:],
    }


def t_score(samples: list[float]) -> float | None:
    if len(samples) < 2:
        return None
    deviation = statistics.stdev(samples)
    if deviation == 0:
        return None
    return statistics.mean(samples) / (deviation / math.sqrt(len(samples)))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--kissat", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--rounds", type=int, default=7)
    parser.add_argument("--timeout", type=float, default=30.0)
    parser.add_argument("--family", action="append", default=[])
    parser.add_argument("--present-only", action="store_true")
    parser.add_argument("--keep-decompressed", action="store_true")
    parser.add_argument("--kissat-revision", required=True)
    parser.add_argument("--cpu", type=int, required=True)
    parser.add_argument("--diagnostic-host", action="store_true")
    args = parser.parse_args()
    if args.rounds < 3 or args.timeout <= 0:
        raise SystemExit("need at least three rounds and a positive timeout")

    host = host_metadata(args.cpu)
    if not host["stable_frequency_policy"] and not args.diagnostic_host:
        raise SystemExit(
            "refusing canonical evidence: require performance governor with boost disabled "
            "(or pass --diagnostic-host for uncommitted sizing only)"
        )
    manifest = json.loads(args.manifest.read_text())
    selected = manifest["instances"]
    if args.family:
        selected = [entry for entry in selected if entry["family"] in args.family]
    if args.present_only:
        selected = [entry for entry in selected if (args.cache_dir / entry["filename"]).exists()]
    if not selected:
        raise SystemExit("no selected instances are present")

    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    summaries = []
    instance_log_ratios = []
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for case_index, entry in enumerate(selected):
            compressed = args.cache_dir / entry["filename"]
            cnf, created = materialize(compressed)
            cnf_hash = sha256(cnf)
            samples: dict[str, list[dict[str, object]]] = {"kissat": [], "ergodis": []}
            try:
                for round_index in range(args.rounds):
                    order = ("kissat", "ergodis")
                    if (case_index + round_index) & 1:
                        order = tuple(reversed(order))
                    for solver in order:
                        if solver == "kissat":
                            command = [str(args.kissat), "--quiet", str(cnf)]
                        else:
                            command = [str(args.ergodis), str(args.kissat), str(cnf)]
                        result = run(command, args.timeout, args.cpu)
                        record = {
                            "instance": entry["filename"],
                            "family": entry["family"],
                            "stratum": entry["stratum"],
                            "cnf_sha256": cnf_hash,
                            "round": round_index,
                            "solver": solver,
                            **result,
                        }
                        raw.write(json.dumps(record, sort_keys=True) + "\n")
                        raw.flush()
                        samples[solver].append(record)
                completed = all(
                    sample["status"] == "completed"
                    for solver_samples in samples.values()
                    for sample in solver_samples
                )
                result_codes = {
                    sample["exit_code"]
                    for solver_samples in samples.values()
                    for sample in solver_samples
                }
                if completed and (not result_codes <= {10, 20} or len(result_codes) != 1):
                    raise RuntimeError(f"solver result mismatch on {entry['filename']}")
                summary = {
                    **entry,
                    "cnf_sha256": cnf_hash,
                    "uncompressed_bytes": cnf.stat().st_size,
                    "status": "paired" if completed else "timeout",
                    "result_code": next(iter(result_codes)) if completed else None,
                    "theorem_hit": any(
                        "ergodis theorem=" in sample["stdout_tail"]
                        for sample in samples["ergodis"]
                    ),
                }
                if completed:
                    direct = [int(sample["elapsed_ns"]) for sample in samples["kissat"]]
                    portfolio = [int(sample["elapsed_ns"]) for sample in samples["ergodis"]]
                    paired_logs = [math.log(a / b) for a, b in zip(direct, portfolio)]
                    median_log = statistics.median(paired_logs)
                    instance_log_ratios.append(median_log)
                    summary.update(
                        {
                            "kissat_distribution": distribution(direct),
                            "ergodis_distribution": distribution(portfolio),
                            "paired_geometric_mean_speedup": math.exp(statistics.mean(paired_logs)),
                            "paired_log_t": t_score(paired_logs),
                            "kissat_peak_rss_kb": max(
                                int(sample["peak_rss_kb"] or 0) for sample in samples["kissat"]
                            ),
                            "ergodis_peak_rss_kb": max(
                                int(sample["peak_rss_kb"] or 0) for sample in samples["ergodis"]
                            ),
                        }
                    )
                summaries.append(summary)
                print(
                    f"[{case_index + 1}/{len(selected)}] {entry['family']} "
                    f"{entry['filename']} {summary['status']}",
                    flush=True,
                )
            finally:
                if created and not args.keep_decompressed:
                    cnf.unlink(missing_ok=True)

    host["loadavg_after"] = Path("/proc/loadavg").read_text().strip()
    document = {
        "schema": "ergodis-satcomp24-portfolio-ab-v1",
        "scope": "theorem-first Ergodis frontend with unchanged Kissat fallback",
        "method": {
            "rounds": args.rounds,
            "timeout_s": args.timeout,
            "order": "rotated interleave per instance",
            "raw_samples": str(args.raw_jsonl),
            "input": "identical uncompressed CNF for both commands",
            "timing_boundary": "cold solver process; warm file page cache; process launch included",
            "canonical_host": not args.diagnostic_host,
            "certificates": "decision comparison; Kissat proof emission disabled; theorem-hit certificate construction included",
            "memory": "peak RSS includes executable/runtime/process overhead for both native binaries",
        },
        "host": host,
        "builds": {
            "ergodis": "Cargo release profile: opt-level=3, thin LTO, one codegen unit, panic=abort",
            "kissat": kissat_metadata(args.kissat),
        },
        "artifacts": {
            "manifest_sha256": sha256(args.manifest),
            "raw_jsonl_sha256": sha256(args.raw_jsonl),
            "runner_sha256": sha256(Path(__file__)),
            "checker_sha256": sha256(
                Path(__file__).with_name("check_satcomp24_portfolio.py")
            ),
            "ergodis_sha256": sha256(args.ergodis),
            "kissat_sha256": sha256(args.kissat),
            "kissat_revision": args.kissat_revision,
        },
        "selected_instances": len(selected),
        "paired_instances": len(instance_log_ratios),
        "suite_geometric_mean_speedup": (
            math.exp(statistics.mean(instance_log_ratios)) if instance_log_ratios else None
        ),
        "suite_instance_log_t": t_score(instance_log_ratios),
        "instances": summaries,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
