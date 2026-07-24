#!/usr/bin/env python3
"""Exact C396 checker for the Clebsch AME pencil over finite fields."""

from __future__ import annotations

import argparse
import collections
import hashlib
import importlib.util
import itertools
import json
import sys
from fractions import Fraction
from pathlib import Path
from typing import Iterable, Sequence

HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-20-c395-clebsch-ame-pencil-arithmetic.py"
INPUT_SHA256 = "a9dd5ba6e4344142a6ec368c86310a08bd307a2a78501c9af708ac7e2abb6b52"
CERTIFICATE = HERE / "2026-07-23-c396-holonomy-completeness.json"


def load_input():
    digest = hashlib.sha256(INPUT.read_bytes()).hexdigest()
    if digest != INPUT_SHA256:
        raise AssertionError(f"stale C395 input: {digest}")
    spec = importlib.util.spec_from_file_location("c395_c396_input", INPUT)
    if spec is None or spec.loader is None:
        raise AssertionError("cannot load C395 input")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


C395 = load_input()
FiniteField = C395.FiniteField
Element = tuple[int, ...]
Vector = tuple[Element, ...]
Matrix = tuple[Vector, ...]
PointSet = tuple[Vector, ...]
Matrix2 = tuple[tuple[Element, Element], tuple[Element, Element]]
N = 6
PolyQ = tuple[Fraction, ...]
RatPoly = tuple[PolyQ, PolyQ]


def qtrim(polynomial: Sequence[Fraction | int]) -> PolyQ:
    result = [Fraction(value) for value in polynomial]
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    return tuple(result or [Fraction(0)])


def qadd(left: PolyQ, right: PolyQ) -> PolyQ:
    return qtrim(
        (left[index] if index < len(left) else 0)
        + (right[index] if index < len(right) else 0)
        for index in range(max(len(left), len(right)))
    )


def qneg(polynomial: PolyQ) -> PolyQ:
    return qtrim(-value for value in polynomial)


def qmul(left: PolyQ, right: PolyQ) -> PolyQ:
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return qtrim(result)


def qdivmod(dividend: PolyQ, divisor: PolyQ) -> tuple[PolyQ, PolyQ]:
    if divisor == (Fraction(0),):
        raise ZeroDivisionError("zero polynomial")
    remainder = list(dividend)
    quotient = [Fraction(0)] * max(1, len(dividend) - len(divisor) + 1)
    while len(remainder) >= len(divisor) and any(remainder):
        degree = len(remainder) - len(divisor)
        coefficient = remainder[-1] / divisor[-1]
        quotient[degree] += coefficient
        for index, value in enumerate(divisor):
            remainder[degree + index] -= coefficient * value
        remainder = list(qtrim(remainder))
    return qtrim(quotient), qtrim(remainder)


def qgcd(left: PolyQ, right: PolyQ) -> PolyQ:
    while right != (Fraction(0),):
        _, remainder = qdivmod(left, right)
        left, right = right, remainder
    if left == (Fraction(0),):
        return (Fraction(1),)
    return qtrim(value / left[-1] for value in left)


def rat(num: Sequence[Fraction | int], den: Sequence[Fraction | int] = (1,)) -> RatPoly:
    numerator, denominator = qtrim(num), qtrim(den)
    if denominator == (Fraction(0),):
        raise ZeroDivisionError("zero rational-function denominator")
    common = qgcd(numerator, denominator)
    numerator, remainder_num = qdivmod(numerator, common)
    denominator, remainder_den = qdivmod(denominator, common)
    if remainder_num != (Fraction(0),) or remainder_den != (Fraction(0),):
        raise AssertionError("polynomial gcd division failed")
    if denominator[-1] < 0:
        numerator, denominator = qneg(numerator), qneg(denominator)
    scale_factor = denominator[-1]
    return (
        qtrim(value / scale_factor for value in numerator),
        qtrim(value / scale_factor for value in denominator),
    )


def radd(left: RatPoly, right: RatPoly) -> RatPoly:
    return rat(
        qadd(qmul(left[0], right[1]), qmul(right[0], left[1])),
        qmul(left[1], right[1]),
    )


def rneg(value: RatPoly) -> RatPoly:
    return rat(qneg(value[0]), value[1])


def rsub(left: RatPoly, right: RatPoly) -> RatPoly:
    return radd(left, rneg(right))


def rmul(left: RatPoly, right: RatPoly) -> RatPoly:
    return rat(qmul(left[0], right[0]), qmul(left[1], right[1]))


def rinv(value: RatPoly) -> RatPoly:
    return rat(value[1], value[0])


def rdiv(left: RatPoly, right: RatPoly) -> RatPoly:
    return rmul(left, rinv(right))


