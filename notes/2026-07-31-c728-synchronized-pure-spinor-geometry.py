#!/usr/bin/env python3
"""Exact representation and Pfaffian certificate for C728."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import subprocess
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-07-31-c728-synchronized-pure-spinor-geometry.json"
N = 6
X = tuple(range(N))
TRIPLES = tuple(itertools.combinations(X, 3))
INTERNAL_EDGES = tuple(itertools.combinations(range(1, N), 2))
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)

Exponent = tuple[int, ...]
Poly = dict[Exponent, int]
ZERO_EXP = (0,) * N


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(N)
        for j in range(i + 1, N)
    )
    return -1 if inversions % 2 else 1


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[i]] for i in X)


def power(permutation: tuple[int, ...], exponent: int) -> tuple[int, ...]:
    result = X
    for _ in range(exponent):
        result = compose(permutation, result)
    return result


def cycle_type(permutation: tuple[int, ...]) -> str:
    unseen = set(X)
    lengths = []
    while unseen:
        start = min(unseen)
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            current = permutation[current]
            length += 1
        lengths.append(length)
    return ".".join(map(str, sorted(lengths, reverse=True)))


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
            monomial = tuple(a[i] + b[i] for i in X)
            result[monomial] = result.get(monomial, 0) + ca * cb
    return pclean(result)


def ppow(poly: Poly, exponent: int) -> Poly:
    result = {ZERO_EXP: 1}
    for _ in range(exponent):
        result = pmul(result, poly)
    return result


def linear_difference(i: int, j: int, sign: int) -> Poly:
    ei = tuple(int(k == i) for k in X)
    ej = tuple(int(k == j) for k in X)
    return {ei: sign, ej: -sign}


def pfaffian(matrix: list[list[Poly]], indices: tuple[int, ...]) -> Poly:
    if not indices:
        return {ZERO_EXP: 1}
    first = indices[0]
    result: Poly = {}
    for position, second in enumerate(indices[1:], start=1):
        remainder = tuple(k for k in indices if k not in (first, second))
        result = padd(
            result,
            pscale(
                (-1) ** (position + 1),
                pmul(matrix[first][second], pfaffian(matrix, remainder)),
            ),
        )
    return result


def triple_coefficients(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(matrix[i][j] * matrix[j][k] * matrix[k][i] for i, j, k in TRIPLES)


def permute_cubic(cubic: tuple[int, ...], permutation: tuple[int, ...]) -> tuple[int, ...]:
    values = {}
    for coefficient, support in zip(cubic, TRIPLES):
        values[tuple(sorted(permutation[i] for i in support))] = coefficient
    return tuple(values[support] for support in TRIPLES)


def total_key(total: tuple[tuple[tuple[int, int], ...], ...]) -> tuple:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def outer_cubics() -> tuple[tuple[int, ...], ...]:
    base = triple_coefficients(BASE_C)
    oriented: dict[tuple, tuple[int, ...]] = {}
    for permutation in itertools.permutations(X):
        key = total_key(
            tuple(
                tuple(
                    sorted(tuple(sorted((permutation[i], permutation[j]))) for i, j in matching)
                )
                for matching in BASE_TOTAL
            )
        )
        cubic = tuple(
            parity(permutation) * coefficient
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
    matrix = [[0] * N for _ in X]
    for i in range(1, N):
        matrix[0][i] = matrix[i][0] = 1
    for i, j in INTERNAL_EDGES:
        matrix[i][j] = matrix[j][i] = coefficient[(0, i, j)]
    result = tuple(tuple(row) for row in matrix)
    assert triple_coefficients(result) == cubic
    assert all(
        sum(result[i][k] * result[k][j] for k in X) == 5 * int(i == j)
        for i in X
        for j in X
    )
    return result


def matrix_product(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [[sum(left[i][k] * right[k][j] for k in X) for j in X] for i in X]


def trace(matrix: list[list[int]]) -> int:
    return sum(matrix[i][i] for i in X)


def outer_action(
    permutation: tuple[int, ...],
    total: int,
    cubics: tuple[tuple[int, ...], ...],
    matrices: tuple[tuple[tuple[int, ...], ...], ...],
) -> tuple[int, list[list[int]]]:
    index = {cubic: i for i, cubic in enumerate(cubics)}
    transformed = tuple(
        parity(permutation) * coefficient
        for coefficient in permute_cubic(cubics[total], permutation)
    )
    target = index[transformed]
    raw = [[0] * N for _ in X]
    for i in X:
        for j in X:
            raw[permutation[i]][permutation[j]] = parity(permutation) * matrices[total][i][j]
    switching = [1] + [raw[0][j] for j in range(1, N)]
    monomial = [[0] * N for _ in X]
    for i in X:
        monomial[permutation[i]][i] = switching[permutation[i]]
    assert all(
        matrices[target][i][j]
        == parity(permutation)
        * sum(
            monomial[i][a] * matrices[total][a][b] * monomial[j][b]
            for a in X
            for b in X
        )
        for i in X
        for j in X
    )
    return target, monomial


def polynomial_rank(polynomials: tuple[Poly, ...]) -> int:
    monomials = sorted(set().union(*(poly.keys() for poly in polynomials)))
    work = [[Fraction(poly.get(monomial, 0)) for monomial in monomials] for poly in polynomials]
    rank = 0
    column = 0
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


def evaluate(poly: Poly, point: tuple[int, ...]) -> int:
    return sum(
        coefficient
        * __import__("math").prod(point[i] ** exponent for i, exponent in enumerate(monomial))
        for monomial, coefficient in poly.items()
    )


def derivative(poly: Poly, variable: int, point: tuple[int, ...]) -> int:
    return sum(
        coefficient
        * monomial[variable]
        * __import__("math").prod(
            point[i] ** (exponent - int(i == variable))
            for i, exponent in enumerate(monomial)
        )
        for monomial, coefficient in poly.items()
        if monomial[variable]
    )


def determinant(matrix: list[list[int]]) -> int:
    size = len(matrix)
    return sum(
        (-1) ** sum(p[i] > p[j] for i in range(size) for j in range(i + 1, size))
        * __import__("math").prod(matrix[i][p[i]] for i in range(size))
        for p in itertools.permutations(range(size))
    )


def build_certificate() -> dict[str, object]:
    cubics = outer_cubics()
    matrices = tuple(reconstruct_conference(cubic) for cubic in cubics)
    top_pfaffians = []
    for conference in matrices:
        alternating = [[{} for _ in X] for _ in X]
        for i, j in itertools.combinations(X, 2):
            alternating[i][j] = linear_difference(i, j, conference[i][j])
            alternating[j][i] = pscale(-1, alternating[i][j])
        top_pfaffians.append(pfaffian(alternating, X))
    tops = tuple(top_pfaffians)
    linear_relation: Poly = {}
    cubic_relation: Poly = {}
    for poly in tops:
        linear_relation = padd(linear_relation, poly)
        cubic_relation = padd(cubic_relation, ppow(poly, 3))
    assert not linear_relation and not cubic_relation

    classes: dict[str, dict[str, int]] = {}
    hom_linear_numerator = 0
    hom_cubic_permutation_numerator = 0
    hom_cubic_augmentation_numerator = 0
    for permutation in itertools.permutations(X):
        ctype = cycle_type(permutation)
        chi_a = sum(permutation[i] == i for i in X) - 1
        fixed_outer = 0
        chi_fibre_product = 0
        for total in range(6):
            target, monomial = outer_action(permutation, total, cubics, matrices)
            if target == total:
                fixed_outer += 1
                square = matrix_product(monomial, monomial)
                chi_wedge_two = (trace(monomial) ** 2 - trace(square)) // 2
                chi_fibre_product += parity(permutation) * chi_wedge_two
        chi_sym3 = (
            chi_a**3
            + 3 * chi_a * (sum(power(permutation, 2)[i] == i for i in X) - 1)
            + 2 * (sum(power(permutation, 3)[i] == i for i in X) - 1)
        ) // 6
        chi_outer_permutation = parity(permutation) * fixed_outer
        chi_outer_augmentation = chi_outer_permutation - parity(permutation)
        hom_linear_numerator += chi_a * chi_fibre_product
        hom_cubic_permutation_numerator += chi_sym3 * chi_outer_permutation
        hom_cubic_augmentation_numerator += chi_sym3 * chi_outer_augmentation
        row = classes.setdefault(
            ctype,
            {
                "class_size": 0,
                "sign": parity(permutation),
                "chi_augmentation": chi_a,
                "fixed_outer_totals": fixed_outer,
                "chi_cell_tangent_product": chi_fibre_product,
                "chi_sym3_augmentation": chi_sym3,
                "chi_signed_outer_permutation": chi_outer_permutation,
                "chi_signed_outer_augmentation": chi_outer_augmentation,
            },
        )
        row["class_size"] += 1
        assert all(
            row[key] == value
            for key, value in {
                "sign": parity(permutation),
                "chi_augmentation": chi_a,
                "fixed_outer_totals": fixed_outer,
                "chi_cell_tangent_product": chi_fibre_product,
                "chi_sym3_augmentation": chi_sym3,
                "chi_signed_outer_permutation": chi_outer_permutation,
                "chi_signed_outer_augmentation": chi_outer_augmentation,
            }.items()
        )

    witness = (-2, -2, -1, -1, 0, 0)
    rows = (0, 2, 3, 4)
    columns = (0, 1, 2, 4)
    jacobian_minor = determinant(
        [[derivative(tops[i], j, witness) for j in columns] for i in rows]
    )
    assert jacobian_minor == -24576

    singular_script = ROOT / "notes" / "2026-07-31-c728-synchronized-pure-spinor-elimination.sing"
    singular = subprocess.run(
        [
            "nix",
            "shell",
            "nixpkgs#singular",
            "--command",
            "Singular",
            "-q",
            str(singular_script.relative_to(ROOT)),
        ],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    singular_output = [line for line in singular.stdout.splitlines() if line]
    assert singular_output == [
        "C728_ELIMINATION_OK",
        "projected_ideal_generators=linear_plus_cubic",
        "base_scheme=reduced_union_of_15_projective_lines",
        "base_projective_degree=15",
    ]

    return {
        "schema": "c728-synchronized-pure-spinor-geometry-v1",
        "field": "Q (geometric conclusions after characteristic-zero base change)",
        "outer_totals": 6,
        "conference_normalization": "C_T^2=5I and C_T[0,j]=1 for j>0",
        "top_pfaffian_normalization": "Pf([D_x,C_T])=4 Z_T(x)",
        "top_pfaffian_linear_rank": polynomial_rank(tops),
        "top_relations": ["sum_T pf_T=0", "sum_T pf_T^3=0"],
        "hom_multiplicities": {
            "Hom_S6(A_X, product_T Lambda2(U_T)^signed)": hom_linear_numerator // 720,
            "Hom_S6(Sym3(A_X), signed_outer_permutation)": hom_cubic_permutation_numerator // 720,
            "Hom_S6(Sym3(A_X), signed_outer_augmentation)": hom_cubic_augmentation_numerator // 720,
        },
        "character_table": {key: classes[key] for key in sorted(classes)},
        "jacobian_rank_witness": {
            "translation_gauge": "x5=0",
            "point": list(witness[:5]),
            "target_values": [evaluate(poly, witness) for poly in tops],
            "rows": list(rows),
            "columns": list(columns),
            "minor": jacobian_minor,
            "rank": 4,
        },
        "singular_elimination_companion": "notes/2026-07-31-c728-synchronized-pure-spinor-elimination.sing",
        "singular_output": singular_output,
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == payload, f"stale certificate: {OUTPUT}"
        print(f"OK {OUTPUT.relative_to(ROOT)} sha256={hashlib.sha256(payload).hexdigest()}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"WROTE {OUTPUT.relative_to(ROOT)} sha256={hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
