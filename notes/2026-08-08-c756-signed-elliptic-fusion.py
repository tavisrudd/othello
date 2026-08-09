#!/usr/bin/env python3
"""Exact finite checks for the C756 signed elliptic fusion.

The calculation is deliberately self-contained and uses only prime fields.
It constructs one oriented representative of every conjugate pair outside
F_q in F_{q^2} and verifies the full integer matrix identity from Theorem 16.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


PRIMES = (5, 7, 11, 13, 17, 19, 23)
OUTPUT = Path(__file__).with_suffix(".json")
CHARACTERISTIC_DEPENDENCIES = {
    5: ((0, 2, 7), (1, 1, 1)),
    7: ((0, 3, 7, 19), (1, 6, 6, 1)),
}


def chi(x: int, q: int) -> int:
    x %= q
    if x == 0:
        return 0
    return 1 if pow(x, (q - 1) // 2, q) == 1 else -1


def least_nonsquare(q: int) -> int:
    return next(d for d in range(2, q) if chi(d, q) == -1)


def matrix_for(q: int) -> tuple[int, list[tuple[int, int]], list[list[int]]]:
    d = least_nonsquare(q)
    # a + b*s, s^2=d; b and -b represent the same conjugate pair.
    points = [(a, b) for a in range(q) for b in range(1, (q + 1) // 2)]
    n = len(points)
    matrix = [[0] * n for _ in range(n)]
    signs = [chi(b, q) for _, b in points]
    for i, (a, b) in enumerate(points):
        for j in range(i + 1, n):
            c, e = points[j]
            alpha = ((a - c) ** 2 - d * (b - e) ** 2) % q
            beta = ((a - c) ** 2 - d * (b + e) ** 2) % q
            little_l = (chi(alpha, q) - chi(beta, q)) // 2
            value = -signs[i] * signs[j] * little_l
            matrix[i][j] = value
            matrix[j][i] = value
    return d, points, matrix


def binary_rank(matrix: list[list[int]]) -> int:
    pivots: dict[int, int] = {}
    for row in matrix:
        value = sum((entry & 1) << j for j, entry in enumerate(row))
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return len(pivots)


def modular_rank(matrix: list[list[int]], prime: int) -> int:
    rows = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (i for i in range(rank, len(rows)) if rows[i][column]), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], -1, prime)
        rows[rank] = [(entry * inverse) % prime for entry in rows[rank]]
        for i in range(rank + 1, len(rows)):
            if rows[i][column]:
                multiple = rows[i][column]
                rows[i] = [
                    (a - multiple * b) % prime
                    for a, b in zip(rows[i], rows[rank])
                ]
        rank += 1
        if rank == len(rows):
            break
    return rank


def characteristic_shadow(
    q: int, epsilon: int, fusion: list[list[int]]
) -> tuple[int, list[int] | None]:
    size = len(fusion)
    operator = [
        [2 * fusion[i][j] - (epsilon if i == j else 0) for j in range(size)]
        for i in range(size)
    ]
    rank = modular_rank(operator, q)
    witness = CHARACTERISTIC_DEPENDENCIES.get(q)
    if witness is None:
        return rank, None
    indices, coefficients = witness
    if any(
        sum(coefficient * operator[row][column] for coefficient, column in zip(coefficients, indices)) % q
        for row in range(size)
    ):
        raise AssertionError(f"q={q}: bad characteristic dependency witness")
    return rank, list(indices)


def passant_incidence(
    q: int, d: int, points: list[tuple[int, int]]
) -> list[list[int]]:
    """Internal-point/passant-line incidence after identifying by polarity."""
    projective = [(1, a, (a * a - d * b * b) % q) for a, b in points]
    size = len(projective)
    matrix = [[0] * size for _ in range(size)]
    for i, (x, y, z) in enumerate(projective):
        for j, (u, v, w) in enumerate(projective):
            matrix[i][j] = int(i != j and (2 * y * v - x * w - z * u) % q == 0)
    return matrix


def signed_passant_incidence(
    q: int, d: int, points: list[tuple[int, int]], fusion: list[list[int]]
) -> list[list[int]]:
    """Sign each passant row so that its Gram matrix is m I-epsilon K."""
    incidence = passant_incidence(q, d, points)
    epsilon = chi(-1, q)
    signed: list[list[int]] = []
    for row in incidence:
        support = [i for i, value in enumerate(row) if value]
        if len(support) != (q + 1) // 2:
            raise AssertionError(f"q={q}: unexpected passant row weight")
        root = support[0]
        signs = {root: 1}
        for i in support[1:]:
            signs[i] = -epsilon * fusion[root][i]
        if any(
            fusion[i][j] != -epsilon * signs[i] * signs[j]
            for i in support
            for j in support
            if i != j
        ):
            raise AssertionError(f"q={q}: passant row is not anti-coherent")
        signed.append([signs.get(i, 0) for i in range(len(points))])
    return signed


def verify_signed_passant_factorization(
    q: int, d: int, points: list[tuple[int, int]], fusion: list[list[int]]
) -> tuple[int, int, int]:
    signed = signed_passant_incidence(q, d, points, fusion)
    size = len(points)
    m = (q + 1) // 2
    epsilon = chi(-1, q)
    failures = 0
    for i in range(size):
        for j in range(size):
            gram = sum(signed[row][i] * signed[row][j] for row in range(size))
            target = (m if i == j else 0) - epsilon * fusion[i][j]
            failures += gram != target
    if failures:
        raise AssertionError(f"q={q}: {failures} signed factorization failures")
    return m, modular_rank(signed, q), failures


def verify_binary_bridge(
    q: int, d: int, points: list[tuple[int, int]], fusion: list[list[int]]
) -> tuple[int, int]:
    incidence = passant_incidence(q, d, points)
    size = len(points)
    diagonal = ((q + 1) // 2) & 1
    failures = 0
    for i in range(size):
        for j in range(size):
            square = sum(incidence[i][k] * incidence[k][j] for k in range(size)) & 1
            target = (fusion[i][j] & 1) ^ (diagonal if i == j else 0)
            failures += square != target
    if failures:
        raise AssertionError(f"q={q}: {failures} entries violate the binary bridge")
    return binary_rank(incidence), failures


def q13_relation_support(
    d: int, points: list[tuple[int, int]], matrix: list[list[int]]
) -> list[int]:
    """Identify the support fusion in Paper IV's rho-labelling."""
    q = 13
    support: dict[int, set[int]] = {}
    for i, (a, b) in enumerate(points):
        first = (1, a, (a * a - d * b * b) % q)
        delta_first = (first[1] * first[1] - first[0] * first[2]) % q
        for j in range(i + 1, len(points)):
            c, e = points[j]
            second = (1, c, (c * c - d * e * e) % q)
            delta_second = (second[1] * second[1] - second[0] * second[2]) % q
            beta = (
                2 * first[1] * second[1]
                - first[0] * second[2]
                - first[2] * second[0]
            ) % q
            rho = beta * beta * pow(delta_first * delta_second, -1, q) % q
            support.setdefault(rho, set()).add(abs(matrix[i][j]))
    if any(values != {0} and values != {1} for values in support.values()):
        raise AssertionError(f"q=13: a rho relation is split by the fusion: {support}")
    return sorted(value for value, flags in support.items() if flags == {1})


