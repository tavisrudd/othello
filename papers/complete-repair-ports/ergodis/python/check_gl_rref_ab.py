#!/usr/bin/env python3
"""Fail-closed replay of the compact GL/RREF performance evidence."""

from __future__ import annotations

import json
import math
import statistics
import sys
from pathlib import Path


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "evidence/c985-gl-rref-ab.json")
    rows = json.loads(path.read_text())
    assert [(row["rows"], row["columns"]) for row in rows] == [(2, 8), (3, 6)]
    for row in rows:
        generic = row["generic_ns"]
        rref = row["rref_ns"]
        assert len(generic) == len(rref) >= 30
        assert all(value > 0 and math.isfinite(value) for value in generic + rref)
        assert row["points"] == 1 << (row["rows"] * row["columns"])
        bitmap_words = (row["points"] + 63) // 64
        superblocks = (bitmap_words + 7) // 8 + 1
        assert row["rref_bytes"] == bitmap_words * 8 + superblocks * 4
        logs = [math.log(left / right) for left, right in zip(generic, rref)]
        mean = statistics.fmean(logs)
        variance = statistics.variance(logs)
        speedup = math.exp(mean)
        t_score = mean / math.sqrt(variance / len(logs))
        assert math.isclose(speedup, row["geometric_mean_speedup"], rel_tol=1e-12)
        assert math.isclose(t_score, row["paired_log_t_score"], rel_tol=1e-12)
        assert speedup > 1.0
        assert row["generic_bytes"] > row["rref_bytes"]
    print(f"verified {len(rows)} GL/RREF A/B records from {path}")


if __name__ == "__main__":
    main()
