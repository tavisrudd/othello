#!/usr/bin/env python3
"""Exact characteristic-zero D5--S3 transvectant-kernel incidence."""

from __future__ import annotations

import argparse
import functools
import hashlib
import json
import math
from fractions import Fraction
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")


def solve_fraction(matrix, rhs):
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


class Qzeta30:
    """The field Q[z]/Phi_30(z), with z a primitive thirtieth root."""

    __slots__ = ("coefficients",)

    # Phi_30=x^8+x^7-x^5-x^4-x^3+x+1.
    modulus = (1, 1, 0, -1, -1, -1, 0, 1)

    def __init__(self, *coefficients):
        values = [Fraction(value) for value in coefficients]
        values.extend([Fraction(0)] * (8 - len(values)))
        assert len(values) == 8
        self.coefficients = tuple(values)

    @staticmethod
    def coerce(value):
        return value if isinstance(value, Qzeta30) else Qzeta30(value)

    def __add__(self, other):
        other = self.coerce(other)
        return Qzeta30(
            *(
                left + right
                for left, right in zip(
                    self.coefficients, other.coefficients, strict=True
                )
            )
        )

    __radd__ = __add__

    def __neg__(self):
        return Qzeta30(*(-value for value in self.coefficients))

    def __sub__(self, other):
        return self + (-self.coerce(other))

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        product = [Fraction(0)] * 15
        for left_index, left in enumerate(self.coefficients):
            for right_index, right in enumerate(other.coefficients):
                product[left_index + right_index] += left * right
        for degree in range(14, 7, -1):
            value = product[degree]
            for offset, coefficient in enumerate(self.modulus):
                product[degree - 8 + offset] -= value * coefficient
        return Qzeta30(*product[:8])

    __rmul__ = __mul__

    @functools.cache
    def inverse(self):
        assert self
        basis = [
            Qzeta30(*(int(index == exponent) for index in range(8)))
            for exponent in range(8)
        ]
        columns = [(self * vector).coefficients for vector in basis]
        matrix = [
            [columns[column][row] for column in range(8)]
            for row in range(8)
        ]
        return Qzeta30(
            *solve_fraction(matrix, [Fraction(1)] + [Fraction(0)] * 7)
        )

    def __truediv__(self, other):
        return self * self.coerce(other).inverse()

    def __rtruediv__(self, other):
        return self.coerce(other) / self

    def __pow__(self, exponent):
        if exponent < 0:
            return (self.inverse()) ** (-exponent)
        answer = Qzeta30(1)
        base = self
        while exponent:
            if exponent & 1:
                answer *= base
            base *= base
            exponent //= 2
        return answer

    def __eq__(self, other):
        try:
            other = self.coerce(other)
        except (TypeError, ValueError):
            return False
        return self.coefficients == other.coefficients

    def __bool__(self):
        return any(self.coefficients)

    def __hash__(self):
        return hash(self.coefficients)

    def serialized(self):
        return [str(value) for value in self.coefficients]


ZERO = Qzeta30(0)
ONE = Qzeta30(1)
ZETA = Qzeta30(0, 1)


def rref(matrix):
    if not matrix:
        return [], []
    work = [[Qzeta30.coerce(value) for value in row] for row in matrix]
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
    answer = []
    for column in free:
        vector = [ZERO] * width
        vector[column] = ONE
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column]
        answer.append(vector)
    return answer


def canonical_vector(vector):
    first = next(value for value in vector if value)
    return tuple(value / first for value in vector)


def canonical_space(space):
    reduced, _ = rref(space)
    return tuple(tuple(row) for row in reduced)


def serialized_space(space):
    return [
        [entry.serialized() for entry in row]
        for row in canonical_space(space)
    ]


def matrix_product(left, right):
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(2))
            for column in range(2)
        ]
        for row in range(2)
    ]


def matrix_inverse(matrix):
    determinant = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    assert determinant
    return [
        [matrix[1][1] / determinant, -matrix[0][1] / determinant],
        [-matrix[1][0] / determinant, matrix[0][0] / determinant],
    ]