def rpow(value: RatPoly, exponent: int) -> RatPoly:
    result = rat((1,))
    for _ in range(exponent):
        result = rmul(result, value)
    return result


def add_many(field: FiniteField, values: Iterable[Element]) -> Element:
    result = field.zero
    for value in values:
        result = field.add(result, value)
    return result


def scale(field: FiniteField, scalar: Element, vector: Sequence[Element]) -> Vector:
    return tuple(field.mul(scalar, value) for value in vector)


def rref(field: FiniteField, rows: Iterable[Sequence[Element]]) -> tuple[Matrix, tuple[int, ...]]:
    a = [list(row) for row in rows]
    if not a:
        return (), ()
    width = len(a[0])
    pivot_columns: list[int] = []
    pivot_row = 0
    for column in range(width):
        pivot = next(
            (row for row in range(pivot_row, len(a)) if a[row][column] != field.zero),
            None,
        )
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        inverse = field.inv(a[pivot_row][column])
        a[pivot_row] = [field.mul(inverse, value) for value in a[pivot_row]]
        for row in range(len(a)):
            if row == pivot_row:
                continue
            coefficient = a[row][column]
            if coefficient == field.zero:
                continue
            a[row] = [
                field.sub(value, field.mul(coefficient, pivot_value))
                for value, pivot_value in zip(a[row], a[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == len(a):
            break
    nonzero = tuple(tuple(row) for row in a if any(value != field.zero for value in row))
    return nonzero, tuple(pivot_columns)


def rowspace(field: FiniteField, rows: Iterable[Sequence[Element]]) -> Matrix:
    return rref(field, rows)[0]


def nullspace(field: FiniteField, rows: Iterable[Sequence[Element]], width: int) -> Matrix:
    reduced, pivots = rref(field, rows)
    free = tuple(column for column in range(width) if column not in pivots)
    result: list[Vector] = []
    for free_column in free:
        vector = [field.zero] * width
        vector[free_column] = field.one
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(reduced[row][free_column])
        result.append(tuple(vector))
    return tuple(result)


def matvec(field: FiniteField, rows: Matrix, vector: Sequence[Element]) -> Vector:
    return tuple(
        add_many(field, (field.mul(value, vector[column]) for column, value in enumerate(row)))
        for row in rows
    )


def matmul_row(field: FiniteField, coefficients: Sequence[Element], rows: Matrix) -> Vector:
    return tuple(
        add_many(field, (field.mul(coefficients[row], rows[row][column]) for row in range(len(rows))))
        for column in range(len(rows[0]))
    )


def inverse(field: FiniteField, rows: Matrix) -> Matrix:
    size = len(rows)
    augmented = tuple(
        tuple(row)
        + tuple(field.one if i == j else field.zero for j in range(size))
        for i, row in enumerate(rows)
    )
    reduced, pivots = rref(field, augmented)
    if pivots[:size] != tuple(range(size)):
        raise ZeroDivisionError("singular matrix")
    return tuple(tuple(row[size:]) for row in reduced)


def canonical_projective(field: FiniteField, vector: Sequence[Element]) -> Vector:
    pivot = next(value for value in vector if value != field.zero)
    return scale(field, field.inv(pivot), vector)


def parity_check(points: Sequence[Vector]) -> Matrix:
    return tuple(tuple(points[column][row] for column in range(N)) for row in range(3))


def code_from_points(field: FiniteField, points: Sequence[Vector]) -> Matrix:
    return nullspace(field, parity_check(points), N)


def dual(field: FiniteField, code: Matrix) -> Matrix:
    return nullspace(field, code, N)


def frame_transform(
    field: FiniteField, points: Sequence[Vector], frame: tuple[int, int, int, int]
) -> Matrix:
    a, b, c, d = (points[index] for index in frame)
    basis = tuple(tuple((a, b, c)[column][row] for column in range(3)) for row in range(3))
    coordinates = matvec(field, inverse(field, basis), d)
    if any(value == field.zero for value in coordinates):
        raise AssertionError("arc frame has a zero coordinate")
    scaled_basis = tuple(
        tuple(field.mul((a, b, c)[column][row], coordinates[column]) for column in range(3))
        for row in range(3)
    )
    return inverse(field, scaled_basis)


def normalize_frame(
    field: FiniteField, points: Sequence[Vector], frame: tuple[int, int, int, int]
) -> PointSet:
    transform = frame_transform(field, points, frame)
    return tuple(
        sorted(canonical_projective(field, matvec(field, transform, point)) for point in points)
    )


def canonical_arc(field: FiniteField, points: Sequence[Vector]) -> PointSet:
    return min(
        normalize_frame(field, points, frame)
        for frame in itertools.permutations(range(N), 4)
    )


def pairwise_projectively_equivalent(
    field: FiniteField, left: Sequence[Vector], right: Sequence[Vector]
) -> bool:
    left_normal = normalize_frame(field, left, (0, 1, 2, 3))
    return any(
        left_normal == normalize_frame(field, right, frame)
        for frame in itertools.permutations(range(N), 4)
    )


def normalizing_witness(
    field: FiniteField, points: Sequence[Vector], target: PointSet
) -> dict[str, object]:
    for frame in itertools.permutations(range(N), 4):
        transform = frame_transform(field, points, frame)
        transformed = tuple(matvec(field, transform, point) for point in points)
        normalized = tuple(canonical_projective(field, point) for point in transformed)
        if tuple(sorted(normalized)) != target:
            continue
        party_map = tuple(target.index(point) for point in normalized)
        scalars = tuple(next(value for value in point if value != field.zero) for point in transformed)
        return {
            "frame": list(frame),
            "row_transform": [[list(value) for value in row] for row in transform],
            "source_to_canonical_party": list(party_map),
            "column_scalars": [list(value) for value in scalars],
        }
    raise AssertionError("no normalizing witness")


def shortened_word(
    field: FiniteField, code: Matrix, omitted: tuple[int, int]
) -> Vector:
    equations = tuple(tuple(code[row][party] for row in range(len(code))) for party in omitted)
    coefficients = nullspace(field, equations, len(code))
    if len(coefficients) != 1:
        raise AssertionError("shortening is not one-dimensional")
    word = canonical_projective(field, matmul_row(field, coefficients[0], code))
    support = tuple(index for index, value in enumerate(word) if value != field.zero)
    if support != tuple(index for index in range(N) if index not in omitted):
        raise AssertionError("shortened word support mismatch")
    return word


def minimal_support_data(
    field: FiniteField, code: Matrix
) -> dict[tuple[int, ...], tuple[Vector, Vector]]:
    code_dual = dual(field, code)
    result = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(index for index in range(N) if index not in omitted)
        result[support] = (
            shortened_word(field, code, omitted),
            shortened_word(field, code_dual, omitted),
        )
    return result


def m2_mul(field: FiniteField, left: Matrix2, right: Matrix2) -> Matrix2:
    return tuple(
        tuple(
            add_many(field, (field.mul(left[i][k], right[k][j]) for k in range(2)))
            for j in range(2)
        )
        for i in range(2)
    )  # type: ignore[return-value]


def m2_det(field: FiniteField, matrix: Matrix2) -> Element:
    return field.sub(field.mul(matrix[0][0], matrix[1][1]), field.mul(matrix[0][1], matrix[1][0]))


def m2_inv(field: FiniteField, matrix: Matrix2) -> Matrix2:
    factor = field.inv(m2_det(field, matrix))
    return (
        (field.mul(factor, matrix[1][1]), field.neg(field.mul(factor, matrix[0][1]))),
        (field.neg(field.mul(factor, matrix[1][0])), field.mul(factor, matrix[0][0])),
    )


def relation(
    field: FiniteField,
    data: dict[tuple[int, ...], tuple[Vector, Vector]],
    support: tuple[int, ...],
    source: int,
    target: int,
) -> Matrix2:
    xword, zword = data[support]
    return (
        (
            field.mul(xword[target], field.inv(xword[source])),
            field.zero,
        ),
        (
            field.zero,
            field.mul(zword[target], field.inv(zword[source])),
        ),
    )


def cycle_signature(field: FiniteField, code: Matrix) -> tuple[tuple[tuple[Element, Element], int], ...]:
    data = minimal_support_data(field, code)
    signature: list[tuple[Element, Element]] = []
    for source, target in itertools.combinations(range(N), 2):
        supports = [
            support for support in sorted(data) if source in support and target in support
        ]
        for first, second in itertools.combinations(supports, 2):
            holonomy = m2_mul(
                field,
                relation(field, data, second, target, source),
                relation(field, data, first, source, target),
            )
            for matrix in (holonomy, m2_inv(field, holonomy)):
                trace = field.add(matrix[0][0], matrix[1][1])
                signature.append((trace, m2_det(field, matrix)))
    if len(signature) != 450:
        raise AssertionError("holonomy signature length mismatch")
    return tuple(sorted(collections.Counter(signature).items()))


def stabilizer_space(field: FiniteField, code: Matrix) -> Matrix:
    zero = (field.zero,) * N
    return rowspace(
        field,
        tuple(tuple(row) + zero for row in code)
        + tuple(zero + tuple(row) for row in dual(field, code)),
    )


def cycle_signature_lagrangian_replay(
    field: FiniteField, code: Matrix
) -> tuple[tuple[tuple[Element, Element], int], ...]:
    stabilizer = stabilizer_space(field, code)
    projections: dict[tuple[int, ...], dict[int, Matrix2]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(index for index in range(N) if index not in omitted)
        equations = tuple(
            tuple(stabilizer[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(field, equations, N)
        if len(coefficients) != 2:
            raise AssertionError("Lagrangian shortening dimension mismatch")
        projections[support] = {}
        for party in support:
            projection = tuple(
                (
                    matmul_row(field, coefficients[row], stabilizer)[party],
                    matmul_row(field, coefficients[row], stabilizer)[N + party],
                )
                for row in range(2)
            )
            projections[support][party] = projection  # type: ignore[assignment]
    signature: list[tuple[Element, Element]] = []
    for source, target in itertools.combinations(range(N), 2):
        supports = [
            support for support in sorted(projections) if source in support and target in support
        ]
        for first, second in itertools.combinations(supports, 2):
            first_transition = m2_mul(
                field,
                m2_inv(field, projections[first][target]),
                projections[first][source],
            )
            second_transition = m2_mul(
                field,
                m2_inv(field, projections[second][source]),
                projections[second][target],
            )
            holonomy = m2_mul(field, second_transition, first_transition)
            for matrix in (holonomy, m2_inv(field, holonomy)):
                signature.append(
                    (field.add(matrix[0][0], matrix[1][1]), m2_det(field, matrix))
                )
    return tuple(sorted(collections.Counter(signature).items()))


def span_rank(field: FiniteField, spaces: Sequence[Matrix]) -> int:
    return len(rowspace(field, tuple(row for space in spaces for row in space)))


def stabilizer_shortenings(field: FiniteField, code: Matrix) -> tuple[Matrix, ...]:
    stabilizer = stabilizer_space(field, code)
    result = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(field, equations, N)
        if len(coefficients) != 2:
            raise AssertionError("four-party shortening dimension mismatch")
        result.append(coefficients)
    return tuple(result)


def moment_distribution(field: FiniteField, code: Matrix) -> tuple[tuple[int, int], ...]:
    spaces = stabilizer_shortenings(field, code)
    return tuple(
        sorted(
            collections.Counter(
                span_rank(field, (spaces[i], spaces[j], spaces[k]))
                for i, j, k in itertools.combinations(range(15), 3)
            ).items()
        )
    )


def moment_distribution_lagrangian_replay(
    field: FiniteField, code: Matrix
) -> tuple[tuple[int, int], ...]:
    stabilizer = stabilizer_space(field, code)
    spaces = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(field, equations, N)
        spaces.append(
            rowspace(
                field,
                tuple(matmul_row(field, coefficient, stabilizer) for coefficient in coefficients),
            )
        )
    return tuple(
        sorted(
            collections.Counter(
                span_rank(field, (spaces[i], spaces[j], spaces[k]))
                for i, j, k in itertools.combinations(range(15), 3)
            ).items()
        )
    )


def encode_element(value: Element) -> int | list[int]:
    return value[0] if len(value) == 1 else list(value)


def encode_points(points: PointSet) -> list[list[int | list[int]]]:
    return [[encode_element(value) for value in point] for point in points]


def encode_signature(
    signature: tuple[tuple[tuple[Element, Element], int], ...]
) -> list[dict[str, object]]:
    return [
        {
            "trace": encode_element(trace),
            "determinant": encode_element(determinant),
            "multiplicity": multiplicity,
        }
        for (trace, determinant), multiplicity in signature
    ]


def qdet3(columns: Sequence[Sequence[PolyQ]]) -> PolyQ:
    a, b, c = columns
    return qadd(
        qadd(
            qmul(a[0], qadd(qmul(b[1], c[2]), qneg(qmul(b[2], c[1])))),
            qneg(qmul(b[0], qadd(qmul(a[1], c[2]), qneg(qmul(a[2], c[1]))))),
        ),
        qmul(c[0], qadd(qmul(a[1], b[2]), qneg(qmul(a[2], b[1])))),
    )


def symbolic_holonomy_certificate() -> dict[str, object]:
    zero, one, t = qtrim((0,)), qtrim((1,)), qtrim((0, 1))
    one_minus_t, t_minus_one = qtrim((1, -1)), qtrim((-1, 1))
    points = (
        (zero, one, one_minus_t),
        (zero, one, t_minus_one),
        (one, one_minus_t, zero),
        (one, t_minus_one, zero),
        (one, zero, qneg(t)),
        (one, zero, t),
    )
    data: dict[tuple[int, ...], tuple[tuple[PolyQ, ...], tuple[PolyQ, ...]]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(index for index in range(N) if index not in omitted)
        xword = [zero] * N
        for position, party in enumerate(support):
            coefficient = qdet3(
                tuple(
                    points[index]
                    for other_position, index in enumerate(support)
                    if other_position != position
                )
            )
            xword[party] = coefficient if position % 2 == 0 else qneg(coefficient)
        first, second = omitted
        zword = tuple(
            qdet3((points[first], points[second], points[party]))
            if party in support
            else zero
            for party in range(N)
        )
        data[support] = (tuple(xword), zword)

    a_polynomial = qtrim((0, -4, 8, -4))
    b_polynomial = qtrim((1, -4, 5, -4, 1))
    grs_polynomial = qtrim((1, -4, 7, -4, 1))
    bracket_products = collections.Counter()
    for pair in itertools.combinations(range(1, N), 2):
        first_triple = (0,) + pair
        second_triple = tuple(
            index for index in range(N) if index not in first_triple
        )
        value = qmul(
            qdet3(tuple(points[index] for index in first_triple)),
            qdet3(tuple(points[index] for index in second_triple)),
        )
        if C395.permutation_sign(first_triple + second_triple) < 0:
            value = qneg(value)
        bracket_products[value] += 1
    if bracket_products != {
        a_polynomial: 3,
        qneg(a_polynomial): 3,
        b_polynomial: 2,
        qneg(b_polynomial): 2,
    }:
        raise AssertionError("signed bracket-product multiset identity failed")
    z_value = rat(qmul(b_polynomial, b_polynomial), qmul(a_polynomial, a_polynomial))
    four = rat((4,))
    minus_inverse_z = rneg(rinv(z_value))
    c_value = rdiv(rpow(radd(rmul(rat((2,)), z_value), rat((1,))), 2), rpow(z_value, 2))
    root_product = rsub(
        rsub(rat((8,)), rmul(rat((16,)), z_value)),
        rinv(z_value),
    )
    categories = collections.Counter()
    root_functions = collections.Counter()
    for source, target in itertools.combinations(range(N), 2):
        supports = [
            support for support in sorted(data) if source in support and target in support
        ]
        for first, second in itertools.combinations(supports, 2):
            values = []
            for component in (0, 1):
                first_ratio = rat(
                    data[first][component][target],
                    data[first][component][source],
                )
                second_ratio = rat(
                    data[second][component][source],
                    data[second][component][target],
                )
                values.append(rmul(first_ratio, second_ratio))
            trace = radd(values[0], values[1])
            determinant = rmul(values[0], values[1])
            conjugacy_ratio = rdiv(rpow(trace, 2), determinant)
            for _ in range(2):  # holonomy and inverse have the same trace^2/determinant
                if conjugacy_ratio == four:
                    categories["constant_4"] += 1
                elif conjugacy_ratio == minus_inverse_z:
                    categories["minus_inverse_z"] += 1
                elif conjugacy_ratio == c_value:
                    categories["small_weight_value"] += 1
                else:
                    residual = radd(
                        rsub(rpow(conjugacy_ratio, 2), rmul(rat((8,)), conjugacy_ratio)),
                        root_product,
                    )
                    if residual != rat((0,)):
                        raise AssertionError("symbolic holonomy ratio misses the z-polynomial")
                    categories["quadratic_pair"] += 1
                    root_functions[conjugacy_ratio] += 1
    if categories != {
        "constant_4": 90,
        "minus_inverse_z": 144,
        "small_weight_value": 24,
        "quadratic_pair": 192,
    }:
        raise AssertionError(f"unexpected symbolic category counts: {categories}")
    if sorted(root_functions.values()) != [96, 96]:
        raise AssertionError("quadratic holonomy roots do not split 96/96")
    boundary_identity = qadd(
        qmul((Fraction(4),), qmul(b_polynomial, b_polynomial)),
        qmul(a_polynomial, a_polynomial),
    )
    expected_boundary = qmul((Fraction(4),), qmul(grs_polynomial, grs_polynomial))
    if boundary_identity != expected_boundary:
        raise AssertionError("z=-1/4 boundary identity failed")
    tetrahedral_z = Fraction(225, 256)
    tetrahedral_w = Fraction(15, 16)
    if tetrahedral_w**2 != tetrahedral_z:
        raise AssertionError("signed bracket coordinate does not square to z")
    tetrahedral_grs_gap = tetrahedral_z + Fraction(1, 4)
    if tetrahedral_grs_gap != Fraction(17**2, 2**8):
        raise AssertionError("tetrahedral/GRS branch collision identity failed")
    recovery_value = -1 / tetrahedral_z
    quadratic_at_recovery = (
        recovery_value**2
        - 8 * recovery_value
        + 8
        - 16 * tetrahedral_z
        - 1 / tetrahedral_z
    )
    if quadratic_at_recovery != Fraction(17**4 * 31, 30**4):
        raise AssertionError("tetrahedral holonomy-bin collision identity failed")
    return {
        "parameter": {
            "A": [int(value) for value in a_polynomial],
            "B": [int(value) for value in b_polynomial],
            "z": "(B/A)^2",
            "y": "(t-1)^2/t",
            "z_in_y": "(y-y^-1)^2/16",
        },
        "signed_bracket_product_multiset": {
            "+A": 3,
            "-A": 3,
            "+B": 2,
            "-B": 2,
        },
        "derived_ratio_histogram": {
            "4": 90,
            "-1/z": 144,
            "(2z+1)^2/z^2": 24,
            "quadratic_roots_each": 96,
            "quadratic": "X^2-8X+(8-16z-1/z)",
        },
        "grs_boundary_identity": "4*B^2+A^2=4*(t^4-4t^3+7t^2-4t+1)^2",
        "degree_eight_cover": {
            "factorization": "t -> y=t+t^-1-2 -> z=(y-y^-1)^2/16",
            "branch_values": ["infinity", "0", "-1/4", "225/256"],
            "tetrahedral_parameter": "-1",
            "tetrahedral_y": "-4",
            "tetrahedral_z": "225/256",
            "tetrahedral_to_grs_gap": "289/256=17^2/2^8",
            "quadratic_at_recovery_value": "2589151/810000=17^4*31/30^4",
        },
        "signed_bracket_double_cover": {
            "w": "B/A=-(y-y^-1)/4",
            "z": "w^2",
            "w_preserving_y_actions": ["y", "-y^-1"],
            "w_reversing_y_actions": ["-y", "y^-1"],
            "tetrahedral_w": "15/16",
            "characteristic_17_value": "-2",
            "characteristic_31_value": "-1",
        },
        "recovery_multiplicities": [144, 168, 240, 264],
    }


def parameter_y(field: FiniteField, parameter: Element) -> Element:
    numerator = field.mul(
        field.sub(parameter, field.one),
        field.sub(parameter, field.one),
    )
    return field.mul(numerator, field.inv(parameter))


def parameter_z(field: FiniteField, parameter: Element) -> Element:
    y_value = parameter_y(field, parameter)
    difference = field.sub(y_value, field.inv(y_value))
    sixteen = field.element(16)
    return field.mul(field.mul(difference, difference), field.inv(sixteen))


def mmul3(field: FiniteField, left: Matrix, right: Matrix) -> Matrix:
    return tuple(
        tuple(
            add_many(field, (field.mul(left[i][k], right[k][j]) for k in range(3)))
            for j in range(3)
        )
        for i in range(3)
    )


def explicit_parameter_projectivity(
    field: FiniteField, source: Element, target: Element
) -> tuple[str, Matrix, tuple[int, ...]]:
    one = field.one
    source_y, target_y = parameter_y(field, source), parameter_y(field, target)
    common = field.mul(
        field.sub(one, target),
        field.inv(field.sub(one, source)),
    )
    if target_y == source_y:
        return (
            "y(u)=y(t)",
            (
                (one, field.zero, field.zero),
                (field.zero, common, field.zero),
                (field.zero, field.zero, field.mul(target, field.inv(source))),
            ),
            (0, 1, 2, 3, 4, 5),
        )
    if target_y == field.neg(source_y):
        return (
            "y(u)=-y(t)",
            (
                (one, field.zero, field.zero),
                (field.zero, common, field.zero),
                (
                    field.zero,
                    field.zero,
                    field.neg(field.mul(target, field.inv(source))),
                ),
            ),
            (0, 1, 2, 3, 5, 4),
        )
    off_diagonal_bottom = field.neg(
        field.mul(target, field.inv(field.sub(one, source)))
    )
    if target_y == field.inv(source_y):
        return (
            "y(u)=y(t)^-1",
            (
                (one, field.zero, field.zero),
                (
                    field.zero,
                    field.zero,
                    field.mul(field.sub(target, one), field.inv(source)),
                ),
                (field.zero, off_diagonal_bottom, field.zero),
            ),
            (0, 1, 4, 5, 2, 3),
        )
    if target_y == field.neg(field.inv(source_y)):
        return (
            "y(u)=-y(t)^-1",
            (
                (one, field.zero, field.zero),
                (
                    field.zero,
                    field.zero,
                    field.mul(field.sub(one, target), field.inv(source)),
                ),
                (field.zero, off_diagonal_bottom, field.zero),
            ),
            (0, 1, 4, 5, 3, 2),
        )
    raise AssertionError("equal-z parameters miss the four relation cases")


def verify_projectivity(
    field: FiniteField,
    source_points: Sequence[Vector],
    target_points: Sequence[Vector],
    matrix: Matrix,
    permutation: Sequence[int],
) -> None:
    if len(rowspace(field, matrix)) != 3:
        raise AssertionError("explicit parameter projectivity is singular")
    for source_party, target_party in enumerate(permutation):
        image = canonical_projective(
            field, matvec(field, matrix, source_points[source_party])
        )
        expected = canonical_projective(field, target_points[target_party])
        if image != expected:
            raise AssertionError("explicit parameter projectivity identity failed")


def field_certificate(p: int, modulus: Sequence[int], full_replay: bool) -> dict[str, object]:
    field = FiniteField(p, modulus)
    quartic = (1, -4, 7, -4, 1)
    parameters = []
    for parameter in field.elements():
        points = C395.ff_points(field, parameter)
        arc = all(
            C395.ff_det3(field, tuple(points[index] for index in triple)) != field.zero
            for triple in itertools.combinations(range(N), 3)
        )
        conic = C395.ff_determinant(
            field,
            tuple(
                (
                    field.mul(point[0], point[0]),
                    field.mul(point[1], point[1]),
                    field.mul(point[2], point[2]),
                    field.mul(point[0], point[1]),
                    field.mul(point[0], point[2]),
                    field.mul(point[1], point[2]),
                )
                for point in points
            ),
        ) == field.zero
        formula_grs = field.peval(quartic, parameter) == field.zero
        if arc and conic != formula_grs:
            raise AssertionError(
                f"conic determinant and quartic disagree over F_{field.order} at {parameter}"
            )
        if arc and not conic:
            parameters.append(tuple(parameter))

    classes: dict[PointSet, list[Element]] = {}
    z_buckets: dict[Element, list[Element]] = {}
    for parameter in parameters:
        points = C395.ff_points(field, parameter)
        classes.setdefault(canonical_arc(field, points), []).append(parameter)
        z_buckets.setdefault(parameter_z(field, parameter), []).append(parameter)
    if sorted(sorted(values) for values in classes.values()) != sorted(
        sorted(values) for values in z_buckets.values()
    ):
        raise AssertionError(f"z fibres and projective classes disagree over F_{field.order}")

    class_rows = []
    signature_buckets: dict[
        tuple[tuple[tuple[Element, Element], int], ...], list[int]
    ] = {}
    for class_index, (canonical, class_parameters) in enumerate(sorted(classes.items())):
        representative = min(class_parameters)
        points = C395.ff_points(field, representative)
        code = code_from_points(field, points)
        signature = cycle_signature(field, code)
        signature_buckets.setdefault(signature, []).append(class_index)
        ratio_histogram: collections.Counter[Element] = collections.Counter()
        for (trace, determinant), multiplicity in signature:
            ratio = field.mul(
                field.mul(trace, trace),
                field.inv(determinant),
            )
            ratio_histogram[ratio] += multiplicity
        z_parameter = parameter_z(field, representative)
        recovery_value = field.neg(field.inv(z_parameter))
        recovery_multiplicity = ratio_histogram[recovery_value]
        if recovery_multiplicity not in (144, 168, 240, 264):
            raise AssertionError("holonomy histogram does not expose the z-recovery bin")
        if full_replay and cycle_signature_lagrangian_replay(field, code) != signature:
            raise AssertionError("direct Lagrangian holonomy replay disagrees")
        moments = moment_distribution(field, code)
        ambient_moments = moment_distribution_lagrangian_replay(field, code)
        if full_replay and ambient_moments != moments:
            raise AssertionError(
                f"direct Lagrangian moment replay disagrees over F_{field.order}: "
                f"{moments} != {ambient_moments}"
            )
        formula_witnesses = []
        for parameter in sorted(class_parameters):
            relation_name, matrix, permutation = explicit_parameter_projectivity(
                field, representative, parameter
            )
            verify_projectivity(
                field,
                points,
                C395.ff_points(field, parameter),
                matrix,
                permutation,
            )
            formula_witnesses.append(
                {
                    "parameter": encode_element(parameter),
                    "relation": relation_name,
                    "matrix": [
                        [encode_element(value) for value in row] for row in matrix
                    ],
                    "source_to_target_party": list(permutation),
                }
            )
        class_rows.append(
            {
                "representative": encode_element(representative),
                "parameters": [encode_element(value) for value in sorted(class_parameters)],
                "z": encode_element(z_parameter),
                "canonical_arc": encode_points(canonical),
                "normalizing_witnesses": [
                    {
                        "parameter": encode_element(parameter),
                        **normalizing_witness(
                            field, C395.ff_points(field, parameter), canonical
                        ),
                    }
                    for parameter in sorted(class_parameters)
                ],
                "conic_evaluation_determinant": encode_element(
                    C395.ff_determinant(
                        field,
                        tuple(
                            (
                                field.mul(point[0], point[0]),
                                field.mul(point[1], point[1]),
                                field.mul(point[2], point[2]),
                                field.mul(point[0], point[1]),
                                field.mul(point[0], point[2]),
                                field.mul(point[1], point[2]),
                            )
                            for point in points
                        ),
                    )
                ),
                "moment_distribution": [
                    {"rank": rank, "multiplicity": multiplicity}
                    for rank, multiplicity in moments
                ],
                "holonomy_signature": encode_signature(signature),
                "holonomy_z_recovery_bin": {
                    "value": encode_element(recovery_value),
                    "multiplicity": recovery_multiplicity,
                },
                "formula_projectivities": formula_witnesses,
                "direct_lagrangian_replay": full_replay,
            }
        )

    if any(len(indices) != 1 for indices in signature_buckets.values()):
        raise AssertionError(f"holonomy collision over F_{field.order}")
    for left, right in itertools.combinations(class_rows, 2):
        left_points = C395.ff_points(
            field,
            tuple(left["representative"])
            if isinstance(left["representative"], list)
            else field.element(int(left["representative"])),
        )
        right_points = C395.ff_points(
            field,
            tuple(right["representative"])
            if isinstance(right["representative"], list)
            else field.element(int(right["representative"])),
        )
        if pairwise_projectively_equivalent(field, left_points, right_points):
            raise AssertionError("independent pairwise replay merged canonical classes")

    return {
        "field": {
            "order": field.order,
            "characteristic": p,
            "modulus_low_to_high": list(modulus),
        },
        "non_grs_parameters": [encode_element(value) for value in sorted(parameters)],
        "projective_classes": class_rows,
        "class_count": len(class_rows),
        "z_bucket_count": len(z_buckets),
        "holonomy_bucket_count": len(signature_buckets),
        "holonomy_collisions": [],
        "independent_pairwise_replay": True,
    }


def build_certificate() -> dict[str, object]:
    symbolic = symbolic_holonomy_certificate()
    fields = (
        (7, (0, 1), True),
        (11, (0, 1), True),
        (13, (0, 1), True),
        (17, (0, 1), True),
        (19, (0, 1), False),
        (23, (0, 1), False),
        (29, (0, 1), False),
        (31, (0, 1), True),
        (3, (1, 0, 1), True),
        (5, (2, 0, 1), True),
        (3, (1, 2, 0, 1), True),
        (7, (1, 0, 1), True),
    )
    rows = [
        field_certificate(p, modulus, full_replay)
        for p, modulus, full_replay in fields
    ]
    q13 = next(row for row in rows if row["field"]["order"] == 13)
    if [row["parameters"] for row in q13["projective_classes"]] != [
        [3, 9, 12],
        [2, 5, 6, 7, 8, 11],
    ]:
        raise AssertionError("unexpected q=13 projective classes")
    if any(
        row["moment_distribution"]
        != [{"rank": 4, "multiplicity": 66}, {"rank": 6, "multiplicity": 389}]
        for row in q13["projective_classes"]
    ):
        raise AssertionError("q=13 moment collision missing")
    q31 = next(row for row in rows if row["field"]["order"] == 31)
    tetrahedral_class = next(
        row for row in q31["projective_classes"] if 30 in row["parameters"]
    )
    if (
        tetrahedral_class["parameters"] != [12, 13, 18, 19, 30]
        or tetrahedral_class["z"] != 1
        or tetrahedral_class["holonomy_z_recovery_bin"]
        != {"value": 30, "multiplicity": 240}
    ):
        raise AssertionError("q=31 tetrahedral holonomy-bin collision missing")
    return {
        "schema": "c396-holonomy-completeness-v1",
        "input": {"path": INPUT.name, "sha256": INPUT_SHA256},
        "symbolic": symbolic,
        "fields": rows,
        "mandatory_q13_result": {
            "projective_class_count": 2,
            "moment_distribution": [
                {"rank": 4, "multiplicity": 66},
                {"rank": 6, "multiplicity": 389},
            ],
            "moment_bucket_count": 1,
            "holonomy_bucket_count": 2,
        },
        "verdict": (
            "over every odd finite field, equality of the 450-entry holonomy signature "
            "is equivalent to projective/monomial equivalence inside the admitted "
            "non-GRS pencil"
        ),
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_certificate())
    if args.write:
        CERTIFICATE.write_bytes(generated)
        print(f"wrote {CERTIFICATE.name} ({len(generated)} bytes)")
        return
    if CERTIFICATE.read_bytes() != generated:
        raise SystemExit("certificate is stale; rerun with --write")
    print("C396 certificate OK: q=13 moment collision; no replay holonomy collisions")


if __name__ == "__main__":
    main()
