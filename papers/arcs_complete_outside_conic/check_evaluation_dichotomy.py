#!/usr/bin/env python3
"""Exhaust the sharp hyperplane-union boundary in small prime fields."""

from __future__ import annotations

from itertools import combinations, product
import json


def inv(x: int, q: int) -> int:
    return pow(x % q, -1, q)


def normalize(v: tuple[int, ...], q: int) -> tuple[int, ...]:
    pivot = next(x for x in v if x % q)
    z = inv(pivot, q)
    return tuple(z * x % q for x in v)


def projective_functionals(q: int, dimension: int) -> tuple[tuple[int, ...], ...]:
    return tuple(sorted({
        normalize(v, q)
        for v in product(range(q), repeat=dimension)
        if any(v)
    }))


def kernel(functional: tuple[int, ...], vectors: tuple[tuple[int, ...], ...], q: int) -> set[tuple[int, ...]]:
    return {v for v in vectors if sum(x * y for x, y in zip(functional, v)) % q == 0}


def main() -> None:
    rows = []
    for q in (2, 3, 5):
        for dimension in (1, 2, 3):
            vectors = tuple(product(range(q), repeat=dimension))
            functionals = projective_functionals(q, dimension)
            kernels = [kernel(f, vectors, q) for f in functionals]
            checked = 0
            for size in range(min(q, len(kernels)) + 1):
                for chosen in combinations(range(len(kernels)), size):
                    union = set().union(*(kernels[i] for i in chosen)) if chosen else set()
                    assert union != set(vectors)
                    checked += 1

            sharp_cover = False
            if dimension == 2:
                assert len(kernels) == q + 1
                sharp_cover = set().union(*kernels) == set(vectors)
                assert sharp_cover

            rows.append({
                "q": q,
                "dimension": dimension,
                "projective_hyperplanes": len(kernels),
                "families_of_size_at_most_q_checked": checked,
                "q_plus_one_cover_in_dimension_two": sharp_cover,
            })

    # The common-zero union estimate proving the strengthened uniform range.
    symbolic_check = []
    for q in range(2, 20):
        for dimension in range(1, 8):
            space = q**dimension
            hyperplane = q ** (dimension - 1)
            upper = 1 + q * (hyperplane - 1)
            assert upper < space
            symbolic_check.append((q, dimension, upper, space))

    print(json.dumps({
        "verdict": "at_most_q_proper_hyperplanes_do_not_cover",
        "sharp_uniform_counterexample": "q_plus_one_lines_cover_Fq_squared",
        "exhaustive_rows": rows,
        "common_zero_inequality_cases": len(symbolic_check),
    }, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
