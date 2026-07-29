#!/usr/bin/env python3
"""Exact characteristic-zero operator construction of the Schlaefli double-six."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")


def solve_fraction(matrix: list[list[Fraction]], rhs: list[Fraction]):
    work = [row[:] + [value] for row, value in zip(matrix, rhs, strict=True)]
    row = 0
    pivots = []
    for column in range(len(matrix[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [value / scale for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            if scale:
                work[index] = [
                    left - scale * right
                    for left, right in zip(work[index], work[row], strict=True)
                ]
        pivots.append(column)
        row += 1
    assert pivots == list(range(len(matrix[0])))
    return [work[index][-1] for index in range(len(matrix[0]))]


class Qzeta5:
    """The field Q[z]/(z^4+z^3+z^2+z+1)."""

    __slots__ = ("coefficients",)

    def __init__(self, *coefficients):
        values = [Fraction(value) for value in coefficients]
        values.extend([Fraction(0)] * (4 - len(values)))
        assert len(values) == 4
        self.coefficients = tuple(values)

    @staticmethod
    def coerce(value):
        return value if isinstance(value, Qzeta5) else Qzeta5(value)

    def __add__(self, other):
        other = self.coerce(other)
        return Qzeta5(
            *(left + right for left, right in zip(
                self.coefficients, other.coefficients, strict=True
            ))
        )

    __radd__ = __add__

    def __neg__(self):
        return Qzeta5(*(-value for value in self.coefficients))

    def __sub__(self, other):
        return self + (-self.coerce(other))

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        product = [Fraction(0)] * 7
        for left_index, left in enumerate(self.coefficients):
            for right_index, right in enumerate(other.coefficients):
                product[left_index + right_index] += left * right
        for degree in range(6, 3, -1):
            value = product[degree]
            for offset in range(4):
                product[degree - 4 + offset] -= value
        return Qzeta5(*product[:4])

    __rmul__ = __mul__

    def inverse(self):
        assert self
        basis = [Qzeta5(1), Qzeta5(0, 1), Qzeta5(0, 0, 1), Qzeta5(0, 0, 0, 1)]
        columns = [(self * vector).coefficients for vector in basis]
        matrix = [
            [columns[column][row] for column in range(4)]
            for row in range(4)
        ]
        return Qzeta5(*solve_fraction(matrix, [Fraction(1), 0, 0, 0]))

    def __truediv__(self, other):
        return self * self.coerce(other).inverse()

    def __rtruediv__(self, other):
        return self.coerce(other) / self

    def __pow__(self, exponent):
        assert exponent >= 0
        result = Qzeta5(1)
        base = self
        while exponent:
            if exponent & 1:
                result *= base
            base *= base
            exponent //= 2
        return result

    def __eq__(self, other):
        try:
            other = self.coerce(other)
        except (TypeError, ValueError):
            return False
        return self.coefficients == other.coefficients

    def __bool__(self):
        return any(self.coefficients)

    def serialized(self):
        return [str(value) for value in self.coefficients]


ZERO = Qzeta5(0)
ONE = Qzeta5(1)
ZETA = Qzeta5(0, 1)


def rref(matrix):
    if not matrix:
        return [], []
    work = [[Qzeta5.coerce(value) for value in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [value / scale for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            if scale:
                work[index] = [
                    left - scale * right
                    for left, right in zip(work[index], work[row], strict=True)
                ]
        pivots.append(column)
        row += 1
    return work[:row], pivots


def rank(matrix):
    return len(rref(matrix)[1]) if matrix else 0


def nullspace(matrix):
    reduced, pivots = rref(matrix)
    width = len(matrix[0])
    free = [column for column in range(width) if column not in pivots]
    result = []
    for column in free:
        vector = [ZERO] * width
        vector[column] = ONE
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column]
        result.append(vector)
    return result


def canonical_space(space):
    reduced, _ = rref(space)
    return [
        [entry.serialized() for entry in vector]
        for vector in reduced
    ]


def polynomial_product(left, right):
    result = [ZERO] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            result[left_index + right_index] += left_value * right_value
    return result


def polynomial_power(value, exponent):
    result = [ONE]
    for _ in range(exponent):
        result = polynomial_product(result, value)
    return result


def apolar_pair(left, right):
    assert len(left) == len(right) == 7
    return sum(
        ((-1) ** index)
        * math.factorial(index)
        * math.factorial(6 - index)
        * left[index]
        * right[6 - index]
        for index in range(7)
    )


def apolar_annihilator(space):
    equations = [
        [
            apolar_pair(
                [ONE if index == column else ZERO for index in range(7)],
                vector,
            )
            for column in range(7)
        ]
        for vector in space
    ]
    return nullspace(equations)


def intersection(left, right):
    return apolar_annihilator(
        apolar_annihilator(left) + apolar_annihilator(right)
    )


def intersection_dimension(left, right):
    return len(left) + len(right) - rank(left + right)


def falling(value, order):
    if value < order:
        return 0
    return math.factorial(value) // math.factorial(value - order)


def third_transvectant_matrix(dodecic):
    matrix = [[ZERO] * 7 for _ in range(13)]
    for column in range(7):
        px, py = 6 - column, column
        for index in range(4):
            left = (
                (-1) ** index
                * math.comb(3, index)
                * falling(px, 3 - index)
                * falling(py, index)
            )
            if not left:
                continue
            for coefficient, fx, fy in dodecic:
                right = (
                    coefficient
                    * falling(fx, index)
                    * falling(fy, 3 - index)
                )
                if not right:
                    continue
                output_y = py - index + fy - (3 - index)
                matrix[output_y][column] += left * right
    return matrix


def in_space(vector, space):
    return rank(space + [vector]) == len(space)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def certificate():
    # Klein's dodecic and its nontrivial D5-normalizer mate.  The dilation
    # X -> xi X with xi=-zeta^3 satisfies xi^5=-1 and sends F+ to xi F-.
    plus_form = [(ONE, 11, 1), (Qzeta5(11), 6, 6), (Qzeta5(-1), 1, 11)]
    minus_form = [(ONE, 11, 1), (Qzeta5(-11), 6, 6), (Qzeta5(-1), 1, 11)]
    plus_operator = third_transvectant_matrix(plus_form)
    minus_operator = third_transvectant_matrix(minus_form)
    plus_kernel = nullspace(plus_operator)
    minus_kernel = nullspace(minus_operator)
    assert rank(plus_operator) == rank(minus_operator) == 4
    assert len(plus_kernel) == len(minus_kernel) == 3

    plus_annihilator = apolar_annihilator(plus_kernel)
    minus_annihilator = apolar_annihilator(minus_kernel)
    common_kernel = intersection(plus_kernel, minus_kernel)
    common_annihilator = intersection(plus_annihilator, minus_annihilator)
    assert len(common_kernel) == 1
    assert len(common_annihilator) == 2

    axes = [("infinity", [ZERO, ONE, ZERO])]
    for exponent in range(5):
        value = ZETA**exponent
        axes.append(
            (
                str(exponent),
                [ONE, value, -(value**2)],
            )
        )
    axis_cubes = [polynomial_power(axis, 3) for _, axis in axes]
    assert all(len(cube) == 7 and in_space(cube, plus_kernel) for cube in axis_cubes)
    assert rank(axis_cubes) == 3

    e_lines = []
    e_prime_lines = []
    rows = []
    quadratic_basis = [[ONE, ZERO, ZERO], [ZERO, ONE, ZERO], [ZERO, ZERO, ONE]]
    for (label, axis), axis_cube in zip(axes, axis_cubes, strict=True):
        square = polynomial_power(axis, 2)
        tangent = [polynomial_product(square, vector) for vector in quadratic_basis]
        assert len(tangent) == rank(tangent) == 3
        assert in_space(axis_cube, tangent)
        e_line = intersection(plus_annihilator, tangent)
        e_prime_line = intersection(
            plus_annihilator, apolar_annihilator(tangent)
        )
        assert len(e_line) == len(e_prime_line) == 2
        e_lines.append(e_line)
        e_prime_lines.append(e_prime_line)
        rows.append(
            {
                "axis_label": label,
                "axis_quadratic": [entry.serialized() for entry in axis],
                "shared_kernel_cube": [
                    entry.serialized() for entry in axis_cube
                ],
                "tangent_plane": canonical_space(tangent),
                "E": canonical_space(e_line),
                "E_prime": canonical_space(e_prime_line),
            }
        )

    assert canonical_space(common_kernel) == canonical_space([axis_cubes[0]])
    assert canonical_space(common_annihilator) == canonical_space(e_lines[0])

    within_e = [
        intersection_dimension(e_lines[left], e_lines[right])
        for left, right in itertools.combinations(range(6), 2)
    ]
    within_e_prime = [
        intersection_dimension(e_prime_lines[left], e_prime_lines[right])
        for left, right in itertools.combinations(range(6), 2)
    ]
    cross = [
        [
            intersection_dimension(e_lines[left], e_prime_lines[right])
            for right in range(6)
        ]
        for left in range(6)
    ]
    assert within_e == [0] * 15
    assert within_e_prime == [0] * 15
    assert cross == [
        [0 if left == right else 1 for right in range(6)]
        for left in range(6)
    ]

    assert canonical_space(e_lines[0]) == canonical_space(
        [
            [ZERO, ZERO, ONE, ZERO, ZERO, ZERO, ZERO],
            [ZERO, ZERO, ZERO, ZERO, ONE, ZERO, ZERO],
        ]
    )
    assert canonical_space(e_prime_lines[0]) == canonical_space(
        [
            [ONE, ZERO, ZERO, ZERO, ZERO, Qzeta5(-2), ZERO],
            [ZERO, Qzeta5(2), ZERO, ZERO, ZERO, ZERO, ONE],
        ]
    )

    return {
        "schema": "c682-characteristic-zero-operator-schlafli-v1",
        "field": "Q(zeta_5), with zeta_5^4+zeta_5^3+zeta_5^2+zeta_5+1=0",
        "operator_realization": {
            "source": "Sym^6",
            "target": "Sym^12",
            "formula": "T_F(p)=(p,F)_3",
            "F_plus": "X^11Y+11X^6Y^6-XY^11",
            "F_minus": "X^11Y-11X^6Y^6-XY^11",
            "normalizer_dilation": "X -> xi X, xi=-zeta_5^3, xi^5=-1",
            "ranks": [rank(plus_operator), rank(minus_operator)],
            "plus_kernel": canonical_space(plus_kernel),
            "minus_kernel": canonical_space(minus_kernel),
            "shared_kernel": canonical_space(common_kernel),
            "common_annihilator": canonical_space(common_annihilator),
        },
        "six_axes_and_lines": rows,
        "double_six": {
            "E_pairwise_intersection_dimensions": within_e,
            "E_prime_pairwise_intersection_dimensions": within_e_prime,
            "E_vs_E_prime_intersection_dimensions": cross,
            "incidence_rule": "dim(E_i cap E'_j)=1 iff i!=j",
        },
        "interpretation": {
            "shared_kernel_line": "q_i^3",
            "tangent_plane": "q_i^2 Sym^2 = affine tangent space to the cubic Veronese at q_i^3",
            "E_i": "V_I cap q_i^2 Sym^2 = V_I cap V_mate",
            "E_i_prime": "V_I cap (q_i^2 Sym^2)^perp, the cubics singular at the i-th axis",
            "conclusion": (
                "The complementary Schlaefli six is the apolar-polar companion "
                "of the D5 operator branch, not merely an externally imposed "
                "outer automorphism."
            ),
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    text = serialized()
    if arguments.check:
        assert OUTPUT.read_text(encoding="utf-8") == text
        print(f"PASS {OUTPUT.name} {sha256(OUTPUT)}")
    else:
        OUTPUT.write_text(text, encoding="utf-8")
        print(f"WROTE {OUTPUT.name} {sha256(OUTPUT)}")


if __name__ == "__main__":
    main()
