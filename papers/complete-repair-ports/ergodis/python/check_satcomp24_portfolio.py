#!/usr/bin/env python3
"""Independently check streamed SATComp portfolio evidence."""

from __future__ import annotations

import argparse
import bz2
import hashlib
import json
import lzma
import math
import statistics
from collections import defaultdict
from pathlib import Path

from check_vlsat2_prefix import replay_clique


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def uncompressed_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    if path.suffix == ".xz":
        opener = lzma.open
    elif path.suffix == ".bz2":
        opener = bz2.open
    else:
        opener = open
    with opener(path, "rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def t_score(samples: list[float]) -> float | None:
    if len(samples) < 2:
        return None
    deviation = statistics.stdev(samples)
    if deviation == 0:
        return None
    return statistics.mean(samples) / (deviation / math.sqrt(len(samples)))


def close(left: float | None, right: float | None) -> bool:
    if left is None or right is None:
        return left is right
    return math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)


def distribution(samples: list[int]) -> dict[str, float | int]:
    quartiles = (
        statistics.quantiles(samples, n=4, method="inclusive")
        if len(samples) > 1
        else [samples[0], samples[0], samples[0]]
    )
    return {
        "min_ns": min(samples),
        "q1_ns": quartiles[0],
        "median_ns": statistics.median(samples),
        "q3_ns": quartiles[2],
        "max_ns": max(samples),
    }


def rss_distribution(samples: list[int]) -> dict[str, float | int]:
    timing = distribution(samples)
    return {key.replace("_ns", "_kb"): value for key, value in timing.items()}


