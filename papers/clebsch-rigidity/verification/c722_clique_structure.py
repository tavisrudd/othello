#!/usr/bin/env python3
"""Exact C722 audit for the q=9 and q=13 clique-structure branches."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
ARTIFACT = ROOT / "c722_clique_structure.json"

Q9_DISTANCE_TWO_MASKS = (
    53594597232, 54622190240, 33466854864, 50697329312,
    63824194053, 58724112139, 14964046341, 15700999438,
    31119556773, 43984470139, 59650584741, 46500376798,
    56823057642, 61057862871, 16554789690, 16866674493,
    54456794716, 55269416380, 32811049815, 49179284459,
    46289315251, 59240701555, 45030815181, 33219238862,
    51006779082, 22821109191, 63096202170, 22831944573,
    60377693011, 21572204515, 47437237341, 21570768062,
    3953972716, 1440541660, 3198629175, 1434140219,
)
Q9_COLORS = (
    0, 1, 0, 1, 1, 4, 1, 4, 1, 2, 1, 2,
    0, 3, 0, 3, 4, 3, 4, 3, 2, 3, 2, 3,
    0, 5, 0, 5, 4, 5, 4, 5, 2, 5, 2, 5,
)
Q9_FIVE_CLIQUE = (0, 4, 9, 18, 21)

Q13_DIFFERENCES = {
    (0, 0): (4, 6, 8, 10),
    (0, 1): (6, 7, 11, 12),
    (0, 2): (1, 3),
    (1, 1): (6, 8),
    (1, 2): (3, 5, 6, 8, 9, 11),
    (2, 2): (2, 4, 10, 12),
}
Q13_COLORS = (
    4, 4, 4, 2, 1, 1, 5, 3, 3, 3, 0, 0, 2, 5,
    0, 5, 2, 3, 1, 4, 1, 2, 1, 1, 4, 0, 3, 1,
    2, 0, 3, 2, 0, 3, 4, 0, 5, 2, 0, 5, 4, 3,
)
Q13_FIVE_CLIQUE = ((0, 0), (1, 6), (1, 12), (2, 1), (2, 3))


def matrix_from_masks(masks: tuple[int, ...]) -> list[list[int]]:
    n = len(masks)
    return [[int(bool(masks[i] & (1 << j))) for j in range(n)] for i in range(n)]


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    n = len(a)
    return [
        [sum(a[i][k] * b[k][j] for k in range(n)) for j in range(n)]
        for i in range(n)
    ]


def matrix_traces(a: list[list[int]]) -> list[int]:
    n = len(a)
    power = [row[:] for row in a]
    traces: list[int] = []
    for _ in range(n):
        traces.append(sum(power[i][i] for i in range(n)))
        power = matmul(power, a)
    return traces


def charpoly_from_traces(traces: list[int]) -> list[int]:
    """Characteristic coefficients by exact Newton identities, leading first."""
    n = len(traces)
    coefficients = [1]
    for k in range(1, n + 1):
        numerator = -sum(
            coefficients[k - i] * traces[i - 1] for i in range(1, k + 1)
        )
        assert numerator % k == 0
        coefficients.append(numerator // k)
    return coefficients


def charpoly(a: list[list[int]]) -> list[int]:
    return charpoly_from_traces(matrix_traces(a))


def trim(poly: list[Fraction]) -> list[Fraction]:
    first = 0
    while first + 1 < len(poly) and poly[first] == 0:
        first += 1
    return poly[first:]


def poly_divmod(
    numerator: list[Fraction], denominator: list[Fraction]
) -> tuple[list[Fraction], list[Fraction]]:
    numerator = numerator[:]
    quotient = [Fraction(0)] * max(1, len(numerator) - len(denominator) + 1)
    while len(numerator) >= len(denominator) and any(numerator):
        coefficient = numerator[0] / denominator[0]
        offset = len(numerator) - len(denominator)
        quotient[len(quotient) - offset - 1] = coefficient
        for index, value in enumerate(denominator):
            numerator[index] -= coefficient * value
        numerator = trim(numerator)
    return trim(quotient), trim(numerator)


def monic(poly: list[Fraction]) -> list[Fraction]:
    poly = trim(poly)
    return [value / poly[0] for value in poly]


def poly_gcd(first: list[Fraction], second: list[Fraction]) -> list[Fraction]:
    first, second = trim(first), trim(second)
    while second != [0]:
        _, remainder = poly_divmod(first, second)
        first, second = second, remainder
    return monic(first)


def squarefree_factors(poly: list[Fraction]) -> list[tuple[list[Fraction], int]]:
    degree = len(poly) - 1
    derivative = [poly[i] * (degree - i) for i in range(degree)]
    common = poly_gcd(poly, derivative)
    quotient, remainder = poly_divmod(poly, common)
    assert remainder == [0]
    current = monic(quotient)
    factors: list[tuple[list[Fraction], int]] = []
    multiplicity = 1
    while len(current) > 1:
        overlap = poly_gcd(current, common)
        factor, remainder = poly_divmod(current, overlap)
        assert remainder == [0]
        factor = monic(factor)
        if len(factor) > 1:
            factors.append((factor, multiplicity))
        current = overlap
        quotient, remainder = poly_divmod(common, overlap)
        assert remainder == [0]
        common = monic(quotient)
        multiplicity += 1
    assert len(common) == 1
    return factors


def squarefree_sturm_inertia(poly: list[Fraction]) -> tuple[int, int, int]:
    degree = len(poly) - 1
    derivative = [poly[i] * (degree - i) for i in range(degree)]
    sequence = [trim(poly), trim(derivative)]
    while sequence[-1] != [0]:
        _, remainder = poly_divmod(sequence[-2], sequence[-1])
        if remainder == [0]:
            break
        sequence.append([-value for value in remainder])

    def variations(where: str) -> int:
        signs: list[int] = []
        for item in sequence:
            if where == "plus_infinity":
                value = item[0]
            elif where == "minus_infinity":
                value = item[0] * (-1 if (len(item) - 1) % 2 else 1)
            else:
                value = item[-1]
            if value:
                signs.append(1 if value > 0 else -1)
        return sum(first != second for first, second in zip(signs, signs[1:]))

    negative = variations("minus_infinity") - variations("zero")
    positive = variations("zero") - variations("plus_infinity")
    return positive, negative, len(poly) - 1 - positive - negative


def sturm_inertia(coefficients: list[int]) -> tuple[int, int, int]:
    totals = [0, 0, 0]
    for factor, multiplicity in squarefree_factors(
        [Fraction(value) for value in coefficients]
    ):
        inertia = squarefree_sturm_inertia(factor)
        for index in range(3):
            totals[index] += multiplicity * inertia[index]
    return tuple(totals)


def is_clique(matrix: list[list[int]], vertices: tuple[int, ...]) -> bool:
    return all(matrix[u][v] for i, u in enumerate(vertices) for v in vertices[i + 1 :])


def proper_coloring(matrix: list[list[int]], colors: tuple[int, ...]) -> bool:
    return all(
        not matrix[i][j] or colors[i] != colors[j]
        for i in range(len(matrix))
        for j in range(i + 1, len(matrix))
    )


def q9_record() -> dict[str, object]:
    adjacency = matrix_from_masks(Q9_DISTANCE_TWO_MASKS)
    assert all(adjacency[i][i] == 0 for i in range(36))
    assert all(adjacency[i][j] == adjacency[j][i] for i in range(36) for j in range(36))
    assert {sum(row) for row in adjacency} == {20}
    expected_charpoly = [1]
    for eigenvalue, multiplicity in ((20, 1), (4, 9), (-1, 16), (-4, 10)):
        for _ in range(multiplicity):
            next_poly = [0] * (len(expected_charpoly) + 1)
            for index, coefficient in enumerate(expected_charpoly):
                next_poly[index] += coefficient
                next_poly[index + 1] -= eigenvalue * coefficient
            expected_charpoly = next_poly
    assert charpoly(adjacency) == expected_charpoly
    assert proper_coloring(adjacency, Q9_COLORS)
    assert is_clique(adjacency, Q9_FIVE_CLIQUE)

    # P-matrix rows for theta=5,2,-1,-3 and distances 0,1,2,3.
    eigenmatrix = (
        (1, 5, 20, 10),
        (1, 2, -1, -2),
        (1, -1, -4, 4),
        (1, -3, 4, -2),
    )
    multiplicities = (1, 16, 10, 9)
    valencies = eigenmatrix[0]
    assert [sum(multiplicities[r] * eigenmatrix[r][i] for r in range(4)) for i in range(4)] == [36, 0, 0, 0]
    equality_transform = [
        Fraction(1) + 5 * Fraction(eigenmatrix[row][2], valencies[2])
        for row in range(4)
    ]

    def intersection_number(first: int, second: int, relation: int) -> int:
        numerator = sum(
            multiplicities[row]
            * eigenmatrix[row][first]
            * eigenmatrix[row][second]
            * eigenmatrix[row][relation]
            for row in range(4)
        )
        denominator = 36 * valencies[relation]
        assert numerator % denominator == 0
        return numerator // denominator

    assert intersection_number(3, 3, 2) == 2
    assert intersection_number(1, 3, 2) == 2

    return {
        "vertices": 36,
        "intersection_array": {"b": [5, 4, 2], "c": [1, 1, 4]},
        "distance_layer_sizes": [1, 5, 20, 10],
        "distance_two_spectrum": [[20, 1], [4, 9], [-1, 16], [-4, 10]],
        "delsarte_clique_bound": 6,
        "equality_delsarte_transform": [str(value) for value in equality_transform],
        "bound_row": {
            "sylvester_eigenvalue": -1,
            "normalized_distance_two_cosine": "-1/5",
            "inequality": "1-(c-1)/5 >= 0",
        },
        "equality_condition": {
            "primitive_idempotent_projection": "E_{-1} chi_C = 0",
            "pointwise": "5 n0-n1-n2+2 n3=0",
            "simplified_for_c=6": "2 n0+n3=2",
            "consequence": "A3 chi_C=2(1-chi_C)",
            "scheme_feasibility": "not contradictory",
            "supporting_intersection_numbers": {"p_33^2": 2, "p_13^2": 2},
            "local_multigraph": "for each clique vertex, the five Gamma_1 vertices define a 2-regular five-edge multigraph on the other five clique vertices: C5 or C3 plus a doubled edge",
        },
        "six_coloring_class_sizes": [Q9_COLORS.count(color) for color in range(6)],
        "five_clique_witness": list(Q9_FIVE_CLIQUE),
    }


def q13_adjacency() -> tuple[list[tuple[int, int]], list[list[int]]]:
    vertices = [(orbit, index) for orbit in range(3) for index in range(14)]

    def adjacent(first: tuple[int, int], second: tuple[int, int]) -> bool:
        if first == second:
            return False
        if first[0] <= second[0]:
            difference = (second[1] - first[1]) % 14
            return difference in Q13_DIFFERENCES[first[0], second[0]]
        difference = (first[1] - second[1]) % 14
        return difference in Q13_DIFFERENCES[second[0], first[0]]

    matrix = [[int(adjacent(first, second)) for second in vertices] for first in vertices]
    return vertices, matrix


def group_zero() -> list[int]:
    return [0] * 14


def group_add(first: list[int], second: list[int]) -> list[int]:
    return [first[i] + second[i] for i in range(14)]


def group_neg(first: list[int]) -> list[int]:
    return [-value for value in first]


def group_mul(first: list[int], second: list[int]) -> list[int]:
    answer = group_zero()
    for i, left in enumerate(first):
        for j, right in enumerate(second):
            answer[(i + j) % 14] += left * right
    return answer


def group_sum(*terms: list[int]) -> list[int]:
    answer = group_zero()
    for term in terms:
        answer = group_add(answer, term)
    return answer


def group_monomials(exponents: tuple[int, ...], negate_exponents: bool = False) -> list[int]:
    answer = group_zero()
    for exponent in exponents:
        answer[(-exponent if negate_exponents else exponent) % 14] += 1
    return answer


def determinant_three(matrix: list[list[list[int]]]) -> list[int]:
    positive = group_sum(
        group_mul(matrix[0][0], group_mul(matrix[1][1], matrix[2][2])),
        group_mul(matrix[0][1], group_mul(matrix[1][2], matrix[2][0])),
        group_mul(matrix[0][2], group_mul(matrix[1][0], matrix[2][1])),
    )
    negative = group_sum(
        group_mul(matrix[0][2], group_mul(matrix[1][1], matrix[2][0])),
        group_mul(matrix[0][1], group_mul(matrix[1][0], matrix[2][2])),
        group_mul(matrix[0][0], group_mul(matrix[1][2], matrix[2][1])),
    )
    return group_add(positive, group_neg(negative))


def group_matrix_mul(
    first: list[list[list[int]]], second: list[list[list[int]]]
) -> list[list[list[int]]]:
    size = len(first)
    return [
        [group_sum(*(group_mul(first[i][k], second[k][j]) for k in range(size))) for j in range(size)]
        for i in range(size)
    ]


def cyclotomic(order: int) -> list[int]:
    return {
        1: [1, -1],
        2: [1, 1],
        7: [1, 1, 1, 1, 1, 1, 1],
        14: [1, -1, 1, -1, 1, -1, 1],
    }[order]


def reduce_at_character(poly: list[int], character: int) -> list[int]:
    common = math.gcd(character, 14)
    order = 14 // common if character else 1
    multiplier = character // common if character else 0
    raw = [0] * order
    for exponent, coefficient in enumerate(poly):
        raw[(multiplier * exponent) % order] += coefficient
    modulus = cyclotomic(order)
    while len(raw) >= len(modulus):
        coefficient = raw[-1]
        if coefficient:
            offset = len(raw) - len(modulus)
            for index, value in enumerate(reversed(modulus)):
                raw[offset + len(modulus) - 1 - index] -= coefficient * value
        raw.pop()
    degree = len(modulus) - 1
    return raw + [0] * (degree - len(raw))


def q13_fourier_coefficients() -> tuple[list[int], list[int], list[int], list[int]]:
    block = [[group_zero() for _ in range(3)] for _ in range(3)]
    for first in range(3):
        for second in range(first, 3):
            block[first][second] = group_monomials(Q13_DIFFERENCES[first, second])
            block[second][first] = group_monomials(
                Q13_DIFFERENCES[first, second], negate_exponents=True
            )
    trace = group_sum(block[0][0], block[1][1], block[2][2])
    second = group_sum(
        group_add(group_mul(block[0][0], block[1][1]), group_neg(group_mul(block[0][1], block[1][0]))),
        group_add(group_mul(block[0][0], block[2][2]), group_neg(group_mul(block[0][2], block[2][0]))),
        group_add(group_mul(block[1][1], block[2][2]), group_neg(group_mul(block[1][2], block[2][1]))),
    )
    determinant = determinant_three(block)
    power = [[entry[:] for entry in row] for row in block]
    fourier_traces = []
    for _ in range(42):
        block_trace = group_sum(power[0][0], power[1][1], power[2][2])
        fourier_traces.append(14 * block_trace[0])
        power = group_matrix_mul(power, block)
    return trace, second, determinant, fourier_traces


def q13_record() -> dict[str, object]:
    vertices, adjacency = q13_adjacency()
    assert all(adjacency[i][j] == adjacency[j][i] for i in range(42) for j in range(42))
    assert [sum(adjacency[i]) for i in range(42)] == [10] * 14 + [12] * 28
    assert proper_coloring(adjacency, Q13_COLORS)
    witness_indices = tuple(vertices.index(vertex) for vertex in Q13_FIVE_CLIQUE)
    assert is_clique(adjacency, witness_indices)

    adjacency_traces = matrix_traces(adjacency)
    coefficients = charpoly_from_traces(adjacency_traces)
    complement = [
        [int(i != j and not adjacency[i][j]) for j in range(42)]
        for i in range(42)
    ]
    complement_coefficients = charpoly(complement)
    trace, second, determinant, fourier_traces = q13_fourier_coefficients()
    assert fourier_traces == adjacency_traces
    character_blocks = []
    for character in range(14):
        order = 14 // math.gcd(character, 14) if character else 1
        character_blocks.append(
            {
                "character": character,
                "cyclotomic_order": order,
                "basis": f"1,z,...,z^{len(cyclotomic(order)) - 2}",
                "charpoly_coefficients": [
                    [1] + [0] * (len(cyclotomic(order)) - 2),
                    reduce_at_character(group_neg(trace), character),
                    reduce_at_character(second, character),
                    reduce_at_character(group_neg(determinant), character),
                ],
            }
        )

    return {
        "vertices": 42,
        "orbit_sizes": [14, 14, 14],
        "degrees_by_orbit": [10, 12, 12],
        "difference_sets": {f"{a}{b}": list(values) for (a, b), values in Q13_DIFFERENCES.items()},
        "fourier_block": "B_k=(sum_{d in D_ab} zeta_14^(kd))_{a<=b}, with B_ba the conjugate entry",
        "universal_fourier_charpoly_group_ring": {
            "ring": "Z[z]/(z^14-1)",
            "lambda3": [1] + [0] * 13,
            "lambda2": group_neg(trace),
            "lambda1": second,
            "lambda0": group_neg(determinant),
        },
        "character_blocks": character_blocks,
        "adjacency_charpoly": coefficients,
        "adjacency_inertia": list(sturm_inertia(coefficients)),
        "complement_charpoly": complement_coefficients,
        "complement_inertia": list(sturm_inertia(complement_coefficients)),
        "direct_adjacency_interlacing_bound": 24,
        "complement_inertia_bound": 20,
        "quotient_charpoly": [1, -10, -24, 88],
        "spectral_radius_interval": [11, 12],
        "rayleigh_clique_bound": 12,
        "six_coloring_class_sizes": [Q13_COLORS.count(color) for color in range(6)],
        "coloring_dual_bound": 6,
        "failed_equality_condition": "a six-clique would be a rainbow transversal of the six independent color classes",
        "five_clique_witness": [list(vertex) for vertex in Q13_FIVE_CLIQUE],
    }


def build_record() -> dict[str, object]:
    return {
        "schema": "c722-clique-structure-v1",
        "q9": q9_record(),
        "q13": q13_record(),
        "boundary": {
            "q9": "Delsarte equality remains feasible in the Sylvester association scheme; exact upper bound five is not promoted",
            "q13": "exact Fourier/inertia analysis does not improve the six-color dual bound; exact upper bound five remains the five-row unique-closure proof",
        },
    }


def canonical_bytes(record: dict[str, object]) -> bytes:
    return (json.dumps(record, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path, default=ARTIFACT)
    args = parser.parse_args()
    generated = canonical_bytes(build_record())
    if args.check:
        expected = args.output.read_bytes()
        if generated != expected:
            raise SystemExit(f"stale artifact: {args.output}")
        print(f"OK {args.output.name} {len(expected)} bytes sha256={hashlib.sha256(expected).hexdigest()}")
        return
    args.output.write_bytes(generated)
    print(f"wrote {args.output} {len(generated)} bytes sha256={hashlib.sha256(generated).hexdigest()}")


if __name__ == "__main__":
    main()
