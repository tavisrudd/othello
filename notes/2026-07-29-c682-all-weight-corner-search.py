#!/usr/bin/env python3
"""Parallel modular search for later C682 three-return corner failures."""

from __future__ import annotations

import argparse
import importlib.util
import json
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-all-weight-corner-search.json"
PRIME = 1_000_000_007
EXPECTED = {
    80: 110,
    81: 113,
    82: 116,
    86: 127,
    90: 139,
    91: 142,
    92: 145,
    100: 171,
    101: 174,
    102: 178,
    106: 192,
    110: 206,
    111: 210,
    112: 214,
}


def load_base():
    spec = importlib.util.spec_from_file_location("corner_search_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load modular corner engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def candidate_degrees(start: int, stop: int) -> list[int]:
    base = load_base()
    candidates = []
    for degree in range(start, stop + 1):
        lower = base.mckay_decomposition(degree - 6) if degree >= 6 else {}
        current = base.mckay_decomposition(degree)
        upper = base.mckay_decomposition(degree + 6)
        if any(
            multiplicity >= 2
            and multiplicity
            > max(lower.get(module, 0), upper.get(module, 0))
            for module, multiplicity in current.items()
        ):
            candidates.append(degree)
    return candidates


def classify_degree(arguments: tuple[int, int]) -> tuple[int, int, int]:
    degree, prime = arguments
    base = load_base()
    upward = [
        base.round_trip_operator(degree, 1, prime),
        base.round_trip_operator(degree, 2, prime),
    ]
    delta = base.delta_matrix(degree - 6, prime)
    downward = base.matrix_multiply(
        delta,
        base.adjoint(delta, degree - 6, prime),
        prime,
    )
    dimension = base.generated_algebra_dimension(
        upward + [downward],
        prime,
    )
    commutant = sum(
        multiplicity * multiplicity
        for multiplicity in base.mckay_decomposition(degree).values()
    )
    return degree, dimension, commutant


def classify(start: int, stop: int, workers: int, prime: int):
    candidates = candidate_degrees(start, stop)
    with ProcessPoolExecutor(max_workers=workers) as executor:
        return sorted(
            executor.map(
                classify_degree,
                [(degree, prime) for degree in candidates],
            )
        )


def certificate(workers: int, prime: int):
    rows = classify(73, 112, workers, prime)
    assert {degree: commutant for degree, _, commutant in rows} == EXPECTED
    assert all(dimension == commutant for _, dimension, commutant in rows)
    return {
        "schema": "c682-all-weight-corner-frontier-v1",
        "field": f"F_{prime}",
        "searched_domain": {
            "degrees": "73..112",
            "selection": (
                "strict local multiplicity peaks m(n)>=2 and "
                "m(n)>max(m(n-6),m(n+6))"
            ),
            "candidate_count": len(rows),
        },
        "rows": [
            {
                "degree": degree,
                "three_return_dimension": dimension,
                "commutant_dimension": commutant,
                "state": "saturated",
            }
            for degree, dimension, commutant in rows
        ],
        "eventual_peak_families": {
            "valid_from_degree": 60,
            "period": 60,
            "residues": [
                0,
                1,
                2,
                6,
                10,
                11,
                12,
                20,
                21,
                22,
                26,
                30,
                31,
                32,
                40,
                41,
                42,
                46,
                50,
                51,
                52,
            ],
            "owning_modules_by_residue_mod_20": {
                "0,12": "1",
                "1,11": "2",
                "2,10": "3",
                "6": "3p",
            },
            "base_representatives": (
                "60..112, combining the preceding degree-72 certificate "
                "with this search"
            ),
        },
        "conclusion": (
            "Every strict-peak family has a saturated base representative; "
            "all-weight saturation still requires nonvanishing along the "
            "60-step parameter."
        ),
        "claim_boundary": (
            "Only strict multiplicity peaks in degrees 73..112 are searched. "
            "No all-weight saturation claim is made."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--replay", action="store_true")
    parser.add_argument("--workers", type=int, default=4)
    parser.add_argument("--prime", type=int, default=PRIME)
    arguments = parser.parse_args()
    rendered = json.dumps(
        certificate(arguments.workers, arguments.prime),
        indent=2,
        sort_keys=True,
    ) + "\n"
    if arguments.replay:
        assert arguments.prime != PRIME
        print("PASS: C682 all-weight corner frontier replay")
    elif arguments.check:
        assert arguments.prime == PRIME
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 all-weight corner frontier")
    else:
        assert arguments.prime == PRIME
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
