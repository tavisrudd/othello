#!/usr/bin/env python3
"""Exact q=5 control for the C756 normalized passant-pencil selector."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


Q = 5
D = 2
OUTPUT = Path(__file__).with_suffix(".json")
V = ((1, 0), (0, 4), (4, 3), (2, 1))


def add(x: tuple[int, int], y: tuple[int, int]) -> tuple[int, int]:
    return ((x[0] + y[0]) % Q, (x[1] + y[1]) % Q)


def sub(x: tuple[int, int], y: tuple[int, int]) -> tuple[int, int]:
    return ((x[0] - y[0]) % Q, (x[1] - y[1]) % Q)


def mul(x: tuple[int, int], y: tuple[int, int]) -> tuple[int, int]:
    return (
        (x[0] * y[0] + D * x[1] * y[1]) % Q,
        (x[0] * y[1] + x[1] * y[0]) % Q,
    )


def conjugate(x: tuple[int, int]) -> tuple[int, int]:
    return (x[0], (-x[1]) % Q)


def norm(x: tuple[int, int]) -> int:
    return (x[0] * x[0] - D * x[1] * x[1]) % Q


def inverse(x: tuple[int, int]) -> tuple[int, int]:
    inverse_norm = pow(norm(x), -1, Q)
    y = conjugate(x)
    return (y[0] * inverse_norm % Q, y[1] * inverse_norm % Q)


def divide(x: tuple[int, int], y: tuple[int, int]) -> tuple[int, int]:
    return mul(x, inverse(y))


def chi(value: int) -> int:
    value %= Q
    if value == 0:
        return 0
    return 1 if pow(value, (Q - 1) // 2, Q) == 1 else -1


def chi2(x: tuple[int, int]) -> int:
    return chi(norm(x))


def tau(x: tuple[int, int]) -> tuple[int, int]:
    return sub((1, 0), conjugate(x))


def direction(x: tuple[int, int]) -> tuple[int, int]:
    if x == (0, 0):
        raise ValueError("zero has no direction")
    if x[0]:
        scale = pow(x[0], -1, Q)
        return (1, x[1] * scale % Q)
    return (0, 1)


def projection(u: tuple[int, int], kernel: tuple[int, int]) -> int:
    numerator = sub(mul(u, conjugate(kernel)), mul(conjugate(u), kernel))
    value = divide(numerator, (0, 2))
    if value[1] != 0:
        raise AssertionError("projection did not land in F_q")
    return value[0]


def certificate() -> dict[str, object]:
    within = [
        chi2(sub(V[i], V[j]))
        for i in range(len(V))
        for j in range(i + 1, len(V))
    ]
    cross = [
        chi2(sub(V[i], tau(V[j])))
        for i in range(len(V))
        for j in range(len(V))
        if i != j
    ]
    if set(within) != {1} or set(cross) != {-1}:
        raise AssertionError("the normalized four-frame signs are wrong")

    seed = V[1:]
    directions = [direction(v) for v in seed]
    if len(set(directions)) != len(seed) or any(chi2(v) != -1 for v in seed):
        raise AssertionError("the seed is not a nonsquare-direction transversal")

    projection_rows = []
    for kernel in seed:
        values = [projection(u, kernel) for u in seed]
        nonzero = sorted(value for value in values if value)
        if len(nonzero) != 2 or len(set(nonzero)) != 2:
            raise AssertionError("bad balanced projection slice")
        complement = sorted(set(range(1, Q)) - set(nonzero))
        projection_rows.append(
            {
                "kernel": list(kernel),
                "values": values,
                "nonzero_roots": nonzero,
                "nonzero_root_characters": [chi(value) for value in nonzero],
                "complementary_roots": complement,
            }
        )

    if all(
        len(set(row["nonzero_root_characters"])) == 1
        for row in projection_rows
    ):
        raise AssertionError("the intended coset-collapse counterexample disappeared")

    return {
        "schema": "c756-normalized-pencil-selector-v1",
        "field": {"q": Q, "basis": "F_q[s]/(s^2-2)", "least_nonsquare": D},
        "normalized_points": [list(v) for v in V],
        "within_difference_characters": within,
        "cross_involution_characters": cross,
        "seed_directions": [list(value) for value in directions],
        "projection_rows": projection_rows,
        "claim": (
            "the genuine q=5 normalized four-frame has balanced projection "
            "slices, but at least one nonzero slice contains both character classes"
        ),
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    actual = serialized()
    if args.write:
        OUTPUT.write_text(actual, encoding="utf-8")
        return
    expected = OUTPUT.read_text(encoding="utf-8")
    if actual != expected:
        raise SystemExit("certificate mismatch: regenerate with --write")
    print("ok: normalized q=5 four-frame and three balanced projection slices")


if __name__ == "__main__":
    main()
