#!/usr/bin/env python3
"""Independent standard-library replay of the transverse-gluing certificate."""

from fractions import Fraction
from itertools import combinations
from math import gcd, prod
from pathlib import Path
import sys


def matmul(left, right):
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def transpose(matrix):
    return [list(row) for row in zip(*matrix)]


def scale(number, matrix):
    return [[number * entry for entry in row] for row in matrix]


def diagonal(entries):
    return [[entries[i] if i == j else 0 for j in range(len(entries))]
            for i in range(len(entries))]


def alternating_form(scales):
    size = 2 * len(scales)
    form = [[0] * size for _ in range(size)]
    for index, value in enumerate(scales):
        form[2 * index][2 * index + 1] = value
        form[2 * index + 1][2 * index] = -value
    return form


def smith_of_diagonal(entries):
    """Recover Smith factors from determinantal divisors, not sorting."""
    divisors = [1]
    for size in range(1, len(entries) + 1):
        delta = 0
        for chosen in combinations(entries, size):
            delta = gcd(delta, abs(prod(chosen)))
        divisors.append(delta)
    assert all(divisors[i] % divisors[i - 1] == 0
               for i in range(1, len(divisors)))
    return tuple(divisors[i] // divisors[i - 1]
                 for i in range(1, len(divisors)))


def integer_valuation(value, prime):
    exponent = 0
    while value % prime == 0:
        value //= prime
        exponent += 1
    return exponent, value


