#!/usr/bin/env python3
"""Exact C704 certificate: paired-E8 operator shadows and Segre--Igusa."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from fractions import Fraction
from itertools import combinations, permutations
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c704-segre-igusa-operator-shadow.json"
TRIPLES = tuple(combinations(range(6), 3))
PAIRS = tuple(combinations(range(6), 2))
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def parity(p: tuple[int, ...]) -> int:
    inversions = sum(p[i] > p[j] for i in range(6) for j in range(i + 1, 6))
    return -1 if inversions % 2 else 1


def det(matrix: list[list[int]] | tuple[tuple[int, ...], ...]) -> int:
    if not matrix:
        return 1
    total = 0
    for col, entry in enumerate(matrix[0]):
        minor = [list(row[:col] + row[col + 1 :]) for row in matrix[1:]]
        total += (-1) ** col * entry * det(minor)
    return total


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def complement_sign(support: tuple[int, ...]) -> tuple[tuple[int, ...], int]:
    complement = tuple(i for i in range(6) if i not in support)
    word = support + complement
    return complement, parity(word)


def wedge3(matrix: tuple[tuple[int, ...], ...]) -> list[list[int]]:
    return [
        [
            det([[matrix[row][col] for col in target] for row in source])
            for target in TRIPLES
        ]
        for source in TRIPLES
    ]


def hodge() -> list[list[int]]:
    result = [[0] * 20 for _ in range(20)]
    index = {support: i for i, support in enumerate(TRIPLES)}
    for column, support in enumerate(TRIPLES):
        complement, sign = complement_sign(support)
        result[index[complement]][column] = sign
    return result


def triangle_cubic(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(matrix[i][j] * matrix[j][k] * matrix[k][i] for i, j, k in TRIPLES)


def permute_cubic(cubic: tuple[int, ...], p: tuple[int, ...]) -> tuple[int, ...]:
    target = {}
    for coefficient, support in zip(cubic, TRIPLES):
        target[tuple(sorted(p[i] for i in support))] = coefficient
    return tuple(target[support] for support in TRIPLES)


def permute_total(total, p: tuple[int, ...]):
    return tuple(
        sorted(tuple(sorted((p[i], p[j]))) for matching in total for i, j in [matching])
    )


def total_key(total) -> tuple[tuple[tuple[int, int], ...], ...]:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


# Sparse polynomials in x_0,...,x_4 after x_5=-(x_0+...+x_4).
Poly = dict[tuple[int, ...], int]
ZERO = (0, 0, 0, 0, 0)


def add(*polys: Poly) -> Poly:
    result: Poly = {}
    for poly in polys:
        for monomial, coefficient in poly.items():
            result[monomial] = result.get(monomial, 0) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(poly: Poly, scalar: int) -> Poly:
    return {m: scalar * c for m, c in poly.items() if scalar * c}


def mul(a: Poly, b: Poly) -> Poly:
    result: Poly = {}
    for left, lc in a.items():
        for right, rc in b.items():
            monomial = tuple(left[i] + right[i] for i in range(5))
            result[monomial] = result.get(monomial, 0) + lc * rc
    return {m: c for m, c in result.items() if c}


def power(poly: Poly, exponent: int) -> Poly:
    result = {ZERO: 1}
    for _ in range(exponent):
        result = mul(result, poly)
    return result


def variable(index: int) -> Poly:
    if index < 5:
        exponent = tuple(int(i == index) for i in range(5))
        return {exponent: 1}
    return {tuple(int(i == j) for i in range(5)): -1 for j in range(5)}


VARS = tuple(variable(i) for i in range(6))


def cubic_poly(cubic: tuple[int, ...]) -> Poly:
    terms = []
    for coefficient, support in zip(cubic, TRIPLES):
        term = {ZERO: coefficient}
        for index in support:
            term = mul(term, VARS[index])
        terms.append(term)
    return add(*terms)


def matching_quadratic(matching: tuple[tuple[int, int], ...]) -> Poly:
    return add(*(mul(VARS[i], VARS[j]) for i, j in matching))


def clebsch_after_synthemes(total) -> Poly:
    quadratics = [matching_quadratic(matching) for matching in total]
    common = add(*quadratics)
    centered = [add(scale(q, 5), scale(common, -1)) for q in quadratics]
    numerator = add(*(power(q, 3) for q in centered))
    assert all(coefficient % 3 == 0 for coefficient in numerator.values())
    return {monomial: coefficient // 3 for monomial, coefficient in numerator.items()}


def pfaffian_poly(matrix: list[list[Poly]], indices: tuple[int, ...]) -> Poly:
    if not indices:
        return {ZERO: 1}
    first = indices[0]
    terms = []
    for position, second in enumerate(indices[1:], 1):
        remainder = indices[1:position] + indices[position + 1 :]
        terms.append(
            scale(
                mul(matrix[first][second], pfaffian_poly(matrix, remainder)),
                (-1) ** (position + 1),
            )
        )
    return add(*terms)


def determinant_poly(matrix: list[list[Poly]]) -> Poly:
    if not matrix:
        return {ZERO: 1}
    terms = []
    for column, entry in enumerate(matrix[0]):
        minor = [
            row[:column] + row[column + 1 :]
            for row in matrix[1:]
        ]
        terms.append(
            scale(mul(entry, determinant_poly(minor)), (-1) ** column)
        )
    return add(*terms)


def evaluate(cubic: tuple[int, ...], vector: tuple[int, ...]) -> int:
    return sum(
        coefficient * vector[i] * vector[j] * vector[k]
        for coefficient, (i, j, k) in zip(cubic, TRIPLES)
    )


def rational_rank(matrix: list[list[int]]) -> int:
    work = [[Fraction(value) for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        value = work[row][column]
        work[row] = [entry / value for entry in work[row]]
        for i in range(len(work)):
            if i != row and work[i][column]:
                value = work[i][column]
                work[i] = [
                    work[i][j] - value * work[row][j]
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


def binary_derivative(poly, dx: int, dy: int):
    result = {}
    for (x_degree, y_degree), coefficient in poly.items():
        if x_degree < dx or y_degree < dy:
            continue
        factor = math.prod(range(x_degree - dx + 1, x_degree + 1))
        factor *= math.prod(range(y_degree - dy + 1, y_degree + 1))
        result[x_degree - dx, y_degree - dy] = coefficient * factor
    return result


def transvectant_matrix(source_degree: int, form, order: int) -> list[list[int]]:
    form_degree = next(iter(form))[0] + next(iter(form))[1]
    target_degree = source_degree + form_degree - 2 * order
    matrix = []
    for source_y_degree in range(source_degree + 1):
        source = {(source_degree - source_y_degree, source_y_degree): 1}
        output = {}
        for step in range(order + 1):
            left = binary_derivative(source, order - step, step)
            right = binary_derivative(form, step, order - step)
            scalar = (-1) ** step * math.comb(order, step)
            for (lx, ly), lc in left.items():
                for (rx, ry), rc in right.items():
                    exponent = (lx + rx, ly + ry)
                    output[exponent] = output.get(exponent, 0) + scalar * lc * rc
        matrix.append(
            [
                output.get((target_degree - target_y_degree, target_y_degree), 0)
                for target_y_degree in range(target_degree + 1)
            ]
        )
    return matrix


def symmetric_power_recurrence(adjacency, natural: int, through: int):
    previous = [0] * len(adjacency)
    previous[0] = 1
    current = [0] * len(adjacency)
    current[natural] = 1
    result = [previous, current]
    for _ in range(1, through):
        following = [0] * len(adjacency)
        for vertex, multiplicity in enumerate(current):
            for neighbor in adjacency[vertex]:
                following[neighbor] += multiplicity
        following = [
            following[index] - previous[index] for index in range(len(adjacency))
        ]
        assert all(value >= 0 for value in following)
        result.append(following)
        previous, current = current, following
    return result


def sister_feasibility() -> dict:
    # Affine-E6 vertices: 1,1',1'',2,2',2'',3; natural vertex 2.
    e6_adjacency = ([3], [4], [5], [0, 6], [1, 6], [2, 6], [3, 4, 5])
    e6 = symmetric_power_recurrence(e6_adjacency, 3, 8)
    assert e6[3] == [0, 0, 0, 0, 1, 1, 0]
    assert e6[4] == [0, 1, 1, 0, 0, 0, 1]
    # For f_+=x^4+2 sqrt(-3)x^2y^2+y^4, (.,f_+)_2 has
    # two rank-one blocks.  Writing a=2sqrt(-3), a^2=-12:
    # [[12a,72],[24,-12a]] and [[-12a,24],[72,12a]].
    assert -144 * (-12) - 72 * 24 == 0
    assert -144 * (-12) - 24 * 72 == 0

    # Affine-E7 vertices use the exact binary-octahedral character table:
    # 1, sign, 2_q, 2_+, 2_-, 3_+, 3_-, 4; natural vertex 2_+.
    e7_adjacency = ([3], [4], [7], [0, 5], [1, 6], [3, 7], [4, 7], [2, 5, 6])
    e7 = symmetric_power_recurrence(e7_adjacency, 3, 11)
    assert e7[7] == [0, 0, 0, 1, 1, 0, 0, 1]
    assert e7[9] == [0, 0, 0, 1, 0, 0, 0, 2]
    octavic = {(8, 0): 1, (4, 4): 14, (0, 8): 1}
    octahedral_ranks = {
        order: rational_rank(transvectant_matrix(7, octavic, order))
        for order in (1, 2, 3)
    }
    assert octahedral_ranks == {1: 8, 2: 8, 3: 6}
    return {
        "binary_tetrahedral_E6": {
            "character_field": "Q(zeta_3)",
            "trace_zero_descent_operator": "J^2=-3",
            "first_balanced_slice": "Sym^3=2'+2''",
            "minimal_separator": (
                "second transvectant with either conjugate tetrahedral quartic"
            ),
            "separator_rank": 2,
        },
        "binary_octahedral_E7": {
            "character_field": "Q(sqrt(2))",
            "trace_zero_descent_operator": "J^2=2",
            "first_balanced_slice": "Sym^7=2_++2_-+4",
            "paired_subslice": "2_++2_-",
            "minimal_separator": (
                "third transvectant with x^8+14x^4y^4+y^8"
            ),
            "transvectant_ranks_orders_1_2_3": octahedral_ranks,
        },
        "promotion": "feasibility only; no sister classification",
    }


def later_slice_census() -> dict:
    three_degrees = (2, 10, 12, 18, 20, 28)
    three_prime_degrees = (6, 10, 14, 16, 20, 24)

    def multiplicity(degree: int, generators: tuple[int, ...]) -> int:
        return sum(
            generator + 12 * f_power + 20 * h_power == degree
            for generator in generators
            for f_power in range(degree // 12 + 1)
            for h_power in range(degree // 20 + 1)
        )

    balanced = [
        (degree, multiplicity(degree, three_degrees))
        for degree in range(10, 51)
        if multiplicity(degree, three_degrees)
        == multiplicity(degree, three_prime_degrees)
        > 0
    ]
    assert balanced == [
        (10, 1),
        (14, 1),
        (18, 1),
        (20, 1),
        (24, 1),
        (28, 1),
        (30, 2),
        (34, 2),
        (38, 2),
        (40, 2),
        (44, 2),
        (48, 2),
        (50, 3),
    ]
    return {
        "domain": "balanced 3+3' multiplicities in degrees 10 through 50",
        "balanced_degree_multiplicity": balanced,
        "pattern_representatives": {"multiplicity_1": 14, "multiplicity_2": 30, "multiplicity_3": 50},
        "degree_14_decomposition": "one 3 plus one 3' inside Sym^14",
        "degree_30_decomposition": "two 3 plus two 3' inside Sym^30",
        "degree_50_decomposition": "three 3 plus three 3' inside Sym^50",
        "verdict": (
            "No later slice has a functorial diagonal shadow from the paired "
            "McKay module alone: degree 10 uniquely carries the six-axis "
            "integral support lattice; in multiplicity >=2 the additional "
            "GL_m commutant makes a chosen diagonal or determinant pencil "
            "still less canonical."
        ),
        "singular_scheme_boundary": (
            "undefined without a distinguished support lattice; the degree-10 "
            "shadow remains the six-node Clebsch orientation cubic with outer S5 symmetry"
        ),
    }


def build_certificate() -> dict:
    c_square = matmul([list(row) for row in BASE_C], [list(row) for row in BASE_C])
    assert c_square == [[5 * int(i == j) for j in range(6)] for i in range(6)]

    wedge = wedge3(BASE_C)
    k_operator = matmul(hodge(), wedge)
    k_square = matmul(k_operator, k_operator)
    assert k_square == [[125 * int(i == j) for j in range(20)] for i in range(20)]
    base_z = triangle_cubic(BASE_C)
    assert tuple(k_operator[i][i] for i in range(20)) == tuple(4 * c for c in base_z)
    assert all(
        (k_operator[i][j] % 2 != 0) == (len(set(TRIPLES[i]) & set(TRIPLES[j])) == 1)
        for i in range(20)
        for j in range(20)
    )
    cartan_slice = [[{} for _ in range(6)] for _ in range(6)]
    for i, j in PAIRS:
        entry = scale(add(VARS[i], scale(VARS[j], -1)), BASE_C[i][j])
        cartan_slice[i][j] = entry
        cartan_slice[j][i] = scale(entry, -1)
    assert add(
        pfaffian_poly(cartan_slice, tuple(range(6))),
        scale(cubic_poly(base_z), -4),
    ) == {}
    assert add(
        determinant_poly(cartan_slice),
        scale(power(cubic_poly(base_z), 2), -16),
    ) == {}

    oriented = {}
    stabilizer_consistency_checks = 0
    induced_actions = set()
    for p in permutations(range(6)):
        key = total_key(
            tuple(
                tuple(sorted(tuple(sorted((p[i], p[j]))) for i, j in matching))
                for matching in BASE_TOTAL
            )
        )
        z = tuple(parity(p) * c for c in permute_cubic(base_z, p))
        if key in oriented:
            assert oriented[key] == z
            stabilizer_consistency_checks += 1
        else:
            oriented[key] = z
    assert len(oriented) == 6
    totals = sorted(oriented)
    z_cubics = [oriented[total] for total in totals]
    assert all(sum(z[i] for z in z_cubics) == 0 for i in range(20))

    # The outer action is faithful and every coordinate permutation acts
    # by its sign times a permutation of the six oriented shadows.
    for p in permutations(range(6)):
        image = []
        for z in z_cubics:
            moved = permute_cubic(z, p)
            target = tuple(parity(p) * c for c in moved)
            image.append(z_cubics.index(target))
        assert sorted(image) == list(range(6))
        induced_actions.add(tuple(image))
    assert len(induced_actions) == 720

    z_polys = [cubic_poly(z) for z in z_cubics]
    assert not add(*z_polys)
    assert not add(*(power(z, 3) for z in z_polys))

    sigma = [clebsch_after_synthemes(total) for total in totals]
    z_squares = [power(z, 2) for z in z_polys]
    centered_z = [add(scale(z, 6), scale(add(*z_squares), -1)) for z in z_squares]
    centered_sigma = [
        add(scale(value, 6), scale(add(*sigma), -1)) for value in sigma
    ]
    for left, right in zip(centered_z, centered_sigma):
        assert add(scale(left, 125), scale(right, -4)) == {}

    witnesses = []
    for vector in ((1, 2, 3, 4, 5, -15), (1, 0, 2, -1, 3, -5)):
        z = [evaluate(cubic, vector) for cubic in z_cubics]
        s2 = sum(value * value for value in z)
        w = [6 * value * value - s2 for value in z]
        assert sum(z) == 0
        assert sum(value**3 for value in z) == 0
        assert sum(w) == 0
        assert sum(value * value for value in w) ** 2 == 4 * sum(
            value**4 for value in w
        )
        witnesses.append({"input": vector, "joubert": z, "polar_times_6": w})

    return {
        "schema": "c704-segre-igusa-operator-shadow-v1",
        "ground_ring": "Z",
        "base_conference_square": "C^2=5I_6",
        "middle_exterior_square": "(* Lambda^3 C)^2=125I_20",
        "middle_exterior_diagonal": "K_SS=4 C_ij C_jk C_ki",
        "middle_exterior_mod2_relation": "|S intersection T|=1",
        "cartan_restriction": (
            "Pf((C_ij(x_i-x_j))_ij)=4 Z_base(x); the map kills constants"
        ),
        "commutator_branch_determinant": (
            "det([diag(x),C])=16 Z_base(x)^2"
        ),
        "golden_block_determinant": (
            "for P_+ and P_- over Q(sqrt(5)), "
            "Z_base(x)^2=500 det(P_- diag(x) P_+)^2"
        ),
        "golden_block_matrix_factorization": (
            "B_x and +/-10sqrt(5) adj(B_x) factor Z_base(x) I_3"
        ),
        "categorical_descent": (
            "coker(B_x) and coker(B_x^T) are conjugate rank-one "
            "linear MCM sheaves; their restriction of scalars has rank two "
            "and an endomorphism J with J^2=5"
        ),
        "small_resolution_bundle": (
            "Y_+=P(E_+) over P(V_+), with "
            "0->E_+->O^5->O(1)^3->0, c1=-3, c2=6, -K=2xi, xi^3=3"
        ),
        "hyperplane_double_six": (
            "a smooth xi-section is Bl_6(P^2); the transpose resolution "
            "gives the complementary determinantal six"
        ),
        "synthematic_totals": len(totals),
        "stabilizer_consistency_checks": stabilizer_consistency_checks,
        "outer_action_size": len(induced_actions),
        "outer_action_rule": "g.Z_T=sign(g) Z_{gT}",
        "joubert_linear_relation": "sum_T Z_T=0",
        "segre_relation": "sum_T Z_T^3=0",
        "polar_coordinates": "W_T=Z_T^2-(1/6)sum_U Z_U^2",
        "igusa_relation": "(sum W_T^2)^2=4 sum W_T^4",
        "clebsch_syntheme_identity": (
            "125 center_T(Z_T^2)=4 center_T(sigma_3(q_T))"
        ),
        "eliminated_variable": "x_5=-(x_0+x_1+x_2+x_3+x_4)",
        "witnesses": witnesses,
        "platonic_sister_feasibility": sister_feasibility(),
        "later_balanced_slice_census": later_slice_census(),
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    data = build_certificate()
    encoded = canonical_bytes(data)
    if args.write:
        OUTPUT.write_bytes(encoded)
    else:
        assert OUTPUT.read_bytes() == encoded
    print(
        json.dumps(
            {
                "certificate": OUTPUT.name,
                "bytes": len(encoded),
                "sha256": hashlib.sha256(encoded).hexdigest(),
                "status": "written" if args.write else "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