def raw_certificate(stdout: object) -> dict[str, object] | None:
    text = str(stdout)
    if "ergodis theorem=" not in text:
        return None
    for line in text.splitlines():
        if line.startswith("{"):
            certificate = json.loads(line)
            if certificate.get("status") != "unsat":
                raise SystemExit("bad theorem certificate output")
            certificate.pop("elapsed_ns", None)
            return certificate
    raise SystemExit("theorem hit omitted its certificate")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--ergodis", type=Path, required=True)
    parser.add_argument("--kissat", type=Path, required=True)
    args = parser.parse_args()

    document = json.loads(args.evidence.read_text())
    manifest = json.loads(args.manifest.read_text())
    if document["schema"] != "ergodis-satcomp24-portfolio-ab-v1":
        raise SystemExit("unexpected evidence schema")
    host = document["host"]
    if host.get("canonical_host_ready") != host.get("stable_frequency_policy"):
        raise SystemExit("inconsistent canonical-host metadata")
    if document["method"]["canonical_host"] and not host["canonical_host_ready"]:
        raise SystemExit("canonical evidence records an uncontrolled host")
    artifacts = document["artifacts"]
    expected_hashes = {
        "manifest_sha256": sha256(args.manifest),
        "raw_jsonl_sha256": sha256(args.raw_jsonl),
        "runner_sha256": sha256(Path(__file__).with_name("run_satcomp24_portfolio.py")),
        "checker_sha256": sha256(Path(__file__)),
        "ergodis_sha256": sha256(args.ergodis),
        "kissat_sha256": sha256(args.kissat),
    }
    for key, expected in expected_hashes.items():
        if artifacts.get(key) != expected:
            raise SystemExit(f"artifact hash mismatch: {key}")

    records: dict[str, dict[str, dict[int, dict[str, object]]]] = defaultdict(
        lambda: defaultdict(dict)
    )
    raw_sequence = []
    with args.raw_jsonl.open() as source:
        for line_number, line in enumerate(source, 1):
            record = json.loads(line)
            solver_rounds = records[record["instance"]][record["solver"]]
            round_index = int(record["round"])
            if round_index in solver_rounds:
                raise SystemExit(f"duplicate raw record at line {line_number}")
            solver_rounds[round_index] = record
            raw_sequence.append(
                (
                    record["instance"],
                    int(record["case_index"]),
                    round_index,
                    int(record["order_position"]),
                    record["solver"],
                )
            )

    suite_logs = []
    rounds = int(document["method"]["rounds"])
    manifest_entries = {entry["filename"]: entry for entry in manifest["instances"]}
    expected_sequence = []
    observed_summaries = set()
    for case_index, summary in enumerate(document["instances"]):
        filename = summary["filename"]
        if filename in observed_summaries or filename not in manifest_entries:
            raise SystemExit(f"duplicate or unknown summary: {filename}")
        observed_summaries.add(filename)
        entry = manifest_entries[filename]
        if any(summary.get(key) != value for key, value in entry.items()):
            raise SystemExit(f"manifest metadata mismatch: {filename}")
        for round_index in range(rounds):
            order = ["kissat", "ergodis"]
            if (case_index + round_index) & 1:
                order.reverse()
            expected_sequence.extend(
                (filename, case_index, round_index, position, solver)
                for position, solver in enumerate(order)
            )
        source = args.cache_dir / filename
        if not source.exists() or uncompressed_sha256(source) != summary["cnf_sha256"]:
            raise SystemExit(f"CNF hash mismatch: {filename}")
        case = records.pop(filename, None)
        if case is None or set(case) != {"kissat", "ergodis"}:
            raise SystemExit(f"missing solver records: {filename}")
        if any(set(case[solver]) != set(range(rounds)) for solver in case):
            raise SystemExit(f"missing rounds: {filename}")
        all_records = [record for solver in case.values() for record in solver.values()]
        if any(
            record.get("family") != summary["family"]
            or record.get("stratum") != summary["stratum"]
            or record.get("cnf_sha256") != summary["cnf_sha256"]
            for record in all_records
        ):
            raise SystemExit(f"raw metadata mismatch: {filename}")
        certificates = [
            raw_certificate(case["ergodis"][index]["stdout_tail"]) for index in range(rounds)
        ]
        hit_flags = [certificate is not None for certificate in certificates]
        if summary["theorem_hit"] != all(hit_flags) or (any(hit_flags) and not all(hit_flags)):
            raise SystemExit(f"theorem dispatch mismatch: {filename}")
        if summary["theorem_hit"]:
            if summary["certificate"] is None:
                raise SystemExit(f"missing theorem certificate: {filename}")
            if any(certificate != summary["certificate"] for certificate in certificates):
                raise SystemExit(f"theorem certificate mismatch: {filename}")
            replay_clique(source, summary["certificate"])
        elif summary["certificate"] is not None:
            raise SystemExit(f"certificate on theorem miss: {filename}")
        completed = all(record["status"] == "completed" for record in all_records)
        expected_status = "paired" if completed else "timeout"
        if summary["status"] != expected_status:
            raise SystemExit(f"status mismatch: {filename}")
        if not completed:
            continue
        codes = {record["exit_code"] for record in all_records}
        if len(codes) != 1 or not codes <= {10, 20} or summary["result_code"] not in codes:
            raise SystemExit(f"semantic result mismatch: {filename}")
        direct = [int(case["kissat"][index]["elapsed_ns"]) for index in range(rounds)]
        portfolio = [int(case["ergodis"][index]["elapsed_ns"]) for index in range(rounds)]
        logs = [math.log(a / b) for a, b in zip(direct, portfolio)]
        suite_logs.append(statistics.median(logs))
        checks = {
            "paired_geometric_mean_speedup": math.exp(statistics.mean(logs)),
            "paired_log_t": t_score(logs),
        }
        for key, expected in checks.items():
            if not close(summary[key], expected):
                raise SystemExit(f"summary mismatch for {filename}: {key}")
        if summary["kissat_distribution"] != distribution(direct):
            raise SystemExit(f"distribution mismatch for {filename}: Kissat")
        if summary["ergodis_distribution"] != distribution(portfolio):
            raise SystemExit(f"distribution mismatch for {filename}: Ergodis")
        direct_rss = [int(case["kissat"][index]["peak_rss_kb"] or 0) for index in range(rounds)]
        portfolio_rss = [
            int(case["ergodis"][index]["peak_rss_kb"] or 0) for index in range(rounds)
        ]
        if summary["kissat_rss_distribution"] != rss_distribution(direct_rss):
            raise SystemExit(f"RSS distribution mismatch for {filename}: Kissat")
        if summary["ergodis_rss_distribution"] != rss_distribution(portfolio_rss):
            raise SystemExit(f"RSS distribution mismatch for {filename}: Ergodis")
        if summary["kissat_peak_rss_kb"] != max(direct_rss):
            raise SystemExit(f"peak RSS mismatch for {filename}: Kissat")
        if summary["ergodis_peak_rss_kb"] != max(portfolio_rss):
            raise SystemExit(f"peak RSS mismatch for {filename}: Ergodis")
    if records:
        raise SystemExit("raw evidence has instances absent from summary")
    if raw_sequence != expected_sequence:
        raise SystemExit("raw execution order does not match rotated interleave")
    if document["paired_instances"] != len(suite_logs):
        raise SystemExit("paired instance count mismatch")
    suite_speedup = math.exp(statistics.mean(suite_logs)) if suite_logs else None
    if not close(document["suite_geometric_mean_speedup"], suite_speedup):
        raise SystemExit("suite speedup mismatch")
    if not close(document["suite_instance_log_t"], t_score(suite_logs)):
        raise SystemExit("suite t-score mismatch")
    speedup_text = "none" if suite_speedup is None else f"{suite_speedup:.6g}x"
    print(
        f"ok: {len(suite_logs)}/{document['selected_instances']} paired; "
        f"speedup={speedup_text}; t={t_score(suite_logs)}"
    )


if __name__ == "__main__":
    main()
