#!/usr/bin/env python3
"""Independently recompute aggregate claims in weighted-trace evidence."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def close(left: float, right: float) -> bool:
    return math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)


def aggregate(values: list[float]) -> tuple[float, float]:
    logs = [math.log(value) for value in values]
    mean = statistics.fmean(logs)
    t_score = mean / math.sqrt(statistics.variance(logs) / len(logs))
    return math.exp(mean), t_score


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    parser.add_argument("--ergodis-driver", type=Path)
    parser.add_argument("--mata-driver", type=Path)
    parser.add_argument("--z3-script", type=Path)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    assert document["schema"] == "ergodis-z3-weighted-trace-suite-v1"
    assert document["attempted_instances"] == document["recorded_instances"] + len(
        document["failures"]
    )
    assert document["attempted_instances"] > 1
    indexes = [item["official_index"] for item in document["instances"] + document["failures"]]
    assert len(indexes) == len(set(indexes))

    expected_rounds = document["method"]["rounds"]
    paired = []
    for record in document["instances"]:
        ergodis_rounds = record["ergodis_rounds"]
        z3_rounds = record["z3_rounds"]
        for ergodis in ergodis_rounds:
            assert ergodis["status"] == "optimal"
            assert ergodis["collapsed_edges"] <= ergodis["uncollapsed_edges"]
        for z3_result in z3_rounds:
            assert z3_result["collapsed_edges"] <= z3_result["uncollapsed_edges"]
            if z3_result["status"] == "optimal":
                assert z3_result["optimum"] == z3_result["oracle_optimum"]
        if "total_speedup" not in record:
            continue
        assert record["status"] == "optimal"
        assert len(ergodis_rounds) == len(z3_rounds) == expected_rounds
        ergodis_total = [
            item["compile_ns"] + item["plan_ns"] + item["query_ns"]
            for item in ergodis_rounds
        ]
        z3_total = [item["build_ns"] + item["solve_ns"] for item in z3_rounds]
        total_ratios = [
            right / left for left, right in zip(ergodis_total, z3_total, strict=True)
        ]
        query_ratios = [
            z3_item["solve_ns"] / ergodis_item["query_ns"]
            for ergodis_item, z3_item in zip(ergodis_rounds, z3_rounds, strict=True)
        ]
        total_speedup, total_t = aggregate(total_ratios)
        query_speedup, query_t = aggregate(query_ratios)
        assert close(record["total_speedup"], total_speedup)
        assert close(record["total_paired_log_t"], total_t)
        assert close(record["query_speedup"], query_speedup)
        assert close(record["query_paired_log_t"], query_t)
        paired.append(record)

    assert len(paired) == document["paired_optimal_instances"]
    assert len(paired) > 1
    total_speedup, total_t = aggregate([record["total_speedup"] for record in paired])
    query_speedup, query_t = aggregate([record["query_speedup"] for record in paired])
    assert close(document["suite_total_geometric_mean_speedup"], total_speedup)
    assert close(document["suite_total_instance_log_t"], total_t)
    assert close(document["suite_query_geometric_mean_speedup"], query_speedup)
    assert close(document["suite_query_instance_log_t"], query_t)
    assert document["ergodis_total_wins"] + document["z3_total_wins"] <= len(paired)

    for option, key in (
        (args.ergodis_driver, "ergodis_driver_sha256"),
        (args.mata_driver, "mata_driver_sha256"),
        (args.z3_script, "z3_script_sha256"),
    ):
        if option is not None:
            assert sha256(option) == document["artifacts"][key]
    print(
        f"ok: {len(paired)}/{document['attempted_instances']} paired; "
        f"total {total_speedup:.6g}x (t={total_t:.6g}); "
        f"query {query_speedup:.6g}x (t={query_t:.6g})"
    )


if __name__ == "__main__":
    main()
