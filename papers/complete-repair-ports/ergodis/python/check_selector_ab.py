#!/usr/bin/env python3
"""Fail-closed replay of the C985 dense/sparse selector A/B evidence."""

from __future__ import annotations

import json
import math
import statistics
import sys
from pathlib import Path


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "evidence/c985-selector-ab.json")
    rows = json.loads(path.read_text())
    assert [row["terms"] for row in rows] == [32, 313, 1563, 3125]
    for row in rows:
        dense = row["dense_ns"]
        sparse = row["sparse_ns"]
        assert len(dense) == len(sparse) >= 30
        assert all(value > 0 and math.isfinite(value) for value in dense + sparse)
        assert row["coefficient_slots"] == 3125
        assert math.isclose(row["density"], row["terms"] / 3125)
        assert row["dense_bytes"] == 3125 + 5
        assert row["sparse_bytes"] == 8 * row["terms"] + 5
        logs = [math.log(left / right) for left, right in zip(dense, sparse)]
        mean = statistics.fmean(logs)
        variance = statistics.variance(logs)
        speedup = math.exp(mean)
        t_score = mean / math.sqrt(variance / len(logs))
        assert math.isclose(speedup, row["geometric_mean_speedup"], rel_tol=1e-12)
        assert math.isclose(t_score, row["paired_log_t_score"], rel_tol=1e-12)
    assert all(row["geometric_mean_speedup"] > 1 for row in rows[:-1])
    assert rows[-1]["geometric_mean_speedup"] < 1
    print(f"verified {len(rows)} dense/sparse selector A/B records from {path}")


if __name__ == "__main__":
    main()
