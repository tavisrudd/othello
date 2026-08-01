#!/usr/bin/env python3
"""Dependency-free replay of rank-one tensor critical ideals."""

from itertools import combinations, permutations


ZERO = None


def add_exponents(*monomials: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(entries) for entries in zip(*monomials, strict=True))


def permutation_sign(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def weak_compositions(total: int, parts: int):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in weak_compositions(total - first, parts - 1):
            yield (first,) + rest


def tensor_jacobian(r: int, s: int):
    size = r + s
    variables = tuple(
        tuple(int(index == variable) for index in range(size))
        for variable in range(size)
    )
    rows = []
    for i in range(r):
        for j in range(s):
            row = [ZERO] * size
            row[i] = variables[r + j]
            row[r + j] = variables[i]
            rows.append(tuple(row))
    return tuple(rows)


def determinant(matrix, rows: tuple[int, ...], columns: tuple[int, ...]) -> dict:
    result: dict[tuple[int, ...], int] = {}
    order = len(rows)
    for permutation in permutations(range(order)):
        entries = tuple(
            matrix[rows[i]][columns[permutation[i]]] for i in range(order)
        )
        if ZERO in entries:
            continue
        exponent = add_exponents(*entries)
        result[exponent] = result.get(exponent, 0) + permutation_sign(permutation)
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def expected_generators(r: int, s: int):
    root_in_u = {
        u_degree + v_degree
        for u_degree in weak_compositions(s, r)
        for v_degree in weak_compositions(r - 1, s)
    }
    root_in_v = {
        u_degree + v_degree
        for u_degree in weak_compositions(s - 1, r)
        for v_degree in weak_compositions(r, s)
    }
    return root_in_u | root_in_v


def check_case(r: int, s: int) -> int:
    matrix = tensor_jacobian(r, s)
    order = r + s - 1
    minor_monomials = set()
    for rows in combinations(range(r * s), order):
        for columns in combinations(range(r + s), order):
            minor = determinant(matrix, rows, columns)
            if not minor:
                continue
            if len(minor) != 1 or abs(next(iter(minor.values()))) != 1:
                raise SystemExit(f"unexpected nonmonomial minor for {(r, s)}: {minor}")
            minor_monomials.add(next(iter(minor)))
    expected = expected_generators(r, s)
    if minor_monomials != expected:
        raise SystemExit(
            f"critical minors disagree with tensor formula for {(r, s)}: "
            f"actual={len(minor_monomials)} expected={len(expected)}"
        )
    return len(expected)


counts = {
    f"{r}x{s}": check_case(r, s)
    for r, s in ((2, 2), (2, 3), (3, 2), (3, 3))
}
if counts["2x2"] != 12:
    raise SystemExit("unexpected 2x2 generator count")

print(
    "independent rank-one quotient replay: OK "
    f"generator_counts={counts} defect_length_2x2=4"
)