def certify(q: int) -> dict[str, int | list[int]]:
    d, points, matrix = matrix_for(q)
    n = len(points)
    epsilon = chi(-1, q)
    scalar = (q * q - 1) // 4
    failures = 0
    for i in range(n):
        for j in range(n):
            square = sum(matrix[i][k] * matrix[k][j] for k in range(n))
            target = epsilon * matrix[i][j] + (scalar if i == j else 0)
            failures += square != target
    if failures:
        raise AssertionError(f"q={q}: {failures} entries violate the identity")
    degrees = {sum(value * value for value in row) for row in matrix}
    if degrees != {scalar}:
        raise AssertionError(f"q={q}: nonconstant signed degree {degrees}")
    relevant = epsilon * (q + 1) // 2
    other = -epsilon * (q - 1) // 2
    incidence_rank, bridge_failures = verify_binary_bridge(q, d, points, matrix)
    signed_row_weight, signed_rank, signed_failures = verify_signed_passant_factorization(
        q, d, points, matrix
    )
    characteristic_rank, dependency_support = characteristic_shadow(q, epsilon, matrix)
    result: dict[str, int | list[int]] = {
        "q": q,
        "least_nonsquare": d,
        "vertices": n,
        "matrix_entries_checked": n * n,
        "identity_failures": failures,
        "signed_degree": scalar,
        "eigenvalues": [min(relevant, other), max(relevant, other)],
        "relevant_eigenvalue": relevant,
        "relevant_multiplicity": (q - 1) ** 2 // 4,
        "other_multiplicity": (q * q - 1) // 4,
        "binary_rank": binary_rank(matrix),
        "expected_binary_rank": (
            (q - 1) ** 2 // 4 if q % 4 == 1 else (q * q - 1) // 4
        ),
        "passant_incidence_rank": incidence_rank,
        "passant_code_dimension": n - incidence_rank,
        "expected_passant_code_dimension": (q - 1) ** 2 // 4,
        "binary_bridge_failures": bridge_failures,
        "signed_passant_row_weight": signed_row_weight,
        "signed_passant_rank": signed_rank,
        "expected_signed_passant_rank": (q * q - 1) // 4,
        "signed_passant_factorization_failures": signed_failures,
        "characteristic_rank_of_2K_minus_epsilon_I": characteristic_rank,
        "observed_characteristic_rank_formula": (q * q - 1) // 8,
    }
    if result["binary_rank"] != result["expected_binary_rank"]:
        raise AssertionError(f"q={q}: unexpected binary rank")
    if result["passant_code_dimension"] != result["expected_passant_code_dimension"]:
        raise AssertionError(f"q={q}: unexpected passant-code dimension")
    if result["signed_passant_rank"] != result["expected_signed_passant_rank"]:
        raise AssertionError(f"q={q}: unexpected signed passant rank")
    if result["characteristic_rank_of_2K_minus_epsilon_I"] != result["observed_characteristic_rank_formula"]:
        raise AssertionError(f"q={q}: unexpected characteristic rank")
    if dependency_support is not None:
        result["short_characteristic_dependency_support"] = dependency_support
    if q == 13:
        result["paper_iv_support_relations"] = q13_relation_support(d, points, matrix)
    return result


def certificate() -> dict[str, object]:
    return {
        "schema": "c756-signed-elliptic-fusion-v5",
        "field_scope": "odd prime fields",
        "orientation": "a+b*s with 0 <= a < q and 1 <= b <= (q-1)/2",
        "identity": "K^2 = chi_q(-1) K + (q^2-1)/4 I",
        "binary_bridge": "K mod 2 = A_passant^2 + ((q+1)/2 mod 2) I",
        "signed_passant_factorization": "Z^T Z = (q+1)/2 I - chi_q(-1) K",
        "cases": [certify(q) for q in PRIMES],
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="regenerate the JSON certificate")
    parser.add_argument("--check", action="store_true", help="check the tracked certificate")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    actual = serialized()
    if args.write:
        OUTPUT.write_text(actual, encoding="utf-8")
    else:
        expected = OUTPUT.read_text(encoding="utf-8")
        if actual != expected:
            raise SystemExit(f"certificate mismatch: regenerate with {Path(__file__).name} --write")
        print(f"ok: {len(PRIMES)} fields, {sum(c['matrix_entries_checked'] for c in certificate()['cases'])} matrix entries")


if __name__ == "__main__":
    main()
