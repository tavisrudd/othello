#!/usr/bin/env python3
"""Run an interleaved, streaming Ergodis-to-Kissat SATComp comparison."""

from __future__ import annotations

import argparse
import hashlib
import json
import lzma
import math
import os
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


def run(command: list[str], timeout_s: float) -> dict[str, object]:
    timed = [TIME, "-f", f"{TIME_MARKER} %M", *command]
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
    peak_rss_kb = None
    retained_stderr = []
    for line in stderr.splitlines():
        if line.startswith(TIME_MARKER + " "):
            peak_rss_kb = int(line.split()[1])
        elif not line.startswith("Command terminated by signal"):
            retained_stderr.append(line)
    return {
        "status": status,
        "exit_code": process.returncode if status == "completed" else None,
        "elapsed_ns": elapsed_ns,
        "peak_rss_kb": peak_rss_kb,
        "stdout_tail": stdout[-512:],
        "stderr_tail": "\n".join(retained_stderr)[-512:],
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
    args = parser.parse_args()
    if args.rounds < 3 or args.timeout <= 0:
        raise SystemExit("need at least three rounds and a positive timeout")

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
                        result = run(command, args.timeout)
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
                            "kissat_median_ns": statistics.median(direct),
                            "ergodis_median_ns": statistics.median(portfolio),
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

    document = {
        "schema": "ergodis-satcomp24-portfolio-ab-v1",
        "scope": "theorem-first Ergodis frontend with unchanged Kissat fallback",
        "method": {
            "rounds": args.rounds,
            "timeout_s": args.timeout,
            "order": "rotated interleave per instance",
            "raw_samples": str(args.raw_jsonl),
            "input": "identical uncompressed CNF for both commands",
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
