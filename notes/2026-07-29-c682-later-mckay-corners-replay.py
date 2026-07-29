#!/usr/bin/env python3
"""Second-prime replay for the bounded C682 later-corner classification."""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY = HERE / "2026-07-29-c682-later-mckay-corners.py"
EXACT_BASE = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"
REPLAY_PRIME = 1_000_000_009


def load_primary():
    spec = importlib.util.spec_from_file_location("later_corner_primary", PRIMARY)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the later-corner classifier")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_exact_base():
    spec = importlib.util.spec_from_file_location("later_corner_exact", EXACT_BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the exact characteristic-zero engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def exact_early_repairs():
    base = load_exact_base()
    dimensions = {}
    for degree in (26, 30, 31):
        upward = [
            base.round_trip_operator(degree, 1),
            base.round_trip_operator(degree, 2),
        ]
        delta = base.delta_matrix(degree - 6)
        downward = base.matrix_multiply(
            delta,
            base.adjoint(delta, degree - 6),
        )
        dimensions[degree] = (
            base.generated_algebra_dimension(upward),
            base.generated_algebra_dimension(upward + [downward]),
        )
    return dimensions


def main() -> None:
    primary = load_primary()
    result = primary.classify(REPLAY_PRIME)
    assert result["classification"] == {
        "persistent_full_corner_failures": [22],
        "all_other_degrees_saturated_by_U1_U2_L1": "0..72 except 22",
        "later_repairs": [
            26,
            30,
            31,
            41,
            42,
            46,
            50,
            51,
            60,
            61,
            62,
            66,
            70,
            71,
            72,
        ],
    }
    assert exact_early_repairs() == {
        26: (11, 13),
        30: (15, 17),
        31: (16, 18),
    }
    print(
        "PASS: second-prime classification through degree 72 "
        "and exact early repairs"
    )


if __name__ == "__main__":
    main()
