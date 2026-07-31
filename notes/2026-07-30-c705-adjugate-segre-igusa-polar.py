#!/usr/bin/env python3
"""Exact C705 certificate for the adjugate Segre--Igusa polar shadow."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations, permutations, product
from math import prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c705-adjugate-segre-igusa-polar.json"
C704_SCRIPT = ROOT / "2026-07-30-c704-segre-igusa-operator-shadow.py"


def load_c704():
    spec = importlib.util.spec_from_file_location("c704_shadow", C704_SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C704 = load_c704()


@dataclass(frozen=True)
class Q5:
    """Element a+b*s of Q(s), s^2=5."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    @staticmethod
    def coerce(value: int | Fraction | "Q5") -> "Q5":
        if isinstance(value, Q5):
            return value
        return Q5(Fraction(value), Fraction(0))

    def __add__(self, other: int | Fraction | "Q5") -> "Q5":
        other = Q5.coerce(other)
        return Q5(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self) -> "Q5":
        return Q5(-self.a, -self.b)

    def __sub__(self, other: int | Fraction | "Q5") -> "Q5":
        return self + (-Q5.coerce(other))

    def __rsub__(self, other: int | Fraction | "Q5") -> "Q5":
        return Q5.coerce(other) - self

    def __mul__(self, other: int | Fraction | "Q5") -> "Q5":
        other = Q5.coerce(other)
        return Q5(
            self.a * other.a + 5 * self.b * other.b,
            self.a * other.b + self.b * other.a,
        )

    __rmul__ = __mul__

    def inverse(self) -> "Q5":
        norm = self.a * self.a - 5 * self.b * self.b
        assert norm
        return Q5(self.a / norm, -self.b / norm)

    def __truediv__(self, other: int | Fraction | "Q5") -> "Q5":
        return self * Q5.coerce(other).inverse()

    def __bool__(self) -> bool:
        return bool(self.a or self.b)

    def text(self) -> str:
        def q(value: Fraction) -> str:
            return str(value.numerator) if value.denominator == 1 else str(value)

        if not self.b:
            return q(self.a)
        if not self.a:
            return f"{q(self.b)}*sqrt(5)"
        sign = "+" if self.b > 0 else "-"
        return f"{q(self.a)}{sign}{q(abs(self.b))}*sqrt(5)"


S = Q5(0, 1)
ZERO5 = Q5()
ONE5 = Q5(1)


def matrix_multiply(a, b):
    return [
        [
            sum((a[i][k] * b[k][j] for k in range(len(b))), ZERO5)
            for j in range(len(b[0]))
        ]
        for i in range(len(a))
    ]


