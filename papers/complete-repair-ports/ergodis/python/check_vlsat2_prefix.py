#!/usr/bin/env python3
"""Independently replay VLSAT-2 clique certificates and timing summaries."""

from __future__ import annotations

import argparse
import json
import math
import statistics
from collections import defaultdict
from pathlib import Path

from run_satcomp24_portfolio import distribution, sha256, t_score


def close(left: float | None, right: float | None) -> bool:
    if left is None or right is None:
        return left is right
    return math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)


def replay_clique(path: Path, certificate: dict[str, object]) -> None:
    clauses = []
    variables = declared_clauses = None
    with path.open() as source:
        for line in source:
            stripped = line.lstrip()
            if not stripped or stripped.startswith("c"):
                continue
            if stripped.startswith("p"):
                _, kind, variables_text, clauses_text = stripped.split()
                if kind != "cnf":
                    raise SystemExit(f"bad DIMACS header: {path}")
                variables = int(variables_text)
                declared_clauses = int(clauses_text)
                continue
            literals = [int(word) for word in stripped.split()]
            if not literals or literals[-1] != 0:
                raise SystemExit(f"bad DIMACS clause: {path}")
            clauses.append(literals[:-1])
    if variables is None or len(clauses) != declared_clauses:
        raise SystemExit(f"bad DIMACS counts: {path}")
    positive = [clause for clause in clauses if all(literal > 0 for literal in clause)]
    colors = max(map(len, positive))
    if variables % colors:
        raise SystemExit(f"bad direct-coloring dimensions: {path}")
    vertices = variables // colors
    domains = [set() for _ in range(vertices)]
    conflicts = set()
    for clause in clauses:
        if all(literal > 0 for literal in clause):
            vertex = (clause[0] - 1) // colors
            domains[vertex].update((literal - 1) % colors for literal in clause)
        elif len(clause) == 2 and clause[0] < 0 and clause[1] < 0:
            left = (-clause[0] - 1) // colors
            right = (-clause[1] - 1) // colors
            color = (-clause[0] - 1) % colors
            if (-clause[1] - 1) % colors != color:
                raise SystemExit(f"non-color conflict: {path}")
            conflicts.add((min(left, right), max(left, right), color))
        else:
            raise SystemExit(f"non-coloring clause: {path}")
    clique = [int(vertex) for vertex in certificate["clique_vertices"]]
    if (
        certificate["variables"] != variables
        or certificate["clauses"] != declared_clauses
        or certificate["vertices"] != vertices
        or certificate["colors"] != colors
        or len(clique) <= colors
        or len(set(clique)) != len(clique)
        or any(vertex < 0 or vertex >= vertices for vertex in clique)
    ):
        raise SystemExit(f"invalid certificate metadata: {path}")
    for position, left in enumerate(clique):
        for right in clique[position + 1 :]:
            for color in domains[left] & domains[right]:
                if (min(left, right), max(left, right), color) not in conflicts:
                    raise SystemExit(f"invalid clique edge: {path}")


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
    if document["schema"] != "ergodis-vlsat2-prefix-ab-v1":
        raise SystemExit("unexpected evidence schema")
    if document["method"]["canonical_host"] and not document["host"][
        "stable_frequency_policy"
    ]:
        raise SystemExit("canonical evidence records an unstable frequency policy")
    artifacts = document["artifacts"]
    expected_hashes = {
        "manifest_sha256": sha256(args.manifest),
        "raw_jsonl_sha256": sha256(args.raw_jsonl),
        "runner_sha256": sha256(Path(__file__).with_name("run_vlsat2_prefix.py")),
        "checker_sha256": sha256(Path(__file__)),
        "process_runner_sha256": sha256(
            Path(__file__).with_name("run_satcomp24_portfolio.py")
        ),
        "ergodis_sha256": sha256(args.ergodis),
        "kissat_sha256": sha256(args.kissat),
    }
    for key, expected in expected_hashes.items():
        if artifacts.get(key) != expected:
            raise SystemExit(f"artifact hash mismatch: {key}")
    if manifest["builder_sha256"] != sha256(
        Path(__file__).with_name("build_vlsat2_prefix_manifest.py")
    ):
        raise SystemExit("manifest builder hash mismatch")

    records: dict[str, dict[str, list[dict[str, object]]]] = defaultdict(
        lambda: defaultdict(list)
    )
    with args.raw_jsonl.open() as source:
        for line in source:
            record = json.loads(line)
            records[record["instance"]][record["solver"]].append(record)
    manifest_entries = {entry["filename"]: entry for entry in manifest["instances"]}
    if set(manifest_entries) != {entry["filename"] for entry in document["instances"]}:
        raise SystemExit("manifest/evidence instance mismatch")

    certified = paired = censored = 0
    for summary in document["instances"]:
        filename = summary["filename"]
        entry = manifest_entries[filename]
        if summary["expected"] != entry["expected"]:
            raise SystemExit(f"expected-result mismatch: {filename}")
        cnf = args.cache_dir / filename
        if sha256(cnf) != summary["cnf_sha256"]:
            raise SystemExit(f"CNF hash mismatch: {filename}")
        case = records.pop(filename, None)
        if case is None or set(case) != {"ergodis", "kissat"}:
            raise SystemExit(f"missing raw records: {filename}")
        ergodis = sorted(case["ergodis"], key=lambda record: record["round"])
        kissat = sorted(case["kissat"], key=lambda record: record["round"])
        if len(ergodis) != document["method"]["ergodis_rounds"]:
            raise SystemExit(f"Ergodis round mismatch: {filename}")
        ergodis_ns = [int(record["elapsed_ns"]) for record in ergodis]
        if summary["ergodis_distribution"] != distribution(ergodis_ns):
            raise SystemExit(f"Ergodis distribution mismatch: {filename}")
        if entry["expected"] == "unsat":
            if any(record["status"] != "completed" or record["exit_code"] != 0 for record in ergodis):
                raise SystemExit(f"failed certificate process: {filename}")
            replay_clique(cnf, summary["certificate"])
            semantic = {
                key: value for key, value in json.loads(ergodis[0]["stdout_tail"]).items()
                if key != "elapsed_ns"
            }
            if any(
                {
                    key: value for key, value in json.loads(record["stdout_tail"]).items()
                    if key != "elapsed_ns"
                }
                != semantic
                for record in ergodis
            ):
                raise SystemExit(f"unstable certificate: {filename}")
            internal_ns = [
                int(json.loads(record["stdout_tail"])["elapsed_ns"]) for record in ergodis
            ]
            if summary["ergodis_internal_distribution"] != distribution(internal_ns):
                raise SystemExit(f"internal distribution mismatch: {filename}")
            expected_rate = (
                summary["ergodis_internal_distribution"]["median_ns"] / entry["clauses"]
            )
            if not close(summary["ergodis_internal_ns_per_clause"], expected_rate):
                raise SystemExit(f"internal rate mismatch: {filename}")
            certified += 1
        elif summary["certificate"] is not None or any(record["exit_code"] == 0 for record in ergodis):
            raise SystemExit(f"false certificate: {filename}")

        completed = [record for record in kissat if record["status"] == "completed"]
        if summary["kissat_status"] == "timeout":
            if not any(record["status"] == "timeout" for record in kissat):
                raise SystemExit(f"missing timeout: {filename}")
            if entry["expected"] == "unsat":
                expected = (
                    document["method"]["timeout_s"]
                    * 1_000_000_000
                    / summary["ergodis_distribution"]["median_ns"]
                )
                if not close(summary["speedup_lower_bound"], expected):
                    raise SystemExit(f"lower-bound mismatch: {filename}")
                censored += 1
        else:
            if len(completed) != document["method"]["kissat_rounds"]:
                raise SystemExit(f"Kissat round mismatch: {filename}")
            expected_code = 20 if entry["expected"] == "unsat" else 10
            if any(record["exit_code"] != expected_code for record in completed):
                raise SystemExit(f"Kissat semantic mismatch: {filename}")
            kissat_ns = [int(record["elapsed_ns"]) for record in completed]
            if summary["kissat_distribution"] != distribution(kissat_ns):
                raise SystemExit(f"Kissat distribution mismatch: {filename}")
            expected_rate = summary["kissat_distribution"]["median_ns"] / entry["clauses"]
            if not close(summary["kissat_process_ns_per_clause"], expected_rate):
                raise SystemExit(f"Kissat rate mismatch: {filename}")
            if entry["expected"] == "unsat":
                logs = [
                    math.log(kissat_ns[index] / ergodis_ns[index])
                    for index in range(len(kissat_ns))
                ]
                if not close(
                    summary["paired_geometric_mean_speedup"],
                    math.exp(statistics.mean(logs)),
                ) or not close(summary["paired_log_t"], t_score(logs)):
                    raise SystemExit(f"paired statistic mismatch: {filename}")
                paired += 1
    if records:
        raise SystemExit("raw records contain unknown instances")
    print(f"ok: certified={certified}; paired={paired}; censored={censored}")


if __name__ == "__main__":
    main()
