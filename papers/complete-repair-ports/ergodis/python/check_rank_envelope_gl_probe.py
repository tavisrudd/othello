#!/usr/bin/env python3
"""Check structural identities and derived Criterion ratios."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path


def gaussian_binary(dimension: int, rank: int) -> int:
    numerator = denominator = 1
    for index in range(rank):
        numerator *= (1 << (dimension - index)) - 1
        denominator *= (1 << (rank - index)) - 1
    return numerator // denominator


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    if document["schema"] != "ergodis-rank-envelope-gl-probe-v1":
        raise SystemExit("unexpected schema")
    measurements = document["measurements"]
    expected_samples = {
        name: 30 if name.startswith(("envelope_", "lazy_")) else 20
        for name in measurements
    }
    for name, measurement in measurements.items():
        if len(measurement["sample"]["times"]) != expected_samples[name]:
            raise SystemExit(f"sample count mismatch: {name}")
        if measurement["slope_ns"]["point_estimate"] <= 0:
            raise SystemExit(f"invalid slope: {name}")
    slope = lambda name: measurements[name]["slope_ns"]["point_estimate"]
    envelope = document["rank_envelope"]
    states = 1 + sum(
        gaussian_binary(5, rank) - gaussian_binary(4, rank - 1)
        for rank in range(1, 5)
    )
    edges = sum(
        (gaussian_binary(5, rank) - gaussian_binary(4, rank - 1))
        * ((1 << rank) - 1)
        for rank in range(1, 5)
    )
    if envelope["states"] != states or envelope["restriction_edges"] != edges:
        raise SystemExit("rank-envelope census mismatch")
    ratios = {
        "query_speedup": slope("envelope_cached_scan") / slope("envelope_lookup"),
        "first_batch_compile_ratio": slope("envelope_compile_16")
        / slope("lazy_compile_16"),
    }
    for field, value in ratios.items():
        if not math.isclose(envelope[field], value, rel_tol=1e-12):
            raise SystemExit(f"rank-envelope ratio mismatch: {field}")
    for name, rows, columns in (("rank2_width8", 2, 8), ("rank3_width6", 3, 6)):
        result = document["gl_probe"][name]
        expected_orbits = sum(gaussian_binary(columns, rank) for rank in range(rows + 1))
        if result["orbits"] != expected_orbits:
            raise SystemExit(f"GL orbit census mismatch: {name}")
        if not math.isclose(
            result["compression"], result["points"] / expected_orbits, rel_tol=1e-12
        ):
            raise SystemExit(f"GL compression mismatch: {name}")
    print("checked rank envelope and two binary GL probe instantiations")


if __name__ == "__main__":
    main()
