#!/usr/bin/env python3
"""Exact C814 order-six Hermitian conference rigidity certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-08-02-c814-complex-conference-rigidity.json"
CHECKSUMS = ROOT / "notes" / "2026-08-02-c814-complex-conference-rigidity.sha256"
REPLAY = ROOT / "notes" / "2026-08-02-c814-complex-conference-rigidity-replay.py"
VERTICES = tuple(range(5))
EDGES = tuple(itertools.combinations(VERTICES, 2))


def edge_index(i: int, j: int) -> int:
    return EDGES.index((min(i, j), max(i, j)))


def oriented_sign(signs: tuple[int, ...], i: int, j: int) -> int:
    value = signs[edge_index(i, j)]
    return value if i < j else -value


def symmetric_sign(signs: tuple[int, ...], i: int, j: int) -> int:
    return signs[edge_index(i, j)]


def real_patterns() -> tuple[tuple[int, ...], ...]:
    return tuple(
        signs
        for signs in itertools.product((-1, 1), repeat=len(EDGES))
        if all(
            sum(symmetric_sign(signs, i, j) for j in VERTICES if j != i) == 0
            for i in VERTICES
        )
    )


def imaginary_patterns() -> tuple[tuple[int, ...], ...]:
    return tuple(
        signs
        for signs in itertools.product((-1, 1), repeat=len(EDGES))
        if all(
            sum(oriented_sign(signs, i, j) for j in VERTICES if j != i) == 0
            for i in VERTICES
        )
    )


def interior_candidate(
    real_signs: tuple[int, ...], imaginary_signs: tuple[int, ...]
) -> tuple[str, Fraction | None]:
    candidate: Fraction | None = None
    for i, j in EDGES:
        constant = 0
        slope = 0
        imaginary_coefficient = 0
        for k in VERTICES:
            if k in (i, j):
                continue
            a1 = symmetric_sign(real_signs, i, k)
            a2 = symmetric_sign(real_signs, k, j)
            b1 = oriented_sign(imaginary_signs, i, k)
            b2 = oriented_sign(imaginary_signs, k, j)
            constant -= b1 * b2
            slope += a1 * a2 + b1 * b2
            imaginary_coefficient += a1 * b2 + b1 * a2
        if imaginary_coefficient:
            return "nonzero_offdiagonal_imaginary_part", None
        if slope == 0:
            if constant != -1:
                return "inconsistent_offdiagonal_real_part", None
        else:
            value = Fraction(-1 - constant, slope)
            if candidate is None:
                candidate = value
            elif candidate != value:
                return "inconsistent_parameter", None
    if candidate is None or not 0 < candidate < 1:
        return "no_interior_parameter", candidate

    for i, j, k in itertools.combinations(VERTICES, 3):
        a1 = symmetric_sign(real_signs, i, j)
        a2 = symmetric_sign(real_signs, j, k)
        a3 = symmetric_sign(real_signs, k, i)
        b1 = oriented_sign(imaginary_signs, i, j)
        b2 = oriented_sign(imaginary_signs, j, k)
        b3 = oriented_sign(imaginary_signs, k, i)
        mixed = a1 * b2 * b3 + b1 * a2 * b3 + b1 * b2 * a3
        normalized_real_holonomy = (
            (a1 * a2 * a3 + mixed) * candidate - mixed
        )
        if normalized_real_holonomy * normalized_real_holonomy != 1:
            return "nonuniform_triangle_holonomy", candidate
    return "survivor", candidate


def purely_imaginary_survivors(
    patterns: tuple[tuple[int, ...], ...]
) -> int:
    survivors = 0
    for signs in patterns:
        if all(
            sum(
                oriented_sign(signs, i, k) * oriented_sign(signs, k, j)
                for k in VERTICES
                if k not in (i, j)
            )
            == 1
            for i, j in EDGES
        ):
            survivors += 1
    return survivors


def generate_certificate() -> dict[str, object]:
    real = real_patterns()
    imaginary = imaginary_patterns()
    rejection_counts: dict[str, int] = {}
    interior_parameters = set()
    survivors = []
    for real_signs in real:
        for imaginary_signs in imaginary:
            reason, parameter = interior_candidate(real_signs, imaginary_signs)
            rejection_counts[reason] = rejection_counts.get(reason, 0) + 1
            if parameter is not None and 0 < parameter < 1:
                interior_parameters.add(parameter)
            if reason == "survivor":
                survivors.append((real_signs, imaginary_signs, parameter))

    assert len(real) == 12
    assert len(imaginary) == 24
    assert sum(rejection_counts.values()) == 288
    assert not survivors
    assert purely_imaginary_survivors(imaginary) == 0

    return {
        "schema": "c814-complex-conference-rigidity-v1",
        "order": 6,
        "dephased_remainder_order": 5,
        "real_row_balance_patterns": len(real),
        "regular_tournament_patterns": len(imaginary),
        "interior_pattern_pairs_checked": len(real) * len(imaginary),
        "interior_candidate_parameters": [str(value) for value in sorted(interior_parameters)],
        "interior_rejection_counts": dict(sorted(rejection_counts.items())),
        "interior_survivors": len(survivors),
        "purely_imaginary_survivors": purely_imaginary_survivors(imaginary),
        "real_endpoint": {
            "uniform": True,
            "balanced_squared_singular_spectrum": ["1/5", "4/5", "4/5"],
        },
        "ettaoui_b_i_counterexample": {
            "cut_012_real_holonomy": "-1",
            "cut_013_real_holonomy": "0",
            "cut_012_squared_singular_spectrum": ["1/5", "4/5", "4/5"],
            "cut_013_squared_singular_spectrum": ["2/5", "2/5", "1"],
            "common_p1": "9/5",
            "common_p2": "33/25",
            "exterior3_values": ["16/125", "4/25"],
        },
        "balanced_cut_formulas": {
            "parameter": "r=Re(c_ij*c_jk*c_ki)",
            "p1": "9/5",
            "p2": "33/25",
            "exterior2": "24/25",
            "exterior3": "4*(5-r^2)/125",
            "symmetric3": "(317-4*r^2)/125",
            "mixed21": "(196+4*r^2)/125",
        },
    }


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


def checksum_text(paths: tuple[Path, ...]) -> str:
    return "".join(
        f"{digest(path)[0]}  {digest(path)[1]}  {path.name}\n" for path in paths
    )


def write_certificate() -> None:
    OUTPUT.write_text(json.dumps(generate_certificate(), indent=2, sort_keys=True) + "\n")
    CHECKSUMS.write_text(checksum_text((Path(__file__), REPLAY, OUTPUT)))


def check_certificate() -> None:
    assert json.loads(OUTPUT.read_text()) == generate_certificate()
    assert CHECKSUMS.read_text() == checksum_text((Path(__file__), REPLAY, OUTPUT))
    print("C814 complex-conference rigidity certificate: PASS")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write:
        write_certificate()
    elif args.check:
        check_certificate()
    else:
        print(json.dumps(generate_certificate(), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
