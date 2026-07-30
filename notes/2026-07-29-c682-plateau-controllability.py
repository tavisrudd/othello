#!/usr/bin/env python3
"""Exact/modular probes for the C682 trivial-module plateau entrance."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from math import comb, factorial, gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
AMBIENT = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
EXACT = HERE / "2026-07-28-c682-klein-e8-free-covariant.py"
PRIME = 1_000_000_007
CERTIFICATE = HERE / "2026-07-29-c682-plateau-controllability.json"


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def matvec(matrix, vector, prime):
    return [
        sum(entry * value for entry, value in zip(row, vector)) % prime
        for row in matrix
    ]


def polynomial_vector(polynomial, degree, prime):
    return [
        polynomial.get((degree - index, index), 0) % prime
        for index in range(degree + 1)
    ]


def column_rank(columns, prime):
    if not columns:
        return 0
    rows = [list(row) for row in zip(*columns)]
    rank = 0
    for column in range(len(columns)):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column] % prime),
            None,
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column] % prime, -1, prime)
        rows[rank] = [entry * inverse % prime for entry in rows[rank]]
        for row in range(len(rows)):
            if row == rank or not rows[row][column] % prime:
                continue
            multiplier = rows[row][column] % prime
            rows[row] = [
                (entry - multiplier * pivot_entry) % prime
                for entry, pivot_entry in zip(rows[row], rows[rank])
            ]
        rank += 1
    return rank


def determinant(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    out = Fraction(1)
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column]
        out *= value
        work[column] = [entry / value for entry in work[column]]
        for row in range(column + 1, len(work)):
            if not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(work[row], work[column])
            ]
    return out


def normalized_left_null(columns):
    size = len(columns) + 1
    equations = [
        [Fraction(column[row]) for row in range(size)]
        for column in columns
    ]
    work = [row + [Fraction(0)] for row in equations]
    pivot_columns = []
    pivot_row = 0
    for column in range(size):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
    free = next(column for column in range(size) if column not in pivot_columns)
    vector = [Fraction(0)] * size
    vector[free] = Fraction(1)
    for row, pivot in reversed(list(enumerate(pivot_columns))):
        vector[pivot] = -sum(
            work[row][column] * vector[column]
            for column in range(pivot + 1, size)
        )
    return vector


def invariant_data(prime, ambient):
    exact = load(EXACT, "plateau_exact")
    _, klein, hessian, jacobian, _ = exact.build_data()
    reduce_mod = lambda polynomial: {
        monomial: int(coefficient) % prime
        for monomial, coefficient in polynomial.items()
        if int(coefficient) % prime
    }
    return ambient, reduce_mod(klein), reduce_mod(hessian), reduce_mod(jacobian)


def power(base, exponent, tools, prime):
    out = {(0, 0): 1}
    for _ in range(exponent):
        out = tools.multiply(out, base, prime)
    return out


def monomial(f_power, h_power, tools, klein, hessian, prime, jacobian=None):
    out = tools.multiply(
        power(klein, f_power, tools, prime),
        power(hessian, h_power, tools, prime),
        prime,
    )
    return tools.multiply(jacobian, out, prime) if jacobian is not None else out


def plateau_row(q, prime):
    if q < 1:
        raise ValueError("the first nontrivial plateau entrance has q=1")
    ambient = load(AMBIENT, "plateau_ambient")
    tools, klein, hessian, jacobian = invariant_data(prime, ambient)
    degree = 64 + 60 * q
    current = [
        polynomial_vector(
            monomial(
                2 + 5 * index,
                2 + 3 * (q - index),
                tools,
                klein,
                hessian,
                prime,
            ),
            degree,
            prime,
        )
        for index in range(q + 1)
    ]
    lower = [
        polynomial_vector(
            monomial(
                4 + 5 * index,
                3 * (q - index) - 1,
                tools,
                klein,
                hessian,
                prime,
                jacobian,
            ),
            degree - 6,
            prime,
        )
        for index in range(q)
    ]
    incoming_edge = ambient.delta_matrix(degree - 6, prime)
    incoming = [matvec(incoming_edge, vector, prime) for vector in lower]
    outgoing_edge = ambient.delta_matrix(degree, prime)
    outgoing_adjoint = ambient.adjoint(outgoing_edge, degree, prime)
    returned = [
        matvec(
            outgoing_adjoint,
            matvec(outgoing_edge, vector, prime),
            prime,
        )
        for vector in incoming
    ]
    incoming_rank = column_rank(incoming, prime)
    mixed_rank = max(
        column_rank(incoming + [vector], prime)
        for vector in returned
    )
    assert column_rank(current, prime) == q + 1
    assert incoming_rank == q
    assert mixed_rank <= q + 1
    return degree, incoming_rank, mixed_rank


def exact_power(base, exponent, tools):
    out = {(0, 0): 1}
    for _ in range(exponent):
        out = tools.multiply(out, base)
    return out


def exact_monomial(f_power, h_power, tools, klein, hessian, jacobian=None):
    out = tools.multiply(
        exact_power(klein, f_power, tools),
        exact_power(hessian, h_power, tools),
    )
    return tools.multiply(jacobian, out) if jacobian is not None else out


def verify_adjoint_ninth_identity(degree, tools, klein):
    third_columns = [
        tools.transvectant(
            {(degree - index, index): 1},
            klein,
            3,
        )
        for index in range(degree + 1)
    ]
    ninth_columns = [
        tools.transvectant(
            {(degree + 6 - index, index): 1},
            klein,
            9,
        )
        for index in range(degree + 7)
    ]
    for source_index, third_column in enumerate(third_columns):
        source_weight = (
            factorial(degree - source_index)
            * factorial(source_index)
        )
        for target_index, ninth_column in enumerate(ninth_columns):
            target_weight = (
                factorial(degree + 6 - target_index)
                * factorial(target_index)
            )
            adjoint_entry = Fraction(
                third_column.get(
                    (degree + 6 - target_index, target_index),
                    0,
                )
                * target_weight,
                source_weight,
            )
            ninth_entry = ninth_column.get(
                (degree - source_index, source_index),
                0,
            )
            assert adjoint_entry == Fraction(-ninth_entry, 60_480)


def exact_witness(q):
    exact = load(EXACT, "plateau_exact_engine")
    tools, klein, hessian, jacobian, _ = exact.build_data()
    degree = 64 + 60 * q
    current_polynomials = [
        exact_monomial(
            2 + 5 * index,
            2 + 3 * (q - index),
            tools,
            klein,
            hessian,
        )
        for index in range(q + 1)
    ]
    lower_polynomials = [
        exact_monomial(
            4 + 5 * index,
            3 * (q - index) - 1,
            tools,
            klein,
            hessian,
            jacobian,
        )
        for index in range(q)
    ]
    incoming_polynomials = [
        tools.transvectant(polynomial, klein, 3)
        for polynomial in lower_polynomials
    ]
    current_columns = [
        exact.coefficient_vector(polynomial, degree)
        for polynomial in current_polynomials
    ]
    incoming_coordinates = [
        exact.solve_columns(
            current_columns,
            exact.coefficient_vector(polynomial, degree),
        )
        for polynomial in incoming_polynomials
    ]
    incoming_vectors = [
        exact.coefficient_vector(polynomial, degree)
        for polynomial in incoming_polynomials
    ]
    returned_coordinates = []
    for polynomial in incoming_polynomials:
        returned_polynomial = tools.transvectant(
            tools.transvectant(polynomial, klein, 3),
            klein,
            9,
        )
        returned_coordinates.append(
            exact.solve_columns(
                current_columns,
                exact.coefficient_vector(returned_polynomial, degree),
            )
        )
    determinants = [
        determinant(
            [
                [column[row] for column in incoming_coordinates + [returned]]
                for row in range(q + 1)
            ]
        )
        for returned in returned_coordinates
    ]
    null = normalized_left_null(incoming_coordinates)
    mixing_scalars = [
        sum(left * right for left, right in zip(null, returned))
        for returned in returned_coordinates
    ]
    return (
        degree,
        determinants,
        incoming_coordinates,
        returned_coordinates,
        null,
        mixing_scalars,
    )


def finite_difference_degree(values):
    row = [Fraction(value) for value in values]
    for degree in range(len(values)):
        if len(set(row)) == 1:
            return degree
        row = [
            right - left
            for left, right in zip(row, row[1:])
        ]
    return None


def poly_trim(polynomial):
    out = [Fraction(value) for value in polynomial]
    while len(out) > 1 and not out[-1]:
        out.pop()
    return out


def poly_add(left, right):
    return poly_trim(
        [
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
            for index in range(max(len(left), len(right)))
        ]
    )


def poly_scale(polynomial, scalar):
    return poly_trim([Fraction(scalar) * value for value in polynomial])


def poly_multiply(left, right):
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            out[left_index + right_index] += left_value * right_value
    return poly_trim(out)


def interpolate(xs, ys):
    divided = [Fraction(value) for value in ys]
    coefficients = [divided[0]]
    for order in range(1, len(xs)):
        divided = [
            (right - left) / (xs[index + order] - xs[index])
            for index, (left, right) in enumerate(zip(divided, divided[1:]))
        ]
        coefficients.append(divided[0])
    out = [Fraction(0)]
    basis = [Fraction(1)]
    for index, coefficient in enumerate(coefficients):
        out = poly_add(out, poly_scale(basis, coefficient))
        basis = poly_multiply(basis, [-xs[index], 1])
    return out


def rational_add(left, right):
    left_numerator, left_denominator = left
    right_numerator, right_denominator = right
    return (
        poly_add(
            poly_multiply(left_numerator, right_denominator),
            poly_multiply(right_numerator, left_denominator),
        ),
        poly_multiply(left_denominator, right_denominator),
    )


def rational_multiply(left, right):
    return (
        poly_multiply(left[0], right[0]),
        poly_multiply(left[1], right[1]),
    )


def primitive_rational_coefficients(numerator, denominator):
    common_denominator = 1
    for coefficient in numerator + denominator:
        common_denominator = (
            common_denominator * coefficient.denominator
            // gcd(common_denominator, coefficient.denominator)
        )
    integer_numerator = [
        int(coefficient * common_denominator)
        for coefficient in numerator
    ]
    integer_denominator = [
        int(coefficient * common_denominator)
        for coefficient in denominator
    ]
    content = 0
    for value in integer_numerator + integer_denominator:
        content = gcd(content, abs(value))
    integer_numerator = [value // content for value in integer_numerator]
    integer_denominator = [value // content for value in integer_denominator]
    if integer_denominator[-1] < 0:
        integer_numerator = [-value for value in integer_numerator]
        integer_denominator = [-value for value in integer_denominator]
    return integer_numerator, integer_denominator


def poly_shift(polynomial, shift):
    out = [Fraction(0)] * len(polynomial)
    for degree, coefficient in enumerate(polynomial):
        for new_degree in range(degree + 1):
            out[new_degree] += (
                coefficient
                * comb(degree, new_degree)
                * shift ** (degree - new_degree)
            )
    return poly_trim(out)


def symbolic_boundary_witness():
    qs = list(range(6, 22))
    rows = {q: exact_witness(q) for q in qs}
    incoming = {}
    for distance in range(1, 4):
        for offset in range(3):
            values = []
            for q in qs:
                columns = rows[q][2]
                column = columns[q - distance]
                row = q - distance + offset
                values.append(column[row] if row <= q else 0)
            incoming[distance, offset] = interpolate(qs[:4], values[:4])
            assert all(
                sum(
                    coefficient * q**degree
                    for degree, coefficient in enumerate(
                        incoming[distance, offset]
                    )
                )
                == value
                for q, value in zip(qs, values)
            )
    returned = {}
    for offset in range(-4, 0):
        values = [rows[q][3][-1][offset] for q in qs]
        returned[offset] = interpolate(qs, values)
    null = {0: ([Fraction(1)], [Fraction(1)])}
    for distance in range(1, 4):
        tail = ([Fraction(0)], [Fraction(1)])
        for offset in (1, 2):
            if distance - offset < 0:
                continue
            tail = rational_add(
                tail,
                rational_multiply(
                    (incoming[distance, offset], [Fraction(1)]),
                    null[distance - offset],
                ),
            )
        null[distance] = (
            poly_scale(tail[0], -1),
            poly_multiply(
                tail[1],
                incoming[distance, 0],
            ),
        )
    scalar = ([Fraction(0)], [Fraction(1)])
    for distance in range(4):
        scalar = rational_add(
            scalar,
            rational_multiply(
                null[distance],
                (returned[-1 - distance], [Fraction(1)]),
            ),
        )
    numerator, denominator = primitive_rational_coefficients(
        scalar[0],
        scalar[1],
    )
    return numerator, denominator


def certificate():
    exact = load(EXACT, "plateau_adjoint_identity")
    tools, klein, _, _, _ = exact.build_data()
    for degree in (64, 124):
        verify_adjoint_ninth_identity(degree, tools, klein)
    numerator, denominator = symbolic_boundary_witness()
    shifted_numerator = [
        int(value)
        for value in poly_shift(numerator, 6)
    ]
    shifted_denominator = [
        int(value)
        for value in poly_shift(denominator, 6)
    ]
    assert all(value < 0 for value in shifted_numerator)
    assert all(value > 0 for value in shifted_denominator)
    low_rows = []
    for q in range(1, 6):
        degree, _, incoming, _, _, scalars = exact_witness(q)
        assert len(incoming) == q
        assert scalars[-1]
        low_rows.append(
            {
                "q": q,
                "degree": degree,
                "incoming_dimension": q,
                "current_dimension": q + 1,
                "last_boundary_mixing_scalar": str(scalars[-1]),
            }
        )
    return {
        "schema": "c682-trivial-plateau-controllability-v1",
        "family": {
            "q_domain": "integers q>=1",
            "degree": "n=64+60q",
            "current_basis": (
                "F^(2+5j) h^(2+3(q-j)), 0<=j<=q"
            ),
            "incoming_basis": (
                "t F^(4+5j) h^(3(q-j)-1), 0<=j<q"
            ),
            "incoming_operator": "(.,F)_3",
            "return_operator": "((.,F)_3,F)_9",
        },
        "symbolic_reduction": {
            "fischer_adjoint_identity": (
                "Delta_n^dagger=-(.,F)_9/60480"
            ),
            "adjoint_identity_exact_check_degrees": [64, 124],
            "incoming_coefficient_degree_bound": 3,
            "boundary_return_coefficient_degree_bound": 15,
            "interpolation_q_values": list(range(6, 22)),
            "boundary_support_width": 4,
            "mixing_numerator_coefficients_ascending": numerator,
            "mixing_denominator_coefficients_ascending": denominator,
            "shift": "q=r+6",
            "shifted_numerator_coefficients_ascending": shifted_numerator,
            "shifted_denominator_coefficients_ascending": shifted_denominator,
            "sign_conclusion": (
                "all shifted numerator coefficients are negative and all "
                "shifted denominator coefficients are positive"
            ),
        },
        "low_q_checks": low_rows,
        "conclusion": (
            "The first upward return mixes the incoming hyperplane at every "
            "trivial-module plateau entrance n=64+60q, q>=1."
        ),
        "claim_boundary": (
            "This certificate treats only the trivial McKay module. "
            "The 2,3,3' plateau families remain open."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("--max-q", type=int, default=8)
    parser.add_argument("--prime", type=int, default=PRIME)
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--show-coordinates", action="store_true")
    parser.add_argument("--degrees", action="store_true")
    parser.add_argument("--symbolic", action="store_true")
    arguments = parser.parse_args()
    if arguments.write or arguments.check:
        rendered = json.dumps(
            certificate(),
            indent=2,
            sort_keys=True,
        ) + "\n"
        if arguments.write:
            CERTIFICATE.write_text(rendered, encoding="utf-8")
            print(f"WROTE: {CERTIFICATE}")
        else:
            assert CERTIFICATE.read_text(encoding="utf-8") == rendered
            print("PASS: C682 trivial plateau controllability")
        return
    if arguments.symbolic:
        numerator, denominator = symbolic_boundary_witness()
        print(f"numerator_degree={len(numerator) - 1}")
        print(f"numerator_signs={sorted(set((value > 0) - (value < 0) for value in numerator))}")
        print(f"numerator={numerator}")
        for shift in (1, 6):
            shifted = poly_shift(numerator, shift)
            print(
                f"numerator_shift_{shift}_signs="
                f"{sorted(set((value > 0) - (value < 0) for value in shifted))}"
            )
        print(f"denominator_degree={len(denominator) - 1}")
        print(f"denominator_signs={sorted(set((value > 0) - (value < 0) for value in denominator))}")
        print(f"denominator={denominator}")
        for shift in (1, 6):
            shifted = poly_shift(denominator, shift)
            print(
                f"denominator_shift_{shift}_signs="
                f"{sorted(set((value > 0) - (value < 0) for value in shifted))}"
            )
        return
    if arguments.degrees:
        rows = [exact_witness(q) for q in range(6, arguments.max_q + 1)]
        for offset in range(-4, 0):
            values = [row[3][-1][offset] for row in rows]
            print(f"returned[{offset}]: degree {finite_difference_degree(values)}")
        return
    if arguments.exact:
        for q in range(1, arguments.max_q + 1):
            degree, determinants, incoming, returned, null, scalars = exact_witness(q)
            nonzero = [(index, value) for index, value in enumerate(determinants) if value]
            print(f"{degree}: {nonzero[:1]}")
            if arguments.show_coordinates:
                print(f"determinants={determinants}")
                print(f"null={null}")
                print(f"mixing_scalars={scalars}")
                print(f"incoming={incoming}")
                print(f"returned={returned}")
        return
    rows = [
        plateau_row(q, arguments.prime)
        for q in range(1, arguments.max_q + 1)
    ]
    for degree, incoming_rank, mixed_rank in rows:
        print(f"{degree}: {incoming_rank}->{mixed_rank}")


if __name__ == "__main__":
    main()
