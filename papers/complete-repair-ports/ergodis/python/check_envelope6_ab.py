#!/usr/bin/env python3
"""Replay the ambient-six rank-envelope A/B evidence."""

from __future__ import annotations

import json
import math
import statistics
import sys
from pathlib import Path


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "evidence/c985-envelope6-ab.json")
    row = json.loads(path.read_text())
    assert (
        row["ambient_dimension"],
        row["maximum_rank"],
        row["states"],
        row["restriction_edges"],
        row["contexts_per_batch"],
    ) == (6, 5, 2451, 19034, 32)
    cached = row["cached_query_ns"]
    envelope = row["envelope_query_ns"]
    lazy_first = row["lazy_first_batch_ns"]
    envelope_first = row["envelope_first_batch_ns"]
    assert len(cached) == len(envelope) == len(lazy_first) == len(envelope_first) >= 30
    assert all(
        value > 0 and math.isfinite(value)
        for values in (cached, envelope, lazy_first, envelope_first)
        for value in values
    )
    logs = [math.log(left / right) for left, right in zip(cached, envelope)]
    mean = statistics.fmean(logs)
    variance = statistics.variance(logs)
    speedup = math.exp(mean)
    t_score = mean / math.sqrt(variance / len(logs))
    assert math.isclose(speedup, row["query_geometric_mean_speedup"], rel_tol=1e-12)
    assert math.isclose(t_score, row["query_paired_log_t"], rel_tol=1e-12)
    assert speedup > 1
    print(f"verified ambient-six envelope A/B record from {path}")


if __name__ == "__main__":
    main()