def hilbert_symbol_integer(a, b, prime):
    alpha, unit_a = integer_valuation(a, prime)
    beta, unit_b = integer_valuation(b, prime)
    if prime == 2:
        epsilon_a = ((unit_a - 1) // 2) & 1
        epsilon_b = ((unit_b - 1) // 2) & 1
        omega_a = ((unit_a * unit_a - 1) // 8) & 1
        omega_b = ((unit_b * unit_b - 1) // 8) & 1
        parity = epsilon_a * epsilon_b + alpha * omega_b + beta * omega_a
        return -1 if parity & 1 else 1
    legendre_a = 1 if pow(unit_a % prime, (prime - 1) // 2, prime) == 1 else -1
    legendre_b = 1 if pow(unit_b % prime, (prime - 1) // 2, prime) == 1 else -1
    sign = -1 if ((prime - 1) // 2) & 1 else 1
    return sign ** (alpha * beta) * legendre_a ** beta * legendre_b ** alpha


def hasse_invariant(entries, prime):
    return prod(
        hilbert_symbol_integer(entries[left], entries[right], prime)
        for left in range(len(entries))
        for right in range(left + 1, len(entries))
    )


def poly(*coefficients):
    return tuple(Fraction(value) for value in coefficients)


def poly_add(left, right):
    size = max(len(left), len(right))
    result = tuple(
        (left[i] if i < len(left) else 0) +
        (right[i] if i < len(right) else 0)
        for i in range(size)
    )
    while len(result) > 1 and result[-1] == 0:
        result = result[:-1]
    return result


def poly_scale(number, value):
    return tuple(number * coefficient for coefficient in value)


def poly_mul(left, right):
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return tuple(result)


def poly_pow(value, exponent):
    result = poly(1)
    for _ in range(exponent):
        result = poly_mul(result, value)
    return result


def poly_eval(value, point):
    result = Fraction(0)
    for coefficient in reversed(value):
        result = result * point + coefficient
    return result


def poly_divmod(numerator, denominator):
    numerator = list(numerator)
    denominator = tuple(denominator)
    if denominator == (0,):
        raise ZeroDivisionError
    while len(numerator) > 1 and numerator[-1] == 0:
        numerator.pop()
    quotient = [Fraction(0)] * max(1, len(numerator) - len(denominator) + 1)
    while len(numerator) >= len(denominator) and any(numerator):
        shift = len(numerator) - len(denominator)
        coefficient = numerator[-1] / denominator[-1]
        quotient[shift] = coefficient
        for index, value in enumerate(denominator):
            numerator[index + shift] -= coefficient * value
        while len(numerator) > 1 and numerator[-1] == 0:
            numerator.pop()
    return tuple(quotient), tuple(numerator)


def poly_gcd(left, right):
    while any(right):
        _, remainder = poly_divmod(left, right)
        left, right = right, remainder
    return poly_scale(1 / left[-1], left)


def poly_derivative(value):
    return tuple(Fraction(index) * value[index]
                 for index in range(1, len(value))) or (Fraction(0),)


def main():
    # Independent rational-polynomial check of the two pulled-back square
    # classes.  Coefficients are stored low degree first.
    two_t_minus_one = poly(-1, 2)
    four_t_minus_one = poly(-1, 4)
    six_t_minus_one = poly(-1, 6)
    ten_t_minus_seven = poly(-7, 10)
    capital_t_numerator = poly_scale(
        -4, poly_mul(poly_pow(four_t_minus_one, 2), ten_t_minus_seven)
    )
    capital_t_denominator = poly_mul(
        poly_pow(two_t_minus_one, 2), six_t_minus_one
    )
    mod2_radical = poly_scale(
        -1, poly_mul(ten_t_minus_seven, six_t_minus_one)
    )
    square_numerator = poly_scale(2, four_t_minus_one)
    square_denominator = poly_mul(two_t_minus_one, six_t_minus_one)
    assert poly_mul(capital_t_numerator, poly_pow(square_denominator, 2)) == \
        poly_mul(
            poly_mul(capital_t_denominator, mod2_radical),
            poly_pow(square_numerator, 2),
        )

    twist_numerator = poly_mul(
        poly_add(capital_t_numerator, poly_scale(27, capital_t_denominator)),
        poly_add(
            capital_t_numerator,
            poly_scale(Fraction(-729, 5), capital_t_denominator),
        ),
    )
    quadratic = poly(79, -596, 796)
    twist_radical = poly_scale(
        -5,
        poly_mul(poly_mul(poly(1, 2), poly(-11, 26)), quadratic),
    )
    assert poly_scale(25, twist_numerator) == poly_mul(
        twist_radical, poly_pow(poly(1, 2), 2)
    )
    rational_roots = (
        Fraction(1, 6), Fraction(7, 10),
        Fraction(-1, 2), Fraction(11, 26),
    )
    assert len(set(rational_roots)) == 4
    assert 596**2 - 4 * 796 * 79 == 103680 != 0
    assert all(poly_eval(quadratic, root) != 0 for root in rational_roots)

    # Rational parametrization of the R-cover and independent verification of
    # the explicit degree-eight hyperelliptic model of the full V4-cover.
    parameter_numerator = poly(148, -12, 1)
    base_quadratic = poly(60, 0, 1)
    parameter_denominator = poly_scale(4, base_quadratic)
    u_numerator = poly_add(
        poly_scale(6, parameter_denominator),
        poly_mul(poly(0, 1), poly_add(
            poly_scale(4, parameter_numerator),
            poly_scale(-1, parameter_denominator),
        )),
    )
    six_a_minus_d = poly_add(
        poly_scale(6, parameter_numerator), poly_scale(-1, parameter_denominator)
    )
    ten_a_minus_seven_d = poly_add(
        poly_scale(10, parameter_numerator), poly_scale(-7, parameter_denominator)
    )
    assert poly_pow(u_numerator, 2) == poly_scale(
        -16, poly_mul(six_a_minus_d, ten_a_minus_seven_d)
    )

    substituted_twist_numerator = poly_scale(
        -5,
        poly_mul(
            poly_mul(
                poly_add(poly_scale(2, parameter_numerator), parameter_denominator),
                poly_add(
                    poly_scale(26, parameter_numerator),
                    poly_scale(-11, parameter_denominator),
                ),
            ),
            poly_add(
                poly_add(
                    poly_scale(796, poly_pow(parameter_numerator, 2)),
                    poly_scale(
                        -596,
                        poly_mul(parameter_numerator, parameter_denominator),
                    ),
                ),
                poly_scale(79, poly_pow(parameter_denominator, 2)),
            ),
        ),
    )
    hyperelliptic_factors = (
        poly(268, -12, 3),
        poly(164, -228, 9),
        poly(-1244, -36, 9),
        poly(-604, 156, 9),
    )
    hyperelliptic = poly_scale(
        -5,
        poly_mul(
            poly_mul(hyperelliptic_factors[0], hyperelliptic_factors[1]),
            poly_mul(hyperelliptic_factors[2], hyperelliptic_factors[3]),
        ),
    )
    assert poly_mul(
        poly_scale(16, poly_pow(base_quadratic, 4)),
        substituted_twist_numerator,
    ) == poly_mul(hyperelliptic, poly_pow(parameter_denominator, 4))
    assert len(hyperelliptic) - 1 == 8
    assert poly_gcd(hyperelliptic, poly_derivative(hyperelliptic)) == (Fraction(1),)

    h, m = 4, 1
    # Coordinates are ordered e1,f1,...,e5,f5.
    ambient = alternating_form([2] * h + [1] * m)
    left_scales = sum(([Fraction(1, 2), Fraction(1)] for _ in range(h)), [])
    left_scales += [Fraction(1), Fraction(1)] * m
    right_scales = sum(([Fraction(1), Fraction(1, 2)] for _ in range(h)), [])
    right_scales += [Fraction(1), Fraction(1)] * m
    left = diagonal(left_scales)
    right = diagonal(right_scales)
    right_inverse = diagonal([1 / value for value in right_scales])

    source_form = matmul(matmul(transpose(left), ambient), left)
    target_form = matmul(matmul(transpose(right), ambient), right)
    assert source_form == target_form == alternating_form([1] * (h + m))

    comparison_one = matmul(right_inverse, left)
    assert any(entry.denominator != 1 for row in comparison_one for entry in row)
    comparison_two = matmul(right_inverse, scale(2, left))
    assert all(entry.denominator == 1 for row in comparison_two for entry in row)
    assert matmul(matmul(transpose(comparison_two), target_form), comparison_two) \
        == scale(4, source_form)

    diagonal_entries = tuple(int(comparison_two[i][i])
                             for i in range(2 * (h + m)))
    invariants = smith_of_diagonal(diagonal_entries)
    assert invariants == (1, 1, 1, 1, 2, 2, 4, 4, 4, 4)
    assert prod(invariants) == 2**10
    assert gcd(*diagonal_entries) == 1

    # Direct finite-group fingerprints of the claimed cokernel.
    kernel_order = prod(invariants)
    kernel_exponent = max(invariants)
    killed_by_two = prod(gcd(2, value) for value in invariants)
    assert (kernel_order, kernel_exponent, killed_by_two) == (2**10, 4, 2**6)

    # Independent five-axis calculation.  The sixth simplex vector is
    # -(1,1,1,1,1), so the six rank-one tensors sum to I+J.  Multiplication by
    # G=6I-J gives 6I, identifying the sum as six minimal curve classes.
    identity = [[int(i == j) for j in range(5)] for i in range(5)]
    all_ones = [[1] * 5 for _ in range(5)]
    gram = [[6 * identity[i][j] - all_ones[i][j] for j in range(5)]
            for i in range(5)]
    axis_sum = [[identity[i][j] + all_ones[i][j] for j in range(5)]
                for i in range(5)]
    assert matmul(gram, axis_sum) == scale(6, identity)

    square_class_diagonal = (5, 30, 2, 1, 3)
    hasse = tuple(hasse_invariant(square_class_diagonal, prime)
                  for prime in (2, 3, 5))
    assert hasse == (-1, -1, 1)

    rendered = (
        "Independent transverse-gluing replay\n"
        "  pulled-back square classes R(deg2), S(deg4), RS(deg6) are squarefree and disjoint\n"
        "  corresponding double-cover genera=0,1,2; V4-cover genus=3\n"
        f"  integral comparison diagonal={diagonal_entries}\n"
        f"  determinantal-divisor Smith invariants={invariants}\n"
        "  multiplier=4; order=2^10; exponent=4; two-torsion order=2^6\n"
        "  six axis classes=6 times minimal; product-form Hasse obstruction at p=2,3\n"
        "PASS\n"
    )
    target = Path(__file__).with_name(
        "2026-08-10-c904-quartic-cubic-hecke-neighbor-replay.out"
    )
    if sys.argv[1:] == ["--write"]:
        target.write_text(rendered)
    elif sys.argv[1:] == ["--check"]:
        assert target.read_text() == rendered
        print("CHECK PASS")
    elif not sys.argv[1:]:
        print(rendered, end="")
    else:
        raise SystemExit("usage: quartic-cubic-hecke-neighbor-replay.py [--write|--check]")


if __name__ == "__main__":
    main()
