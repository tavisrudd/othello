#!/usr/bin/env python3
"""Explore and certify the C814 Golden continuous-control frontier."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-08-02-c814-continuous-frontier.json"
CHECKSUMS = ROOT / "notes" / "2026-08-02-c814-continuous-frontier.sha256"
REPLAY = ROOT / "notes" / "2026-08-02-c814-continuous-frontier-replay.py"


def pfaffian(matrix: list[list[float]], indices: tuple[int, ...]) -> float:
    if not indices:
        return 1.0
    first = indices[0]
    total = 0.0
    for position in range(1, len(indices)):
        second = indices[position]
        sign = 1.0 if position % 2 else -1.0
        rest = indices[1:position] + indices[position + 1 :]
        total += sign * matrix[first][second] * pfaffian(matrix, rest)
    return total


def invariants_float(x: tuple[float, ...]) -> dict[str, float]:
    # L=[D_x,C]/sqrt(5).  The positive eigenvalues of -L^2/4 are the
    # squared singular values of the Golden cross block.
    root5 = 5.0**0.5
    commutator = [
        [BASE_C[i][j] * (x[i] - x[j]) / root5 for j in range(6)]
        for i in range(6)
    ]
    square = [
        [
            sum(commutator[i][k] * commutator[k][j] for k in range(6))
            for j in range(6)
        ]
        for i in range(6)
    ]
    p1 = -sum(square[i][i] for i in range(6)) / 8.0
    p2 = sum(square[i][j] * square[j][i] for i in range(6) for j in range(6)) / 32.0
    exterior = pfaffian(commutator, tuple(range(6))) ** 2 / 64.0
    symmetric = exterior + p1 * p2
    mixed = p1 * (p1 * p1 - p2) / 2.0 - exterior
    return {
        "p1": p1,
        "p2": p2,
        "exterior": exterior,
        "symmetric": symmetric,
        "mixed": mixed,
    }


def matrix_product(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(6)) for j in range(6)]
        for i in range(6)
    ]


def pfaffian_int(matrix: list[list[int]], indices: tuple[int, ...]) -> int:
    if not indices:
        return 1
    first = indices[0]
    total = 0
    for position in range(1, len(indices)):
        second = indices[position]
        sign = 1 if position % 2 else -1
        rest = indices[1:position] + indices[position + 1 :]
        total += sign * matrix[first][second] * pfaffian_int(matrix, rest)
    return total


def invariants_exact(x: tuple[int, ...]) -> dict[str, Fraction]:
    commutator = [
        [BASE_C[i][j] * (x[i] - x[j]) for j in range(6)]
        for i in range(6)
    ]
    square = matrix_product(commutator, commutator)
    fourth = matrix_product(square, square)
    p1 = Fraction(-sum(square[i][i] for i in range(6)), 40)
    p2 = Fraction(sum(fourth[i][i] for i in range(6)), 800)
    exterior = Fraction(pfaffian_int(commutator, tuple(range(6))) ** 2, 8000)
    exterior2 = (p1 * p1 - p2) / 2
    symmetric = exterior + p1 * p2
    mixed = p1 * exterior2 - exterior
    return {
        "p1": p1,
        "p2": p2,
        "exterior2": exterior2,
        "exterior3": exterior,
        "symmetric3": symmetric,
        "mixed21": mixed,
    }


def boolean_profiles() -> list[dict[str, object]]:
    profiles: dict[int, dict[str, Fraction]] = {}
    for negative_size in range(4):
        x = tuple(-1 if i < negative_size else 1 for i in range(6))
        profiles[negative_size] = invariants_exact(x)
    return [
        {
            "negative_support_size": size,
            **{key: str(value) for key, value in values.items()},
        }
        for size, values in sorted(profiles.items())
    ]


def generate_certificate() -> dict[str, object]:
    matrix = [list(row) for row in BASE_C]
    square = matrix_product(matrix, matrix)
    assert square == [
        [5 if i == j else 0 for j in range(6)] for i in range(6)
    ]

    all_vertices = []
    for x in itertools.product((-1, 1), repeat=6):
        values = invariants_exact(x)
        all_vertices.append((x, values))

    maxima = {}
    for key in (
        "p1",
        "p2",
        "exterior2",
        "exterior3",
        "symmetric3",
        "mixed21",
    ):
        maximum = max(values[key] for _, values in all_vertices)
        witnesses = [x for x, values in all_vertices if values[key] == maximum]
        maxima[key] = {
            "value": str(maximum),
            "witness_count": len(witnesses),
            "support_sizes": sorted({sum(value < 0 for value in x) for x in witnesses}),
        }

    return {
        "schema": "c814-golden-continuous-frontier-v1",
        "conference_order": 6,
        "conference_square": 5,
        "control_domain": "[-1,1]^6",
        "boolean_vertex_count": len(all_vertices),
        "boolean_profiles_up_to_complement": boolean_profiles(),
        "boolean_maxima": maxima,
        "mixed_sector_lemma": {
            "hypotheses": [
                "0 <= lambda_i <= 1",
                "e1 <= 9/5",
                "e2 <= 24/25",
            ],
            "conclusion": "s_(2,1)=e1*e2-e3 <= 8/5",
            "active_e1_case_factors": [
                "(5*c-1)*(25*c^2+50*c-71)/500 on 0<=c<=1/5",
                "(5*c-4)^2*(5*c-1)/125 on 1/5<=c<=3/5",
            ],
            "equality_spectrum": ["1/5", "4/5", "4/5"],
        },
    }


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


def checksum_text(paths: tuple[Path, ...]) -> str:
    lines = []
    for path in paths:
        sha256, byte_count = digest(path)
        lines.append(f"{sha256}  {byte_count}  {path.name}")
    return "\n".join(lines) + "\n"


def write_certificate() -> None:
    OUTPUT.write_text(json.dumps(generate_certificate(), indent=2, sort_keys=True) + "\n")
    CHECKSUMS.write_text(checksum_text((Path(__file__), REPLAY, OUTPUT)))


def check_certificate() -> None:
    expected = json.loads(OUTPUT.read_text())
    assert generate_certificate() == expected
    assert CHECKSUMS.read_text() == checksum_text((Path(__file__), REPLAY, OUTPUT))
    print("C814 continuous-frontier certificate: PASS")


def explore(seed: int) -> None:
    import scipy.optimize  # type: ignore[import-not-found]

    objectives = ("p1", "p2", "exterior", "symmetric", "mixed")
    output: dict[str, object] = {"seed": seed, "boolean_profiles": boolean_profiles()}
    maxima: dict[str, object] = {}
    for offset, objective in enumerate(objectives):
        result = scipy.optimize.differential_evolution(
            lambda point: -invariants_float(tuple(float(v) for v in point))[objective],
            bounds=[(-1.0, 1.0)] * 6,
            seed=seed + offset,
            tol=1e-10,
            polish=True,
            workers=1,
        )
        maxima[objective] = {
            "value": -float(result.fun),
            "point": [float(value) for value in result.x],
            "success": bool(result.success),
        }
    output["exploratory_maxima"] = maxima
    print(json.dumps(output, indent=2, sort_keys=True))


def symbolic_curvature() -> None:
    import sympy as sp  # type: ignore[import-not-found]

    x = sp.symbols("x0:6", real=True)
    commutator = sp.Matrix(
        6, 6, lambda i, j: BASE_C[i][j] * (x[i] - x[j])
    )
    square = commutator * commutator
    p1 = -sp.trace(square) / 40
    p2 = sp.trace(square * square) / 800
    def pfaffian_symbolic(indices: tuple[int, ...]) -> sp.Expr:
        if not indices:
            return sp.Integer(1)
        first = indices[0]
        total = sp.Integer(0)
        for position in range(1, len(indices)):
            second = indices[position]
            sign = 1 if position % 2 else -1
            rest = indices[1:position] + indices[position + 1 :]
            total += (
                sign
                * commutator[first, second]
                * pfaffian_symbolic(rest)
            )
        return sp.expand(total)

    pfaff = pfaffian_symbolic(tuple(range(6)))
    exterior = pfaff**2 / 8000
    symmetric = exterior + p1 * p2
    mixed = p1 * (p1 * p1 - p2) / 2 - exterior
    for name, expression in (
        ("p1", p1),
        ("p2", p2),
        ("exterior", exterior),
        ("symmetric", symmetric),
        ("mixed", mixed),
    ):
        curvature = sp.factor(sp.diff(expression, x[0], 2))
        print(f"{name}: {curvature}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--explore", action="store_true")
    parser.add_argument("--symbolic-curvature", action="store_true")
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--seed", type=int, default=814)
    args = parser.parse_args()
    if args.write:
        write_certificate()
    elif args.check:
        check_certificate()
    elif args.symbolic_curvature:
        symbolic_curvature()
    elif args.explore:
        explore(args.seed)
    else:
        print(json.dumps({"boolean_profiles": boolean_profiles()}, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
