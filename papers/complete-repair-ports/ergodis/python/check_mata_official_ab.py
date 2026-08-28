#!/usr/bin/env python3
"""Check the official MATA/ergodis DFA minimization evidence."""

from __future__ import annotations

import json
import math
import statistics
import sys
from pathlib import Path


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "evidence/c985-mata-official-ab.json")
    document = json.loads(path.read_text())
    assert document["schema"] == "ergodis-mata-official-ab-v1"
    records = document["instances"]
    assert document["measured_instances"] == len(records) > 0
    assert document["attempted_instances"] == len(records) + len(document["skipped_instances"])
    instance_logs = []
    wins = 0
    for record in records:
        mata = record["mata_ns"]
        ergodis = record["ergodis_ns"]
        assert len(mata) == len(ergodis) == document["method"]["rounds"]
        logs = [math.log(left / right) for left, right in zip(mata, ergodis, strict=True)]
        mean = statistics.fmean(logs)
        speedup = math.exp(mean)
        t_score = mean / math.sqrt(statistics.variance(logs) / len(logs))
        assert math.isclose(speedup, record["ergodis_speedup"], rel_tol=1e-12)
        assert math.isclose(t_score, record["paired_log_t"], rel_tol=1e-12)
        assert record["ergodis_classes"] - record["mata_classes"] in (0, 1)
        instance_logs.append(mean)
        wins += speedup > 1
    suite_speedup = math.exp(statistics.fmean(instance_logs))
    suite_t = statistics.fmean(instance_logs) / math.sqrt(
        statistics.variance(instance_logs) / len(instance_logs)
    )
    assert math.isclose(suite_speedup, document["suite_geometric_mean_speedup"], rel_tol=1e-12)
    assert math.isclose(suite_t, document["suite_instance_log_t"], rel_tol=1e-12)
    assert wins == document["ergodis_wins"]
    print(f"verified {len(records)} official MATA-derived DFA comparisons from {path}")


if __name__ == "__main__":
    main()
