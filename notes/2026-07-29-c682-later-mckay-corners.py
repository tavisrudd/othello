#!/usr/bin/env python3
"""Bounded exact-rank certificate for later C682 McKay corners."""

from __future__ import annotations

import argparse
import importlib.util
import json
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent
MODULAR_BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-later-mckay-corners.json"
PRIME = 1_000_000_007
MAXIMUM_DEGREE = 72
EXPECTED_TWO_UP_DEFICITS = (
    22,
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
)


def load_base():
    spec = importlib.util.spec_from_file_location("later_corner_base", MODULAR_BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the independent modular operator engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def classify(prime: int) -> dict[str, object]:
    base = load_base()

    @lru_cache(maxsize=None)
    def delta(degree: int):
        return base.delta_matrix(degree, prime)

    @lru_cache(maxsize=None)
    def adjoint(degree: int):
        return base.adjoint(delta(degree), degree, prime)

    def upward_return(degree: int, steps: int):
        current_degree = degree
        operator = base.identity(degree + 1)
        traversed = []
        for _ in range(steps):
            traversed.append(current_degree)
            operator = base.matrix_multiply(
                delta(current_degree),
                operator,
                prime,
            )
            current_degree += 6
        for source_degree in reversed(traversed):
            operator = base.matrix_multiply(
                adjoint(source_degree),
                operator,
                prime,
            )
        return operator

    def downward_return(degree: int):
        if degree < 6:
            return None
        source_degree = degree - 6
        return base.matrix_multiply(
            delta(source_degree),
            adjoint(source_degree),
            prime,
        )

    deficits = []
    saturated_degrees = []
    for degree in range(MAXIMUM_DEGREE + 1):
        decomposition = base.mckay_decomposition(degree)
        commutant_dimension = sum(
            multiplicity * multiplicity
            for multiplicity in decomposition.values()
        )
        upward_generators = [
            upward_return(degree, 1),
            upward_return(degree, 2),
        ]
        two_up_dimension = base.generated_algebra_dimension(
            upward_generators,
            prime,
        )
        repaired_dimension = two_up_dimension
        lower = downward_return(degree)
        if lower is not None and two_up_dimension < commutant_dimension:
            repaired_dimension = base.generated_algebra_dimension(
                upward_generators + [lower],
                prime,
            )
        if two_up_dimension < commutant_dimension:
            deficits.append(
                {
                    "degree": degree,
                    "decomposition": decomposition,
                    "commutant_dimension": commutant_dimension,
                    "two_up_dimension": two_up_dimension,
                    "with_down_dimension": repaired_dimension,
                    "repair": (
                        "persistent"
                        if repaired_dimension < commutant_dimension
                        else "repaired_by_nearest_down_return"
                    ),
                }
            )
        if repaired_dimension == commutant_dimension:
            saturated_degrees.append(degree)

    deficit_degrees = tuple(row["degree"] for row in deficits)
    assert deficit_degrees == EXPECTED_TWO_UP_DEFICITS
    persistent = [
        row["degree"]
        for row in deficits
        if row["with_down_dimension"] < row["commutant_dimension"]
    ]
    assert persistent == [22]
    assert saturated_degrees == [
        degree for degree in range(MAXIMUM_DEGREE + 1) if degree != 22
    ]

    return {
        "schema": "c682-later-mckay-corners-v1",
        "field": f"F_{prime}",
        "degree_domain": f"0..{MAXIMUM_DEGREE}",
        "operator": "Delta=(.,Phi_12)_3 with Fischer adjoint",
        "generators": {
            "U1": "Delta^dagger Delta",
            "U2": "(Delta^dagger)^2 Delta^2",
            "L1": "Delta_(n-6) Delta_(n-6)^dagger",
        },
        "two_up_deficits": deficits,
        "classification": {
            "persistent_full_corner_failures": [22],
            "all_other_degrees_saturated_by_U1_U2_L1": (
                f"0..{MAXIMUM_DEGREE} except 22"
            ),
            "later_repairs": [
                degree
                for degree in EXPECTED_TWO_UP_DEFICITS
                if degree != 22
            ],
        },
        "rank_transfer": (
            "A modular word-span rank equal to the characteristic-zero "
            "commutant upper bound proves characteristic-zero saturation."
        ),
        "claim_boundary": (
            "The exhaustive degree domain stops at 72. No assertion that "
            "degree 22 is the unique failure in all weights is made."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(classify(PRIME), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 later McKay corners through degree 72")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