def canonical_matrix(matrix):
    flat = [entry for row in matrix for entry in row]
    normalized = canonical_vector(flat)
    return (normalized[:2], normalized[2:])


def matrix_power(matrix, exponent):
    answer = [[ONE, ZERO], [ZERO, ONE]]
    for _ in range(exponent):
        answer = matrix_product(answer, matrix)
    return answer


def polynomial_product(left, right):
    answer = [ZERO] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            answer[left_index + right_index] += left_value * right_value
    return answer


def polynomial_power(value, exponent):
    answer = [ONE]
    for _ in range(exponent):
        answer = polynomial_product(answer, value)
    return answer


def transform_form(form, matrix):
    x_linear = [matrix[0][0], matrix[0][1]]
    y_linear = [matrix[1][0], matrix[1][1]]
    x_powers = [polynomial_power(x_linear, exponent) for exponent in range(13)]
    y_powers = [polynomial_power(y_linear, exponent) for exponent in range(13)]
    answer = [ZERO] * 13
    for y_degree, coefficient in enumerate(form):
        if not coefficient:
            continue
        monomial = polynomial_product(
            x_powers[12 - y_degree], y_powers[y_degree]
        )
        for index, value in enumerate(monomial):
            answer[index] += coefficient * value
    return answer


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
            for fy, coefficient in enumerate(dodecic):
                fx = 12 - fy
                right = coefficient * falling(fx, index) * falling(
                    fy, 3 - index
                )
                if not right:
                    continue
                output_y = py - index + fy - (3 - index)
                matrix[output_y][column] += left * right
    return matrix


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


def intersection_dimension(left, right):
    return len(left) + len(right) - rank(list(left) + list(right))


def in_space(vector, space):
    return rank(list(space) + [vector]) == len(space)


def determinant3(matrix):
    assert len(matrix) == 3 and all(len(row) == 3 for row in matrix)
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def normalized_cross_gram(left, right):
    left_gram = [[apolar_pair(x, y) for y in left] for x in left]
    right_gram = [[apolar_pair(x, y) for y in right] for x in right]
    cross = [[apolar_pair(x, y) for y in right] for x in left]
    left_determinant = determinant3(left_gram)
    right_determinant = determinant3(right_gram)
    assert left_determinant and right_determinant
    return determinant3(cross) ** 2 / (left_determinant * right_determinant)


def generate_group(generators):
    identity = canonical_matrix([[ONE, ZERO], [ZERO, ONE]])
    seen = {identity}
    queue = [identity]
    while queue:
        current = queue.pop(0)
        for generator in generators:
            product = canonical_matrix(matrix_product(current, generator))
            if product not in seen:
                seen.add(product)
                queue.append(product)
        assert len(seen) <= 60
    assert len(seen) == 60
    return sorted(
        seen,
        key=lambda matrix: tuple(
            str(coefficient)
            for row in matrix
            for entry in row
            for coefficient in entry.coefficients
        ),
    )


def subgroup_normalizer(group, cyclic_generator):
    cyclic = {
        canonical_matrix(matrix_power(cyclic_generator, exponent))
        for exponent in range(6)
    }
    cyclic.discard(canonical_matrix([[ONE, ZERO], [ZERO, ONE]]))
    inverse_cache = {matrix: matrix_inverse(matrix) for matrix in group}
    answer = []
    for matrix in group:
        conjugate = canonical_matrix(
            matrix_product(
                matrix_product(matrix, cyclic_generator),
                inverse_cache[matrix],
            )
        )
        if conjugate in cyclic:
            answer.append(matrix)
    return answer


def orbit_forms(group, form):
    forms = {}
    for matrix in group:
        transformed = transform_form(form, matrix)
        forms.setdefault(canonical_vector(transformed), (transformed, matrix))
    return list(forms.values())


