#!/usr/bin/env python3
"""Replay the consuming GL quotient A/B statistics."""

from __future__ import annotations

import json
import math
import statistics
import sys
from pathlib import Path


def paired(baseline: list[float], optimized: list[float]) -> tuple[float, float]:
    logs = [math.log(left / right) for left, right in zip(baseline, optimized)]
    mean = statistics.fmean(logs)
    variance = statistics.variance(logs)
    return math.exp(mean), mean / math.sqrt(variance / len(logs))


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "evidence/c985-gl-consuming-ab.json")
    row = json.loads(path.read_text())
    assert (row["rows"], row["columns"], row["points"], row["orbits"], row["contexts"]) == (
        3,
        6,
        262144,
        2110,
        3,
    )
    generic = row["generic_ns"]
    naive = row["naive_rref_ns"]
    theorem = row["theorem_rref_ns"]
    assert len(generic) == len(naive) == len(theorem) >= 30
    assert all(value > 0 and math.isfinite(value) for value in generic + naive + theorem)
    generic_stats = paired(generic, theorem)
    naive_stats = paired(naive, theorem)
    assert math.isclose(generic_stats[0], row["theorem_vs_generic_speedup"], rel_tol=1e-12)
    assert math.isclose(generic_stats[1], row["theorem_vs_generic_paired_log_t"], rel_tol=1e-12)
    assert math.isclose(naive_stats[0], row["theorem_vs_naive_rref_speedup"], rel_tol=1e-12)
    assert math.isclose(naive_stats[1], row["theorem_vs_naive_rref_paired_log_t"], rel_tol=1e-12)
    assert generic_stats[0] > 1 and naive_stats[0] > 1
    print(f"verified consuming GL quotient A/B record from {path}")


if __name__ == "__main__":
    main()
