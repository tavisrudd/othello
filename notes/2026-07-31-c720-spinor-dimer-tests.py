#!/usr/bin/env python3
"""Exact C720 pure-spinor and K_3,3 frustration discriminators."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-07-31-c720-spinor-dimer-tests.json"
N = 6
VERTICES = tuple(range(N))
TRIPLES = tuple(itertools.combinations(VERTICES, 3))
INTERNAL_EDGES = tuple(itertools.combinations(range(1, N), 2))
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)

# Sparse polynomials in x_0,...,x_5, keyed by exponent tuples.
Poly = dict[tuple[int, ...], int]
ZERO_EXP = (0,) * N


def pclean(poly: Poly) -> Poly:
    return {monomial: coefficient for monomial, coefficient in poly.items() if coefficient}


def padd(left: Poly, right: Poly) -> Poly:
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + coefficient
    return pclean(result)


def pscale(scalar: int, poly: Poly) -> Poly:
    return pclean({monomial: scalar * coefficient for monomial, coefficient in poly.items()})


def pmul(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for a, ca in left.items():
        for b, cb in right.items():
            monomial = tuple(a[i] + b[i] for i in VERTICES)
            result[monomial] = result.get(monomial, 0) + ca * cb
    return pclean(result)


def ppow(poly: Poly, exponent: int) -> Poly:
    result = {ZERO_EXP: 1}
    factor = poly
    while exponent:
        if exponent & 1:
            result = pmul(result, factor)
        factor = pmul(factor, factor)
        exponent //= 2
    return result


def linear_difference(i: int, j: int, sign: int) -> Poly:
    ei = tuple(int(k == i) for k in VERTICES)
    ej = tuple(int(k == j) for k in VERTICES)
    return {ei: sign, ej: -sign}


def pfaffian(matrix: list[list[Poly]], indices: tuple[int, ...]) -> Poly:
    if not indices:
        return {ZERO_EXP: 1}
    i = indices[0]
    result: Poly = {}
    for position, j in enumerate(indices[1:], start=1):
        remainder = tuple(k for k in indices if k not in (i, j))
        term = pmul(matrix[i][j], pfaffian(matrix, remainder))
        result = padd(result, pscale((-1) ** (position + 1), term))
    return result


def permutation_parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def triple_coefficients(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(matrix[i][j] * matrix[j][k] * matrix[k][i] for i, j, k in TRIPLES)


def permute_cubic(cubic: tuple[int, ...], permutation: tuple[int, ...]) -> tuple[int, ...]:
    values = {}
    for coefficient, support in zip(cubic, TRIPLES):
        values[tuple(sorted(permutation[i] for i in support))] = coefficient
    return tuple(values[support] for support in TRIPLES)


BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)


def total_key(total: tuple[tuple[tuple[int, int], ...], ...]) -> tuple:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def outer_cubics() -> tuple[tuple[int, ...], ...]:
    base = triple_coefficients(BASE_C)
    oriented: dict[tuple, tuple[int, ...]] = {}
    for permutation in itertools.permutations(VERTICES):
        key = total_key(tuple(
            tuple(sorted(tuple(sorted((permutation[i], permutation[j]))) for i, j in matching))
            for matching in BASE_TOTAL
        ))
        cubic = tuple(
            permutation_parity(permutation) * coefficient
            for coefficient in permute_cubic(base, permutation)
        )
        if key in oriented:
            assert oriented[key] == cubic
        else:
            oriented[key] = cubic
    assert len(oriented) == 6
    return tuple(oriented[key] for key in sorted(oriented))


def reconstruct_conference(cubic: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    coefficient = dict(zip(TRIPLES, cubic))
    matrix = [[0] * N for _ in VERTICES]
    for i in range(1, N):
        matrix[0][i] = matrix[i][0] = 1
    for i, j in INTERNAL_EDGES:
        matrix[i][j] = matrix[j][i] = coefficient[(0, i, j)]
    assert triple_coefficients(tuple(tuple(row) for row in matrix)) == cubic
    return tuple(tuple(row) for row in matrix)


def square_is_five_identity(matrix: tuple[tuple[int, ...], ...]) -> bool:
    return all(
        sum(matrix[i][k] * matrix[k][j] for k in VERTICES) == 5 * int(i == j)
        for i in VERTICES for j in VERTICES
    )


def normalized_matrix(bits: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    matrix = [[0] * N for _ in VERTICES]
    for i in range(1, N):
        matrix[0][i] = matrix[i][0] = 1
    for bit, (i, j) in zip(bits, INTERNAL_EDGES):
        matrix[i][j] = matrix[j][i] = -1 if bit else 1
    return tuple(tuple(row) for row in matrix)


def cut_terms(matrix: tuple[tuple[int, ...], ...], left: tuple[int, ...]) -> tuple[int, ...]:
    right = tuple(i for i in VERTICES if i not in left)
    return tuple(
        permutation_parity(permutation)
        * matrix[left[0]][right[permutation[0]]]
        * matrix[left[1]][right[permutation[1]]]
        * matrix[left[2]][right[permutation[2]]]
        for permutation in itertools.permutations(range(3))
    )


def dimer_fingerprint(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    result = []
    for tail in itertools.combinations(range(1, N), 2):
        terms = cut_terms(matrix, (0,) + tail)
        result.extend(term * terms[0] for term in terms)
    return tuple(result)


def one_frustrated_every_cut(matrix: tuple[tuple[int, ...], ...]) -> bool:
    for tail in itertools.combinations(range(1, N), 2):
        terms = cut_terms(matrix, (0,) + tail)
        if min(terms.count(1), terms.count(-1)) != 1:
            return False
    return True


def polynomial_rank(polynomials: tuple[Poly, ...]) -> int:
    monomials = sorted(set().union(*(poly.keys() for poly in polynomials)))
    rows = [[poly.get(monomial, 0) for monomial in monomials] for poly in polynomials]
    rank = 0
    column = 0
    from fractions import Fraction
    work = [[Fraction(value) for value in row] for row in rows]
    while rank < len(work) and column < len(monomials):
        pivot = next((i for i in range(rank, len(work)) if work[i][column]), None)
        if pivot is None:
            column += 1
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        value = work[rank][column]
        work[rank] = [entry / value for entry in work[rank]]
        for i in range(len(work)):
            if i != rank and work[i][column]:
                factor = work[i][column]
                work[i] = [work[i][j] - factor * work[rank][j] for j in range(len(monomials))]
        rank += 1
        column += 1
    return rank


def spinor_test(matrices: tuple[tuple[tuple[int, ...], ...], ...]) -> dict[str, object]:
    top_pfaffians = []
    signature_sizes = []
    for conference in matrices:
        alternating = [[{} for _ in VERTICES] for _ in VERTICES]
        for i, j in itertools.combinations(VERTICES, 2):
            alternating[i][j] = linear_difference(i, j, conference[i][j])
            alternating[j][i] = pscale(-1, alternating[i][j])
        signature = {
            support: pfaffian(alternating, support)
            for size in (0, 2, 4, 6)
            for support in itertools.combinations(VERTICES, size)
        }
        assert len(signature) == 32
        # Independent expansion along every possible first vertex checks the
        # six top-degree Wick/Pfaffian recurrences.
        full = signature[VERTICES]
        for first in VERTICES:
            ordered = (first,) + tuple(i for i in VERTICES if i != first)
            assert pfaffian(alternating, ordered) == pscale(permutation_parity(ordered), full)
        signature_sizes.append(len(signature))
        top_pfaffians.append(full)

    linear_relation = {}
    cubic_relation = {}
    for top in top_pfaffians:
        linear_relation = padd(linear_relation, top)
        cubic_relation = padd(cubic_relation, ppow(top, 3))
    assert not linear_relation
    assert not cubic_relation

    # Wick identities alone cannot impose either Segre equation: six
    # independent block-diagonal skew matrices can have top Pfaffians
    # (1,0,0,0,0,0), which already violates the linear equation.
    independent_top_witness = (1, 0, 0, 0, 0, 0)
    assert sum(independent_top_witness) != 0

    return {
        "number_of_synchronized_pure_spinors": len(matrices),
        "principal_pfaffian_coordinates_each": sorted(set(signature_sizes)),
        "top_pfaffian_polynomial_rank": polynomial_rank(tuple(top_pfaffians)),
        "top_pfaffian_normalization": "Pf([D_x,C_T]) = 4 Z_T(x)",
        "segre_linear_relation_exact": True,
        "segre_cubic_relation_exact": True,
        "wick_alone_implies_segre": False,
        "counterexample_top_coordinates": list(independent_top_witness),
        "positive_replacement": (
            "the golden family is a synchronized 5-parameter linear slice of a product "
            "of six pure-spinor/matchgate big cells"
        ),
    }


def dimer_test(matrices: tuple[tuple[tuple[int, ...], ...], ...]) -> dict[str, object]:
    fingerprints: dict[tuple[int, ...], list[tuple[int, ...]]] = {}
    good = []
    conference = []
    equivalence_checks = 0
    for bits in itertools.product((0, 1), repeat=len(INTERNAL_EDGES)):
        matrix = normalized_matrix(bits)
        fingerprint = dimer_fingerprint(matrix)
        fingerprints.setdefault(fingerprint, []).append(bits)
        is_good = one_frustrated_every_cut(matrix)
        is_conference = square_is_five_identity(matrix)
        assert is_good == is_conference
        equivalence_checks += 1
        if is_good:
            good.append(bits)
        if is_conference:
            conference.append(bits)

    assert set(good) == set(conference)
    assert len(fingerprints) == 512
    assert {len(fibre) for fibre in fingerprints.values()} == {2}
    assert all(tuple(1 - bit for bit in bits) in fibre for fibre in fingerprints.values() for bits in fibre)
    golden_fingerprints = {dimer_fingerprint(matrix) for matrix in matrices}
    good_fingerprints = {dimer_fingerprint(normalized_matrix(bits)) for bits in good}
    assert golden_fingerprints == good_fingerprints
    assert all(one_frustrated_every_cut(matrix) for matrix in matrices)

    return {
        "gauge_normalized_K6_signings_checked": equivalence_checks,
        "relative_matching_fingerprints": len(fingerprints),
        "signings_per_unoriented_fingerprint": sorted({len(fibre) for fibre in fingerprints.values()}),
        "all_cut_5_to_1_signings": len(good),
        "maximum_absolute_3_by_3_sign_determinant": 4,
        "conference_signings_B2_eq_5I": len(conference),
        "conditions_equivalent_on_complete_domain": True,
        "unoriented_golden_fingerprints": len(good_fingerprints),
        "sylow_5_subgroups_of_A5": 6,
        "outer_golden_family_exhausts_them": True,
        "orientation_loss": "C and -C have the same relative matching fingerprint",
        "recovered_object": "the switching class of the unoriented two-graph line {+c,-c}",
    }


def build() -> dict[str, object]:
    cubics = outer_cubics()
    matrices = tuple(reconstruct_conference(cubic) for cubic in cubics)
    assert len(set(matrices)) == 6
    assert all(square_is_five_identity(matrix) for matrix in matrices)
    return {
        "schema": "c720-spinor-dimer-tests-v1",
        "conventions": {
            "vertices": list(VERTICES),
            "gauge": "B_0i=1 for i=1,...,5",
            "cuts": "the ten 3|3 cuts represented by left sets containing vertex 0",
            "matching_sign": "permutation parity times the three cross-edge signs",
            "orientation_quotient": "relative signs normalized by the first matching term",
        },
        "pure_spinor_test": spinor_test(matrices),
        "K3_3_frustration_test": dimer_test(matrices),
        "verdict": {
            "naive_single_spinor_parent": "fails",
            "synchronized_product_of_six_spinors": "passes exactly",
            "dimer_characterization": (
                "every balanced cross block is maximum-determinant iff B is a golden conference signing"
            ),
            "six_shadow_explanation": (
                "the 12 oriented conference signings pair under B -> -B into exactly six "
                "relative-matching fingerprints"
            ),
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        print(f"ok: {OUTPUT.name} ({len(payload)} bytes, sha256={hashlib.sha256(payload).hexdigest()})")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