def conjugate_subgroup(subgroup, orbit_representative):
    inverse = matrix_inverse(orbit_representative)
    return {
        canonical_matrix(
            matrix_product(
                matrix_product(inverse, matrix), orbit_representative
            )
        )
        for matrix in subgroup
    }


def construct_s3_normalizer(cubic):
    omega = ZETA**10
    eta = ZETA**5
    trace = cubic[0][0] + cubic[1][1]
    determinant = cubic[0][0] * cubic[1][1] - cubic[0][1] * cubic[1][0]
    mu = trace / (ONE + omega)
    if determinant != mu * mu * omega:
        omega = omega**2
        eta = ZETA**25
        mu = trace / (ONE + omega)
    assert determinant == mu * mu * omega
    high = nullspace(
        [
            [cubic[0][0] - mu * omega, cubic[0][1]],
            [cubic[1][0], cubic[1][1] - mu * omega],
        ]
    )[0]
    low = nullspace(
        [
            [cubic[0][0] - mu, cubic[0][1]],
            [cubic[1][0], cubic[1][1] - mu],
        ]
    )[0]
    change = [[high[0], low[0]], [high[1], low[1]]]
    normalizer = matrix_product(
        matrix_product(change, [[eta, ZERO], [ZERO, ONE]]),
        matrix_inverse(change),
    )
    assert canonical_matrix(matrix_power(normalizer, 2)) == canonical_matrix(cubic)
    return normalizer


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def certificate():
    zeta5 = ZETA**6
    order_five = [[zeta5**2, ZERO], [ZERO, ONE]]
    u = zeta5 - zeta5**4
    v = zeta5**2 - zeta5**3
    involution = [[v, u], [u, -v]]
    order_three = matrix_product(order_five, involution)
    identity = canonical_matrix([[ONE, ZERO], [ZERO, ONE]])
    assert canonical_matrix(matrix_power(order_five, 5)) == identity
    assert canonical_matrix(matrix_power(involution, 2)) == identity
    assert canonical_matrix(matrix_power(order_three, 3)) == identity

    group = generate_group([order_five, involution])
    base_form = [ZERO] * 13
    base_form[1] = ONE
    base_form[6] = Qzeta30(11)
    base_form[11] = Qzeta30(-1)
    assert all(
        canonical_vector(transform_form(base_form, matrix))
        == canonical_vector(base_form)
        for matrix in group
    )

    d5_outer = [[ZERO, ONE], [ONE, ZERO]]
    d5_form = transform_form(base_form, d5_outer)
    s3_outer = construct_s3_normalizer(order_three)
    s3_form = transform_form(base_form, s3_outer)

    d5_subgroup = subgroup_normalizer(group, order_five)
    s3_subgroup = subgroup_normalizer(group, order_three)
    assert len(d5_subgroup) == 10
    assert len(s3_subgroup) == 6
    assert canonical_matrix(d5_outer) not in group
    assert canonical_matrix(s3_outer) not in group
    assert {
        canonical_matrix(
            matrix_product(
                matrix_product(d5_outer, matrix), matrix_inverse(d5_outer)
            )
        )
        for matrix in d5_subgroup
    } == set(d5_subgroup)
    assert {
        canonical_matrix(
            matrix_product(
                matrix_product(s3_outer, matrix), matrix_inverse(s3_outer)
            )
        )
        for matrix in s3_subgroup
    } == set(s3_subgroup)

    d5_forms = orbit_forms(group, d5_form)
    s3_forms = orbit_forms(group, s3_form)
    assert len(d5_forms) == 6
    assert len(s3_forms) == 10
    base_operator = third_transvectant_matrix(base_form)
    base_kernel = nullspace(base_operator)
    assert rank(base_operator) == 4
    assert len(base_kernel) == 3

    d5_rows = []
    d5_kernels = []
    d5_traces = []
    d5_stabilizers = []
    for index, (form, orbit_representative) in enumerate(d5_forms):
        operator = third_transvectant_matrix(form)
        kernel = nullspace(operator)
        point_stabilizer = conjugate_subgroup(
            d5_subgroup, orbit_representative
        )
        assert rank(operator) == 4
        assert len(kernel) == 3
        assert len(point_stabilizer) == 10
        trace = apolar_annihilator(base_kernel + kernel)
        assert len(trace) == 2
        d5_kernels.append(kernel)
        d5_traces.append(trace)
        d5_stabilizers.append(set(point_stabilizer))
        d5_rows.append(
            {
                "index": index,
                "kernel": serialized_space(kernel),
                "base_relative_common_annihilator": serialized_space(trace),
            }
        )

    s3_rows = []
    s3_kernels = []
    s3_traces = []
    s3_stabilizers = []
    for index, (form, orbit_representative) in enumerate(s3_forms):
        operator = third_transvectant_matrix(form)
        kernel = nullspace(operator)
        point_stabilizer = conjugate_subgroup(
            s3_subgroup, orbit_representative
        )
        assert rank(operator) == 4
        assert len(kernel) == 3
        assert len(point_stabilizer) == 6
        trace = apolar_annihilator(base_kernel + kernel)
        assert len(trace) == 1
        s3_kernels.append(kernel)
        s3_traces.append(trace)
        s3_stabilizers.append(set(point_stabilizer))
        s3_rows.append(
            {
                "index": index,
                "kernel": serialized_space(kernel),
                "base_relative_common_annihilator": serialized_space(trace),
            }
        )

    kernel_intersections = []
    stabilizer_intersections = []
    for d5_index in range(6):
        kernel_row = []
        stabilizer_row = []
        for s3_index in range(10):
            kernel_dimension = intersection_dimension(
                d5_kernels[d5_index], s3_kernels[s3_index]
            )
            stabilizer_order = len(
                d5_stabilizers[d5_index] & s3_stabilizers[s3_index]
            )
            assert stabilizer_order in (1, 2)
            assert kernel_dimension in (0, 1)
            kernel_row.append(kernel_dimension)
            stabilizer_row.append(stabilizer_order)
        kernel_intersections.append(kernel_row)
        stabilizer_intersections.append(stabilizer_row)

    row_degrees = [sum(row) for row in kernel_intersections]
    column_degrees = [
        sum(kernel_intersections[row][column] for row in range(6))
        for column in range(10)
    ]
    edge_count = sum(row_degrees)
    assert edge_count == 0
    trace_incidence = [
        [
            int(in_space(s3_traces[s3_index][0], d5_traces[d5_index]))
            for s3_index in range(10)
        ]
        for d5_index in range(6)
    ]
    trace_row_degrees = [sum(row) for row in trace_incidence]
    trace_column_degrees = [
        sum(trace_incidence[row][column] for row in range(6))
        for column in range(10)
    ]
    cross_gram_values = [
        [
            normalized_cross_gram(
                d5_kernels[d5_index], s3_kernels[s3_index]
            )
            for s3_index in range(10)
        ]
        for d5_index in range(6)
    ]
    distinct_cross_gram = sorted(
        {value for row in cross_gram_values for value in row},
        key=lambda value: tuple(str(entry) for entry in value.coefficients),
    )
    cross_gram_multiplicities = [
        sum(
            value == target
            for row in cross_gram_values
            for value in row
        )
        for target in distinct_cross_gram
    ]
    sqrt_five = 2 * (ZETA**2 + ZETA**3 - ZETA**7) - ONE
    assert sqrt_five**2 == Qzeta30(5)
    lambda_plus = (
        Qzeta30(54781) + Qzeta30(24288) * sqrt_five
    ) / Qzeta30(820125)
    lambda_minus = (
        Qzeta30(54781) - Qzeta30(24288) * sqrt_five
    ) / Qzeta30(820125)
    assert set(distinct_cross_gram) == {lambda_plus, lambda_minus}
    assert cross_gram_multiplicities == [30, 30]
    golden_incidence = [
        [int(value == lambda_plus) for value in row]
        for row in cross_gram_values
    ]
    golden_row_degrees = [sum(row) for row in golden_incidence]
    golden_column_degrees = [
        sum(golden_incidence[row][column] for row in range(6))
        for column in range(10)
    ]
    assert golden_row_degrees == [5] * 6
    assert golden_column_degrees == [3] * 10
    denominator_mod_11 = 820125 % 11
    midpoint_mod_11 = (
        (54781 % 11) * pow(denominator_mod_11, -1, 11)
    ) % 11
    divided_scale_mod_11 = (
        (2208 % 11) * pow(denominator_mod_11, -1, 11)
    ) % 11
    divided_values_mod_11 = sorted(
        {
            divided_scale_mod_11 * square_root % 11
            for square_root in (4, 7)
        }
    )
    assert midpoint_mod_11 == 5
    assert divided_values_mod_11 == [5, 6]

    return {
        "schema": "c682-characteristic-zero-d5-s3-kernel-incidence-v1",
        "field": (
            "Q(zeta_30), Phi_30=z^8+z^7-z^5-z^4-z^3+z+1"
        ),
        "group": {
            "ambient": "PGL_2",
            "icosahedral_subgroup_order": len(group),
            "D5_stabilizer_order": len(d5_subgroup),
            "S3_stabilizer_order": len(s3_subgroup),
            "D5_orbit_size": len(d5_forms),
            "S3_orbit_size": len(s3_forms),
        },
        "operator": {
            "formula": "T_F(p)=(p,F)_3: Sym^6 -> Sym^12",
            "all_mate_ranks": {
                "D5": [4] * 6,
                "S3": [4] * 10,
            },
        },
        "D5_mates": d5_rows,
        "S3_mates": s3_rows,
        "incidence": {
            "kernel_intersection_dimensions": kernel_intersections,
            "stabilizer_intersection_orders": stabilizer_intersections,
            "row_degrees": row_degrees,
            "column_degrees": column_degrees,
            "edge_count": edge_count,
            "base_relative_common_annihilator_incidence": trace_incidence,
            "base_relative_row_degrees": trace_row_degrees,
            "base_relative_column_degrees": trace_column_degrees,
            "base_relative_edge_count": sum(trace_row_degrees),
            "normalized_cross_gram_values": [
                [value.serialized() for value in row]
                for row in cross_gram_values
            ],
            "distinct_normalized_cross_gram_values": [
                value.serialized() for value in distinct_cross_gram
            ],
            "normalized_cross_gram_multiplicities": cross_gram_multiplicities,
            "golden_values": {
                "sqrt5": sqrt_five.serialized(),
                "lambda_plus": lambda_plus.serialized(),
                "lambda_minus": lambda_minus.serialized(),
                "closed_form": (
                    "lambda_+/-=(54781 +/- 24288 sqrt(5))/820125"
                ),
                "trace": "109562/820125",
                "norm": "51423241/672605015625",
                "discriminant_square_class": "5",
                "prime_11_collision": {
                    "24288_factorization": "11*2208",
                    "common_reduction": midpoint_mod_11,
                    "divided_centered_values": divided_values_mod_11,
                    "interpretation": (
                        "The two golden values coalesce at 5 modulo 11; "
                        "after division by 11 their centered first digits "
                        "are +/-5 on the two sqrt(5) sheets."
                    ),
                },
            },
            "lambda_plus_incidence": golden_incidence,
            "lambda_plus_row_degrees": golden_row_degrees,
            "lambda_plus_column_degrees": golden_column_degrees,
            "lambda_minus_is_complement": True,
        },
        "interpretation": (
            "Direct D5--S3 kernel intersection is empty in characteristic "
            "zero, so the mod-11 Bockstein rank equation does not lift "
            "literally. The normalized apolar cross-Gram invariant of the "
            "two kernel planes takes two conjugate Q(sqrt(5)) values, each "
            "on thirty pairs. Choosing either golden value cuts out a "
            "(6_5,10_3) design, and Galois conjugation exchanges the design "
            "with its complement."
        ),
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
