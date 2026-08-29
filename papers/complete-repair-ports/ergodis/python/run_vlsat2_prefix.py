#!/usr/bin/env python3
"""Stream a multiround VLSAT-2 clique-certificate comparison."""

from __future__ import annotations

import argparse
import json
import math
import statistics
from pathlib import Path

from run_satcomp24_portfolio import (
    distribution,
    host_metadata,
    kissat_metadata,
    run,
    sha256,
    t_score,
)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--kissat", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--ergodis-rounds", type=int, default=15)
    parser.add_argument("--kissat-rounds", type=int, default=7)
    parser.add_argument("--timeout", type=float, default=10.0)
    parser.add_argument("--kissat-revision", required=True)
    parser.add_argument("--cpu", type=int, required=True)
    parser.add_argument("--diagnostic-host", action="store_true")
    args = parser.parse_args()
    if args.ergodis_rounds < args.kissat_rounds or args.kissat_rounds < 3:
        raise SystemExit("require ergodis rounds >= Kissat rounds >= 3")

    host = host_metadata(args.cpu)
    if not host["stable_frequency_policy"] and not args.diagnostic_host:
        raise SystemExit(
            "refusing canonical evidence: require performance governor with boost disabled "
            "(or pass --diagnostic-host for uncommitted sizing only)"
        )
    manifest = json.loads(args.manifest.read_text())
    summaries = []
    args.raw_jsonl.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("w", buffering=1) as raw:
        for case_index, entry in enumerate(manifest["instances"]):
            cnf = args.cache_dir / entry["filename"]
            if not cnf.exists():
                raise SystemExit(f"missing input: {cnf}")
            cnf_hash = sha256(cnf)
            certificate_samples = []
            kissat_samples = []
            kissat_active = True
            for round_index in range(args.ergodis_rounds):
                order = ["ergodis"]
                if round_index < args.kissat_rounds and kissat_active:
                    order = ["ergodis", "kissat"]
                    if (case_index + round_index) & 1:
                        order.reverse()
                for solver in order:
                    command = (
                        [str(args.ergodis), str(cnf)]
                        if solver == "ergodis"
                        else [str(args.kissat), "--quiet", str(cnf)]
                    )
                    result = run(command, args.timeout, args.cpu)
                    record = {
                        "instance": entry["filename"],
                        "expected": entry["expected"],
                        "cnf_sha256": cnf_hash,
                        "round": round_index,
                        "solver": solver,
                        **result,
                    }
                    raw.write(json.dumps(record, sort_keys=True) + "\n")
                    raw.flush()
                    (certificate_samples if solver == "ergodis" else kissat_samples).append(record)
                    if solver == "kissat" and result["status"] == "timeout":
                        kissat_active = False

            expected_code = 20 if entry["expected"] == "unsat" else 10
            certificate_json = []
            for sample in certificate_samples:
                if entry["expected"] == "unsat":
                    if sample["status"] != "completed" or sample["exit_code"] != 0:
                        raise RuntimeError(f"certificate failed on {entry['filename']}")
                    certificate_json.append(json.loads(sample["stdout_tail"]))
                elif sample["status"] != "completed" or sample["exit_code"] == 0:
                    raise RuntimeError(f"false certificate on {entry['filename']}")
            if certificate_json:
                semantics = [
                    {key: value for key, value in item.items() if key != "elapsed_ns"}
                    for item in certificate_json
                ]
                if any(item != semantics[0] for item in semantics):
                    raise RuntimeError(f"unstable certificate on {entry['filename']}")
            for sample in kissat_samples:
                if sample["status"] == "completed" and sample["exit_code"] != expected_code:
                    raise RuntimeError(f"Kissat result mismatch on {entry['filename']}")

            ergodis_ns = [int(sample["elapsed_ns"]) for sample in certificate_samples]
            completed_kissat = [
                sample for sample in kissat_samples if sample["status"] == "completed"
            ]
            summary = {
                **entry,
                "cnf_sha256": cnf_hash,
                "ergodis_samples": len(ergodis_ns),
                "ergodis_distribution": distribution(ergodis_ns),
                "ergodis_peak_rss_kb": max(
                    int(sample["peak_rss_kb"] or 0) for sample in certificate_samples
                ),
                "certificate": certificate_json[0] if certificate_json else None,
                "kissat_status": (
                    "completed"
                    if len(completed_kissat) == len(kissat_samples)
                    else "timeout"
                ),
                "kissat_samples": len(kissat_samples),
            }
            if certificate_json:
                internal_ns = [int(item["elapsed_ns"]) for item in certificate_json]
                summary["ergodis_internal_distribution"] = distribution(internal_ns)
                summary["ergodis_internal_ns_per_clause"] = (
                    summary["ergodis_internal_distribution"]["median_ns"] / entry["clauses"]
                )
            if completed_kissat:
                kissat_ns = [int(sample["elapsed_ns"]) for sample in completed_kissat]
                summary["kissat_distribution"] = distribution(kissat_ns)
                summary["kissat_process_ns_per_clause"] = (
                    summary["kissat_distribution"]["median_ns"] / entry["clauses"]
                )
                summary["kissat_peak_rss_kb"] = max(
                    int(sample["peak_rss_kb"] or 0) for sample in completed_kissat
                )
            if entry["expected"] == "unsat":
                if summary["kissat_status"] == "timeout":
                    summary["speedup_lower_bound"] = (
                        args.timeout
                        * 1_000_000_000
                        / summary["ergodis_distribution"]["median_ns"]
                    )
                    summary["paired_geometric_mean_speedup"] = None
                    summary["paired_log_t"] = None
                else:
                    paired = min(len(completed_kissat), len(ergodis_ns))
                    logs = [
                        math.log(
                            int(completed_kissat[index]["elapsed_ns"]) / ergodis_ns[index]
                        )
                        for index in range(paired)
                    ]
                    summary["speedup_lower_bound"] = None
                    summary["paired_geometric_mean_speedup"] = math.exp(
                        statistics.mean(logs)
                    )
                    summary["paired_log_t"] = t_score(logs)
            summaries.append(summary)
            print(
                f"[{case_index + 1}/{len(manifest['instances'])}] "
                f"{entry['filename']} certificate={bool(certificate_json)} "
                f"kissat={summary['kissat_status']}",
                flush=True,
            )

    host["loadavg_after"] = Path("/proc/loadavg").read_text().strip()
    document = {
        "schema": "ergodis-vlsat2-prefix-ab-v1",
        "scope": "first ten official VLSAT-2 rows",
        "method": {
            "ergodis_rounds": args.ergodis_rounds,
            "kissat_rounds": args.kissat_rounds,
            "timeout_s": args.timeout,
            "timeout_policy": "stop Kissat after its first timeout; continue certificate rounds",
            "order": "rotated interleave while both commands remain active",
            "raw_samples": str(args.raw_jsonl),
            "timing_boundary": "fresh solver process; CNF page cache warmed by hash pass; process launch included",
            "canonical_host": not args.diagnostic_host,
            "certificates": "Ergodis certificate construction and JSON emission are timed; Kissat proof emission is disabled, favoring the baseline; independent replay is outside the timed region",
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
            "checker_sha256": sha256(Path(__file__).with_name("check_vlsat2_prefix.py")),
            "process_runner_sha256": sha256(
                Path(__file__).with_name("run_satcomp24_portfolio.py")
            ),
            "ergodis_sha256": sha256(args.ergodis),
            "kissat_sha256": sha256(args.kissat),
            "kissat_revision": args.kissat_revision,
        },
        "instances": summaries,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