def matrix_inverse(matrix):
    size = len(matrix)
    work = [
        list(row)
        + [ONE5 if i == j else ZERO5 for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(i for i in range(column, size) if work[i][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column].inverse()
        work[column] = [value * scale for value in work[column]]
        for row in range(size):
            if row == column:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    work[row][j] - scale * work[column][j]
                    for j in range(2 * size)
                ]
    return [row[size:] for row in work]


def q5_rank(matrix) -> int:
    if not matrix:
        return 0
    work = [list(row) for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (i for i in range(row, len(work)) if work[i][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column].inverse()
        work[row] = [value * scale for value in work[row]]
        for i in range(len(work)):
            if i != row and work[i][column]:
                scale = work[i][column]
                work[i] = [
                    work[i][j] - scale * work[row][j]
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


QPoly = dict[tuple[int, ...], Q5]
MONOMIALS_2 = tuple(e for e in product(range(3), repeat=5) if sum(e) == 2)


def qpoly_add(*polys: QPoly) -> QPoly:
    result: QPoly = {}
    for poly in polys:
        for monomial, coefficient in poly.items():
            result[monomial] = result.get(monomial, ZERO5) + coefficient
    return {m: c for m, c in result.items() if c}


def qpoly_scale(poly: QPoly, scalar: Q5) -> QPoly:
    return {m: scalar * c for m, c in poly.items() if scalar * c}


def qpoly_multiply(left: QPoly, right: QPoly) -> QPoly:
    result: QPoly = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(lm[i] + rm[i] for i in range(5))
            result[monomial] = result.get(monomial, ZERO5) + lc * rc
    return {m: c for m, c in result.items() if c}


def qpoly_determinant(matrix: list[list[QPoly]]) -> QPoly:
    if not matrix:
        return {(0, 0, 0, 0, 0): ONE5}
    terms = []
    for column, entry in enumerate(matrix[0]):
        minor = [
            row[:column] + row[column + 1 :]
            for row in matrix[1:]
        ]
        terms.append(
            qpoly_scale(
                qpoly_multiply(entry, qpoly_determinant(minor)),
                Q5((-1) ** column),
            )
        )
    return qpoly_add(*terms)


def oriented_shadows():
    base_z = C704.triangle_cubic(C704.BASE_C)
    records = {}
    for p in permutations(range(6)):
        total = C704.total_key(
            tuple(
                tuple(
                    sorted(tuple(sorted((p[i], p[j]))) for i, j in matching)
                )
                for matching in C704.BASE_TOTAL
            )
        )
        if total in records:
            continue
        sign = C704.parity(p)
        matrix = [[0] * 6 for _ in range(6)]
        for i in range(6):
            for j in range(6):
                matrix[p[i]][p[j]] = sign * C704.BASE_C[i][j]
        cubic = tuple(
            sign * value for value in C704.permute_cubic(base_z, p)
        )
        assert C704.triangle_cubic(tuple(tuple(row) for row in matrix)) == cubic
        records[total] = (tuple(tuple(row) for row in matrix), cubic)
    assert len(records) == 6
    return [records[key] for key in sorted(records)]


def eigenbasis(matrix, eigen_sign: int):
    # Columns of (sqrt(5) I + eigen_sign C) lie in the requested eigenspace.
    columns = [
        [
            (S if row == column else ZERO5)
            + eigen_sign * Q5(matrix[row][column])
            for column in range(6)
        ]
        for row in range(6)
    ]
    for selected_columns in combinations(range(6), 3):
        basis = [
            [columns[row][column] for column in selected_columns]
            for row in range(6)
        ]
        for selected_rows in combinations(range(6), 3):
            square = [[basis[row][column] for column in range(3)] for row in selected_rows]
            try:
                inverse = matrix_inverse(square)
            except StopIteration:
                continue
            return basis, selected_columns, selected_rows, inverse
    raise AssertionError("no eigenbasis found")


def cross_block(matrix):
    plus, plus_columns, _, _ = eigenbasis(matrix, 1)
    minus, minus_columns, minus_rows, minus_inverse = eigenbasis(matrix, -1)
    projector_minus = [
        [
            (ONE5 if i == j else ZERO5) / 2
            - Q5(matrix[i][j]) * S / 10
            for j in range(6)
        ]
        for i in range(6)
    ]
    coefficients = []
    for variable in range(5):
        diagonal = [0] * 6
        diagonal[variable] = 1
        diagonal[5] = -1
        acted = [
            [Q5(diagonal[row]) * plus[row][column] for column in range(3)]
            for row in range(6)
        ]
        projected = matrix_multiply(projector_minus, acted)
        restricted = [[projected[row][column] for column in range(3)] for row in minus_rows]
        coordinates = matrix_multiply(minus_inverse, restricted)
        assert matrix_multiply(minus, coordinates) == projected
        coefficients.append(coordinates)
    entries: list[list[QPoly]] = [[{} for _ in range(3)] for _ in range(3)]
    for row in range(3):
        for column in range(3):
            entries[row][column] = {
                tuple(int(index == variable) for index in range(5)):
                coefficients[variable][row][column]
                for variable in range(5)
                if coefficients[variable][row][column]
            }
    return entries, plus_columns, minus_columns


def derivative(poly, variable: int):
    return {
        tuple(exponent[i] - int(i == variable) for i in range(5)):
        coefficient * exponent[variable]
        for exponent, coefficient in poly.items()
        if exponent[variable]
    }


def perfect_matchings(items: tuple[int, ...]):
    if not items:
        yield ()
        return
    first = items[0]
    for second in items[1:]:
        remainder = tuple(value for value in items if value not in (first, second))
        for tail in perfect_matchings(remainder):
            yield ((first, second),) + tail


def integer_rank(matrix) -> int:
    return C704.rational_rank(matrix)


def modular_rank(matrix, prime: int) -> int:
    work = [[value % prime for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [(value * inverse) % prime for value in work[row]]
        for index in range(len(work)):
            if index != row and work[index][column]:
                scale = work[index][column]
                work[index] = [
                    (work[index][j] - scale * work[row][j]) % prime
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


def evaluate_poly(poly, point):
    return sum(
        coefficient
        * prod(point[i] ** exponent[i] for i in range(len(point)))
        for exponent, coefficient in poly.items()
    )


def centered_squares(values, poly_mode=False):
    if poly_mode:
        total = C704.add(*(C704.power(value, 2) for value in values))
        return [
            C704.add(C704.scale(C704.power(value, 2), 6), C704.scale(total, -1))
            for value in values
        ]
    total = sum(value * value for value in values)
    return [6 * value * value - total for value in values]


def integer_poly_product(polys):
    result = {C704.ZERO: 1}
    for poly in polys:
        result = C704.mul(result, poly)
    return result


def jacobian_adjugate_certificate(z_polys):
    jacobian = [
        [derivative(z_polys[column], row) for column in range(6)]
        for row in range(5)
    ]
    assert all(not C704.add(*(jacobian[row][column] for column in range(6))) for row in range(5))

    source_q = centered_squares(list(C704.VARS), poly_mode=True)[:5]
    assert all(
        not C704.add(
            *(C704.mul(jacobian[row][column], source_q[row]) for row in range(5))
        )
        for column in range(6)
    )

    outer_w = centered_squares(z_polys, poly_mode=True)
    assert all(
        not C704.add(
            *(C704.mul(jacobian[row][column], outer_w[column]) for column in range(6))
        )
        for row in range(5)
    )

    difference = [
        [
            C704.add(jacobian[row][column], C704.scale(jacobian[row][5], -1))
            for column in range(5)
        ]
        for row in range(5)
    ]
    checked_entries = 0
    for row in range(5):
        for column in range(5):
            # adj(A)_{row,column}=(-1)^(row+column) det A[not column,not row].
            minor = [
                [difference[i][j] for j in range(5) if j != row]
                for i in range(5)
                if i != column
            ]
            adjugate_entry = C704.scale(
                C704.determinant_poly(minor),
                (-1) ** (row + column),
            )
            expected = C704.scale(C704.mul(outer_w[row], source_q[column]), 6)
            assert not C704.add(adjugate_entry, C704.scale(expected, -1))
            checked_entries += 1

    assert all(
        coefficient % 2 == 0
        for row in difference
        for entry in row
        for coefficient in entry.values()
    )
    characteristic_two_jacobian_minors = 0
    for rows in combinations(range(5), 2):
        for columns in combinations(range(6), 2):
            minor = C704.determinant_poly(
                [[jacobian[row][column] for column in columns] for row in rows]
            )
            assert all(coefficient % 2 == 0 for coefficient in minor.values())
            characteristic_two_jacobian_minors += 1
    characteristic_three_jacobian_minors = 0
    for rows in combinations(range(5), 4):
        for columns in combinations(range(6), 4):
            minor = C704.determinant_poly(
                [[jacobian[row][column] for column in columns] for row in rows]
            )
            assert all(coefficient % 3 == 0 for coefficient in minor.values())
            characteristic_three_jacobian_minors += 1

    witness = (1, 2, 3, 4, 5)
    evaluated = [
        [evaluate_poly(entry, witness) for entry in row]
        for row in jacobian
    ]
    rank = integer_rank(evaluated)
    assert rank == 4

    characteristic_witnesses = {
        2: (0, 0, 0, 0, 1),
        3: (0, 0, 0, 0, 1),
        5: (0, 1, 1, 2, 2),
        7: (0, 0, 1, 1, 2),
    }
    characteristic_ranks = {}
    for prime, point in characteristic_witnesses.items():
        evaluated_jacobian = [
            [evaluate_poly(entry, point) % prime for entry in row]
            for row in jacobian
        ]
        evaluated_difference = [
            [
                (evaluated_jacobian[row][column] - evaluated_jacobian[row][5])
                % prime
                for column in range(5)
            ]
            for row in range(5)
        ]
        characteristic_ranks[str(prime)] = {
            "witness": list(point) + [(-sum(point)) % prime],
            "jacobian_rank": modular_rank(evaluated_jacobian, prime),
            "difference_rank": modular_rank(evaluated_difference, prime),
        }
    assert characteristic_ranks["2"]["difference_rank"] == 0
    assert characteristic_ranks["3"]["difference_rank"] == 3
    assert characteristic_ranks["5"]["difference_rank"] == 4
    assert characteristic_ranks["7"]["difference_rank"] == 4
    return {
        "jacobian_shape": "5x6",
        "generic_rank": rank,
        "generic_rank_witness": list(witness) + [-sum(witness)],
        "generic_relation_space": "span{(1,...,1), W}",
        "source_kernel": (
            "q_i=6*x_i^2-sum_j(x_j^2), with q_5=-sum_{i<5}q_i"
        ),
        "adjugate_factorization": "adj(A)=6*W*q^T",
        "difference_matrix": "A_iT=dZ_T/dx_i-dZ_5/dx_i, T=0,...,4",
        "adjugate_entries_checked": checked_entries,
        "characteristic_rank_witnesses": characteristic_ranks,
        "arithmetic_boundary": (
            "rank 0 for A in characteristic 2, generic rank 3 in "
            "characteristic 3, and generic rank 4 at 5 and 7"
        ),
        "characteristic_two_2x2_jacobian_minors_checked": (
            characteristic_two_jacobian_minors
        ),
        "characteristic_three_4x4_jacobian_minors_checked": (
            characteristic_three_jacobian_minors
        ),
    }


def outer_character_certificate(shadows):
    z_cubics = [cubic for _, cubic in shadows]
    inner_outer = 0
    inner_signed_outer = 0
    inner_standard = 0
    norm_outer = 0
    compound_domain_outer = 0

    def permutation_power(p, exponent):
        result = tuple(range(6))
        for _ in range(exponent):
            result = tuple(p[result[i]] for i in range(6))
        return result

    def wedge3_character(character, p):
        return (
            character(p) ** 3
            - 3 * character(p) * character(permutation_power(p, 2))
            + 2 * character(permutation_power(p, 3))
        ) // 6

    def standard_character(p):
        return sum(p[i] == i for i in range(6)) - 1

    def outer_character(p):
        image = []
        for cubic in z_cubics:
            target = tuple(
                C704.parity(p) * value
                for value in C704.permute_cubic(cubic, p)
            )
            image.append(z_cubics.index(target))
        return sum(image[i] == i for i in range(6)) - 1

    for p in permutations(range(6)):
        standard = standard_character(p)
        square = tuple(p[p[i]] for i in range(6))
        standard_square = sum(square[i] == i for i in range(6)) - 1
        symmetric_square = (
            standard * standard + standard_square
        ) // 2
        outer = outer_character(p)
        inner_outer += symmetric_square * outer
        inner_signed_outer += symmetric_square * C704.parity(p) * outer
        inner_standard += symmetric_square * standard
        norm_outer += outer * outer
        compound_domain_outer += (
            wedge3_character(standard_character, p)
            * wedge3_character(outer_character, p)
            * outer
        )
    assert inner_outer == inner_signed_outer == 0
    assert inner_standard == norm_outer == 720
    assert compound_domain_outer == 720
    return {
        "quadratic_carrier": "Sym^2([5,1])=[6]+[5,1]+[4,2]",
        "quadratic_carrier_dimension": 15,
        "outer_standard_irreducible": True,
        "hom_to_outer_standard_dimension": 0,
        "hom_to_signed_outer_standard_dimension": 0,
        "third_compound_domain_outer_standard_multiplicity": 1,
    }


def node_certificate(shadows):
    source_nodes = []
    target_nodes = set()
    z_cubics = [cubic for _, cubic in shadows]
    z_polys = [C704.cubic_poly(cubic) for cubic in z_cubics]
    jacobian = [
        [derivative(z_polys[column], row) for column in range(6)]
        for row in range(5)
    ]
    node_ranks = []
    for positive in combinations(range(1, 6), 2):
        plus = (0,) + positive
        point = tuple(1 if i in plus else -1 for i in range(6))
        z = tuple(C704.evaluate(cubic, point) for cubic in z_cubics)
        magnitude = abs(next(value for value in z if value))
        normalized = tuple(value // magnitude for value in z)
        assert sorted(normalized) == [-1, -1, -1, 1, 1, 1]
        source_nodes.append(point)
        target_nodes.add(normalized)
        evaluated = [
            [evaluate_poly(entry, point[:5]) for entry in row]
            for row in jacobian
        ]
        node_ranks.append(integer_rank(evaluated))
    assert len(source_nodes) == len(target_nodes) == 10
    assert node_ranks == [1] * 10

    a, b, c = C704.VARS[:3]
    d = C704.add(
        C704.scale(a, -3),
        C704.scale(b, -1),
        C704.scale(c, -1),
    )
    triple_plane = [a, a, a, b, c, d]
    boundary_factor = integer_poly_product(
        (
            C704.add(a, C704.scale(b, -1)),
            C704.add(a, C704.scale(c, -1)),
            C704.add(a, C704.scale(d, -1)),
        )
    )
    plane_signs = []
    for _, cubic in shadows:
        restricted = C704.add(
            *(
                C704.scale(
                    integer_poly_product(triple_plane[index] for index in support),
                    coefficient,
                )
                for coefficient, support in zip(cubic, C704.TRIPLES)
            )
        )
        if not C704.add(restricted, C704.scale(boundary_factor, -1)):
            plane_signs.append(1)
        else:
            assert not C704.add(restricted, boundary_factor)
            plane_signs.append(-1)
    assert sorted(plane_signs) == [-1, -1, -1, 1, 1, 1]
    plane_witness = (1, 1, 1, 2, 3)
    plane_jacobian = [
        [evaluate_poly(entry, plane_witness) for entry in row]
        for row in jacobian
    ]
    plane_difference = [
        [
            plane_jacobian[row][column] - plane_jacobian[row][5]
            for column in range(5)
        ]
        for row in range(5)
    ]
    assert integer_rank(plane_jacobian) == integer_rank(plane_difference) == 3
    return {
        "source_centered_square_base_points": len(source_nodes),
        "outer_polar_base_nodes": len(target_nodes),
        "source_to_outer_node_map": "bijection under the six Joubert cubics",
        "source_node_image_scale": 8,
        "assembled_rank_at_all_source_nodes": 1,
        "triple_collision_plane_image": {
            "representative": "x0=x1=x2=a",
            "common_factor": "(a-x3)*(a-x4)*(a-x5)",
            "target_node_signs": plane_signs,
            "orbit_planes": 20,
            "complementary_pairs": 10,
            "generic_assembled_rank": 3,
        },
    }


def igusa_line_certificate():
    # One matching plane z=(a,-a,b,-b,c,-c); S_6 transitivity gives all 15.
    a, b, c = C704.VARS[:3]
    z = [a, C704.scale(a, -1), b, C704.scale(b, -1), c, C704.scale(c, -1)]
    w = centered_squares(z, poly_mode=True)
    assert not C704.add(w[0], C704.scale(w[1], -1))
    assert not C704.add(w[2], C704.scale(w[3], -1))
    assert not C704.add(w[4], C704.scale(w[5], -1))
    assert not C704.add(*w)
    square_sum = C704.add(*(C704.power(value, 2) for value in w))
    raw_gradient = [
        C704.add(
            C704.scale(C704.mul(value, square_sum), 4),
            C704.scale(C704.power(value, 3), -16),
        )
        for value in w
    ]
    gradient_sum = C704.add(*raw_gradient)
    centered_gradient = [
        C704.add(C704.scale(value, 6), C704.scale(gradient_sum, -1))
        for value in raw_gradient
    ]
    assert all(not value for value in centered_gradient)
    matchings = {
        tuple(sorted(tuple(sorted(pair)) for pair in matching))
        for matching in permutations(range(6))
        for matching in [
            ((matching[0], matching[1]), (matching[2], matching[3]), (matching[4], matching[5]))
        ]
    }
    assert len(matchings) == 15
    return {
        "segre_planes": 15,
        "plane_equations": "z_a+z_b=z_c+z_d=z_e+z_f=0",
        "polar_image": "w_a=w_b, w_c=w_d, w_e=w_f, sum(w)=0",
        "igusa_singular_lines": 15,
        "symbolic_singularity_check": "centered gradient of Igusa quartic vanishes",
    }


def inverse_polar_certificate():
    # Newton reduction on e1=e3=0.  We verify the six identities modulo the
    # single remaining Segre equation after eliminating z_5.
    z = list(C704.VARS)
    p3 = C704.add(*(C704.power(value, 3) for value in z))
    scaled_w = centered_squares(z, poly_mode=True)
    w_square_sum = C704.add(*(C704.power(value, 2) for value in scaled_w))
    raw = [
        C704.add(
            C704.mul(value, w_square_sum),
            C704.scale(C704.power(value, 3), -4),
        )
        for value in scaled_w
    ]
    raw_sum = C704.add(*raw)
    inverse = [
        C704.add(C704.scale(value, 6), C704.scale(raw_sum, -1))
        for value in raw
    ]
    e5 = C704.add(
        *(
            integer_poly_product(z[index] for index in subset)
            for subset in combinations(range(6), 5)
        )
    )

    def divisible_by_segre(poly):
        work = {monomial: Fraction(coefficient) for monomial, coefficient in poly.items()}
        divisor = {
            monomial: Fraction(coefficient)
            for monomial, coefficient in p3.items()
        }
        leading_divisor = max(divisor)
        while work:
            leading = max(work)
            if not all(leading[i] >= leading_divisor[i] for i in range(5)):
                return False
            exponent = tuple(leading[i] - leading_divisor[i] for i in range(5))
            scalar = work[leading] / divisor[leading_divisor]
            subtractor = C704.scale(C704.mul({exponent: 1}, p3), scalar)
            work = {
                monomial: Fraction(coefficient)
                for monomial, coefficient in C704.add(
                    work,
                    C704.scale(subtractor, -1),
                ).items()
            }
        return True

    checks = 0
    for coordinate in range(6):
        difference = C704.add(
            inverse[coordinate],
            C704.scale(C704.mul(e5, z[coordinate]), 5184),
        )
        assert divisible_by_segre(difference)
        checks += 1
    return {
        "inverse_map": (
            "z_i is proportional to center_i(w_i*sum_j(w_j^2)-4*w_i^3)"
        ),
        "exact_factor_on_segre_for_w_equals_center6_z_squared": "-5184*e5(z)",
        "derivation": (
            "use t^6+e2*t^4+e4*t^2-e5*t+e6=0 at the six coordinates, "
            "together with p1=p3=0"
        ),
        "open_locus": "e5(z) nonzero",
        "symbolic_divisibility_checks": checks,
    }


def build_certificate() -> dict:
    shadows = oriented_shadows()
    z_polys = [C704.cubic_poly(cubic) for _, cubic in shadows]
    all_minors = []
    determinant_scalars = []
    basis_columns = []
    for matrix, cubic in shadows:
        block, plus_columns, minus_columns = cross_block(matrix)
        determinant = qpoly_determinant(block)
        z_poly = C704.cubic_poly(cubic)
        scalar = None
        for monomial in set(determinant) | set(z_poly):
            left = determinant.get(monomial, ZERO5)
            right = Q5(z_poly.get(monomial, 0))
            if right:
                candidate = left / right
                scalar = candidate if scalar is None else scalar
                assert candidate == scalar
            else:
                assert not left
        assert scalar is not None
        determinant_scalars.append(scalar.text())
        basis_columns.append(
            {"plus": list(plus_columns), "minus": list(minus_columns)}
        )
        for removed_row in range(3):
            for removed_column in range(3):
                minor = [
                    [block[row][column] for column in range(3) if column != removed_column]
                    for row in range(3)
                    if row != removed_row
                ]
                cofactor = qpoly_scale(
                    qpoly_determinant(minor),
                    Q5((-1) ** (removed_row + removed_column)),
                )
                all_minors.append(
                    [cofactor.get(monomial, ZERO5) for monomial in MONOMIALS_2]
                )
    minor_rank = q5_rank(all_minors)

    gradient_rows = []
    for z_poly in z_polys:
        for variable in range(5):
            value = derivative(z_poly, variable)
            gradient_rows.append(
                [value.get(monomial, 0) for monomial in MONOMIALS_2]
            )
    gradient_rank = integer_rank(gradient_rows)

    matching_polys = []
    for matching in perfect_matchings(tuple(range(6))):
        factors = [
            C704.add(C704.VARS[second], C704.scale(C704.VARS[first], -1))
            for first, second in matching
        ]
        matching_polys.append(integer_poly_product(factors))
    cubic_monomials = tuple(
        exponent for exponent in product(range(4), repeat=5) if sum(exponent) == 3
    )
    z_rows = [[poly.get(monomial, 0) for monomial in cubic_monomials] for poly in z_polys]
    matching_rows = [
        [poly.get(monomial, 0) for monomial in cubic_monomials]
        for poly in matching_polys
    ]
    assert integer_rank(z_rows) == integer_rank(matching_rows) == 5
    assert integer_rank(z_rows + matching_rows) == 5

    character = outer_character_certificate(shadows)
    assert minor_rank == gradient_rank == 9
    character["all_cross_block_minor_span_rank"] = minor_rank
    character["cross_block_minor_carrier"] = "[4,2]"
    character["contracted_gradient_span_rank"] = gradient_rank
    character["contracted_gradient_irreducible"] = "[4,2]"
    character["linear_polar_contraction_obstruction"] = (
        "no outer-standard summand occurs in any linear scalar contraction "
        "of the quadratic carrier"
    )

    jacobian = [
        [derivative(z_polys[column], row) for column in range(6)]
        for row in range(5)
    ]
    difference = [
        [
            C704.add(jacobian[row][column], C704.scale(jacobian[row][5], -1))
            for column in range(5)
        ]
        for row in range(5)
    ]
    compound3 = []
    for rows in combinations(range(5), 3):
        for columns in combinations(range(5), 3):
            compound3.append(
                C704.determinant_poly(
                    [[difference[row][column] for column in columns] for row in rows]
                )
            )
    sextic_monomials = tuple(
        exponent for exponent in product(range(7), repeat=5) if sum(exponent) == 6
    )
    compound3_rows = [
        [poly.get(monomial, 0) for monomial in sextic_monomials]
        for poly in compound3
    ]
    polar_rows = [
        [poly.get(monomial, 0) for monomial in sextic_monomials]
        for poly in centered_squares(z_polys, poly_mode=True)[:5]
    ]
    compound3_rank = integer_rank(compound3_rows)
    polar_rank = integer_rank(polar_rows)
    combined_rank = integer_rank(compound3_rows + polar_rows)
    assert compound3_rank == combined_rank == 70
    assert polar_rank == 5
    character["third_compound_entries"] = len(compound3)
    character["third_compound_polynomial_span_rank"] = compound3_rank
    character["polar_carrier_rank"] = polar_rank
    character["third_compound_plus_polar_span_rank"] = combined_rank
    character["third_compound_verdict"] = (
        "the unique outer-standard summand maps onto the polar carrier"
    )

    return {
        "schema": "c705-adjugate-segre-igusa-polar-v1",
        "ground_field": "Q(sqrt(5)) for cross blocks; identities descend to Q",
        "oriented_cross_blocks": len(shadows),
        "cross_block_basis_columns": basis_columns,
        "determinant_to_joubert_scalars": determinant_scalars,
        "quadratic_minor_carrier": character,
        "joubert_base_linear_system": {
            "joubert_cubic_span_rank": 5,
            "matching_bracket_span_rank": 5,
            "combined_span_rank": 5,
            "perfect_matchings": len(matching_polys),
        },
        "jacobian_adjugate": jacobian_adjugate_certificate(z_polys),
        "base_nodes": node_certificate(shadows),
        "igusa_singular_lines": igusa_line_certificate(),
        "inverse_polar": inverse_polar_certificate(),
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
