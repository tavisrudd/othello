#!/usr/bin/env python3
"""Exact certificate for C548's four-copy contraction rank-drop divisor."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import tempfile
from collections import Counter
from fractions import Fraction
from pathlib import Path
from typing import Iterable, Sequence


STEM = "2026-07-23-c548-c397-contraction-rank-drop-divisor"
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / f"{STEM}.json"
COPIES = 4
PARTIES = 6
IDENTITY4 = tuple(range(COPIES))
SEED_TAIL = (
    (3, 2, 1, 0),
    (0, 1, 3, 2),
    (2, 3, 0, 1),
    (1, 0, 3, 2),
    (2, 0, 1, 3),
)

# Polynomials are little-endian tuples of integers, primitive normalization
# being applied only where explicitly requested.
Poly = tuple[int, ...]
ZERO: Poly = ()
ONE: Poly = (1,)
T: Poly = (0, 1)


def trim(values: Iterable[int]) -> Poly:
    result = list(values)
    while result and result[-1] == 0:
        result.pop()
    return tuple(result)


def padd(left: Poly, right: Poly) -> Poly:
    return trim(
        (left[index] if index < len(left) else 0)
        + (right[index] if index < len(right) else 0)
        for index in range(max(len(left), len(right)))
    )


def pneg(value: Poly) -> Poly:
    return tuple(-coefficient for coefficient in value)


def psub(left: Poly, right: Poly) -> Poly:
    return padd(left, pneg(right))


def pmul(left: Poly, right: Poly) -> Poly:
    if not left or not right:
        return ZERO
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return trim(result)


def pscale(value: Poly, scalar: int) -> Poly:
    return trim(scalar * coefficient for coefficient in value)


def pdivmod_q(numerator: Poly, denominator: Poly) -> tuple[list[object], list[object]]:
    """Division over Q, with Fraction imported lazily to keep hot paths lean."""
    from fractions import Fraction

    if not denominator:
        raise ZeroDivisionError
    remainder = [Fraction(value) for value in numerator]
    divisor = [Fraction(value) for value in denominator]
    quotient = [Fraction(0)] * max(1, len(remainder) - len(divisor) + 1)
    while len(remainder) >= len(divisor) and any(remainder):
        while remainder and remainder[-1] == 0:
            remainder.pop()
        if len(remainder) < len(divisor):
            break
        shift = len(remainder) - len(divisor)
        scale = remainder[-1] / divisor[-1]
        quotient[shift] += scale
        for index, value in enumerate(divisor):
            remainder[index + shift] -= scale * value
    while quotient and quotient[-1] == 0:
        quotient.pop()
    while remainder and remainder[-1] == 0:
        remainder.pop()
    return quotient, remainder


def pdivexact(numerator: Poly, denominator: Poly) -> Poly:
    quotient, remainder = pdivmod_q(numerator, denominator)
    if remainder:
        raise ArithmeticError("nonexact Bareiss division")
    if any(value.denominator != 1 for value in quotient):
        raise ArithmeticError("nonintegral Bareiss quotient")
    return trim(int(value) for value in quotient)


def primitive(value: Poly) -> Poly:
    if not value:
        return ZERO
    content = math.gcd(*(abs(coefficient) for coefficient in value))
    result = tuple(coefficient // content for coefficient in value)
    if result[-1] < 0:
        result = pneg(result)
    return result


def pgcd(left: Poly, right: Poly) -> Poly:
    from fractions import Fraction

    a = [Fraction(value) for value in left]
    b = [Fraction(value) for value in right]
    while b:
        while b and b[-1] == 0:
            b.pop()
        if not b:
            break
        remainder = a[:]
        while len(remainder) >= len(b):
            scale = remainder[-1] / b[-1]
            shift = len(remainder) - len(b)
            for index, value in enumerate(b):
                remainder[index + shift] -= scale * value
            while remainder and remainder[-1] == 0:
                remainder.pop()
        a, b = b, remainder
    if not a:
        return ZERO
    leading = a[-1]
    monic = [value / leading for value in a]
    denominator = math.lcm(*(value.denominator for value in monic))
    return primitive(trim(int(value * denominator) for value in monic))


def peval_mod(value: Poly, point: int, prime: int) -> int:
    result = 0
    for coefficient in reversed(value):
        result = (result * point + coefficient) % prime
    return result


def det_bareiss(matrix: Sequence[Sequence[Poly]]) -> Poly:
    size = len(matrix)
    work = [[tuple(value) for value in row] for row in matrix]
    sign = 1
    previous = ONE
    for column in range(size - 1):
        pivot = next((row for row in range(column, size) if work[row][column]), None)
        if pivot is None:
            return ZERO
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        pivot_value = work[column][column]
        for row in range(column + 1, size):
            for target in range(column + 1, size):
                numerator = psub(
                    pmul(work[row][target], pivot_value),
                    pmul(work[row][column], work[column][target]),
                )
                work[row][target] = (
                    numerator if column == 0 else pdivexact(numerator, previous)
                )
            work[row][column] = ZERO
        previous = pivot_value
    return pscale(work[-1][-1], sign)


def perm_compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def perm_inverse(permutation: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(permutation.index(index) for index in range(len(permutation)))


def permuted_sigmas(party_permutation: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    source = (IDENTITY4,) + SEED_TAIL
    target: list[tuple[int, ...] | None] = [None] * PARTIES
    for party in range(PARTIES):
        target[party_permutation[party]] = source[party]
    raw = tuple(value for value in target if value is not None)
    left = perm_inverse(raw[0])
    return (IDENTITY4,) + tuple(perm_compose(left, raw[index]) for index in range(1, PARTIES))


def code_columns() -> tuple[tuple[Poly, Poly, Poly], ...]:
    """A polynomial generator for ker H(t), scaled by 2(t-1)."""
    tm1 = (-1, 1)
    tm1sq = pmul(tm1, tm1)
    two_tm1 = pscale(tm1, 2)
    # Coefficients of free coordinates u=x4, v=x5, w=x6.
    row1 = (
        pscale(tm1sq, -2),
        psub(pneg(tm1sq), T),
        padd(pneg(tm1sq), T),
    )
    row2 = (
        pscale(tm1sq, -2),
        padd(pneg(tm1sq), T),
        psub(pneg(tm1sq), T),
    )
    row3 = (pneg(two_tm1), pneg(two_tm1), pneg(two_tm1))
    row4 = (two_tm1, ZERO, ZERO)
    row5 = (ZERO, two_tm1, ZERO)
    row6 = (ZERO, ZERO, two_tm1)
    return tuple((row1, row2, row3, row4, row5, row6))


def contraction_matrix(sigmas: Sequence[tuple[int, ...]]) -> list[list[Poly]]:
    """Return the 24x21 quotient matrix, deleting bra-copy zero."""
    columns = code_columns()
    rows: list[list[Poly]] = []
    for party in range(PARTIES):
        code_column = columns[party]
        for copy in range(COPIES):
            equation = [ZERO] * (6 * COPIES)
            for coordinate, value in enumerate(code_column):
                equation[3 * copy + coordinate] = value
                equation[3 * COPIES + 3 * sigmas[party][copy] + coordinate] = pneg(value)
            del equation[3 * COPIES : 3 * COPIES + 3]
            rows.append(equation)
    return rows


def independent_rows(
    matrix: Sequence[Sequence[Poly]],
    point: int = 37,
    prime: int = 1000003,
    row_order: Sequence[int] | None = None,
) -> list[int]:
    numeric = [
        [peval_mod(value, point, prime) for value in row]
        for row in matrix
    ]
    chosen: list[int] = []
    basis: list[tuple[int, list[int]]] = []
    for row_index in row_order or range(len(numeric)):
        source = numeric[row_index]
        row = source[:]
        for pivot, vector in basis:
            if row[pivot]:
                scale = row[pivot] * pow(vector[pivot], prime - 2, prime) % prime
                row = [(left - scale * right) % prime for left, right in zip(row, vector)]
        pivot = next((index for index, value in enumerate(row) if value), None)
        if pivot is None:
            continue
        basis.append((pivot, row))
        basis.sort()
        chosen.append(row_index)
        if len(chosen) == len(matrix[0]):
            return chosen
    raise ArithmeticError("generic rank below 21 at row-selection point")


def saturate_boundary(value: Poly) -> Poly:
    result = primitive(value)
    # The admitted non-GRS pencil in C396 inverts t, t-1, B, and the
    # conic/GRS quartic.
    boundary_factors = (
        T,
        (-1, 1),
        (1, -4, 5, -4, 1),
        (1, -4, 7, -4, 1),
    )
    for factor in boundary_factors:
        while result:
            quotient, remainder = pdivmod_q(result, factor)
            if remainder:
                break
            result = trim(int(coefficient) for coefficient in quotient)
    return primitive(result)


def maximal_minor_witness(
    matrix: Sequence[Sequence[Poly]], stop_divisor: Poly
) -> tuple[Poly, list[list[int]]]:
    orders = [
        list(range(24)),
        list(reversed(range(24))),
        list(range(1, 24)) + [0],
        list(range(6, 24)) + list(range(6)),
        [value for block in zip(range(12), range(12, 24)) for value in block],
        [value for block in zip(range(6), range(6, 12), range(12, 18), range(18, 24)) for value in block],
    ]
    points = (37, 41, 43, 47, 53, 59)
    divisor = ZERO
    witnesses: list[list[int]] = []
    for order, point in zip(orders, points):
        selected = independent_rows(matrix, point=point, row_order=order)
        raw_determinant = det_bareiss([matrix[index] for index in selected])
        content = math.gcd(*(abs(coefficient) for coefficient in raw_determinant))
        odd_content = content
        while odd_content and odd_content % 2 == 0:
            odd_content //= 2
        if odd_content != 1:
            raise AssertionError(f"maximal-minor witness has odd vertical content {content}")
        determinant = saturate_boundary(raw_determinant)
        divisor = determinant if not divisor else pgcd(divisor, determinant)
        witnesses.append(selected)
        quotient, remainder = pdivmod_q(stop_divisor, divisor)
        if not remainder and all(value.denominator == 1 for value in quotient):
            return divisor, witnesses
    return divisor, witnesses


def rank_numeric(matrix: Sequence[Sequence[Poly]], point: int, prime: int) -> int:
    work = [[peval_mod(value, point, prime) for value in row] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], prime - 2, prime)
        work[rank] = [(value * inverse) % prime for value in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                (left - scale * right) % prime
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


QPoly = tuple[Fraction, ...]


def qtrim(values: Iterable[Fraction]) -> QPoly:
    result = list(values)
    while result and result[-1] == 0:
        result.pop()
    return tuple(result)


def qdivmod(numerator: QPoly, denominator: QPoly) -> tuple[QPoly, QPoly]:
    remainder = list(numerator)
    quotient = [Fraction(0)] * max(1, len(remainder) - len(denominator) + 1)
    while len(remainder) >= len(denominator):
        shift = len(remainder) - len(denominator)
        scale = remainder[-1] / denominator[-1]
        quotient[shift] += scale
        for index, value in enumerate(denominator):
            remainder[index + shift] -= scale * value
        remainder = list(qtrim(remainder))
    return qtrim(quotient), qtrim(remainder)


def qadd(left: QPoly, right: QPoly) -> QPoly:
    return qtrim(
        (left[index] if index < len(left) else 0)
        + (right[index] if index < len(right) else 0)
        for index in range(max(len(left), len(right)))
    )


def qneg(value: QPoly) -> QPoly:
    return tuple(-coefficient for coefficient in value)


def qmul(left: QPoly, right: QPoly) -> QPoly:
    if not left or not right:
        return ()
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return qtrim(result)


def qreduce(value: QPoly, modulus: QPoly) -> QPoly:
    return qdivmod(value, modulus)[1]


def qinverse(value: QPoly, modulus: QPoly) -> QPoly:
    old_r, r = modulus, value
    old_s, s = (), (Fraction(1),)
    while r:
        quotient, remainder = qdivmod(old_r, r)
        old_r, r = r, remainder
        old_s, s = s, qadd(old_s, qneg(qmul(quotient, s)))
    if len(old_r) != 1:
        raise ArithmeticError("nonunit in claimed irreducible quotient")
    return qreduce(tuple(coefficient / old_r[0] for coefficient in old_s), modulus)


def rank_quotient(matrix: Sequence[Sequence[Poly]], factor: Poly) -> int:
    modulus = tuple(Fraction(value, factor[-1]) for value in factor)
    work = [
        [qreduce(tuple(Fraction(coefficient) for coefficient in value), modulus) for value in row]
        for row in matrix
    ]
    rank = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = qinverse(work[rank][column], modulus)
        work[rank] = [qreduce(qmul(value, inverse), modulus) for value in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                qreduce(qadd(left, qneg(qmul(scale, right))), modulus)
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def fptrim(values: Iterable[int], prime: int) -> tuple[int, ...]:
    result = [value % prime for value in values]
    while result and result[-1] == 0:
        result.pop()
    return tuple(result)


def fpdivmod(
    numerator: tuple[int, ...], denominator: tuple[int, ...], prime: int
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    remainder = list(fptrim(numerator, prime))
    divisor = fptrim(denominator, prime)
    quotient = [0] * max(1, len(remainder) - len(divisor) + 1)
    inverse = pow(divisor[-1], prime - 2, prime)
    while len(remainder) >= len(divisor):
        shift = len(remainder) - len(divisor)
        scale = remainder[-1] * inverse % prime
        quotient[shift] = scale
        for index, value in enumerate(divisor):
            remainder[index + shift] = (
                remainder[index + shift] - scale * value
            ) % prime
        remainder = list(fptrim(remainder, prime))
    return fptrim(quotient, prime), fptrim(remainder, prime)


def fpadd(
    left: tuple[int, ...], right: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    return fptrim(
        [
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
            for index in range(max(len(left), len(right)))
        ],
        prime,
    )


def fpmul(
    left: tuple[int, ...], right: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    if not left or not right:
        return ()
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return fptrim(result, prime)


def fpreduce(
    value: tuple[int, ...], modulus: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    return fpdivmod(value, modulus, prime)[1]


def fpinverse(
    value: tuple[int, ...], modulus: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    old_r, r = modulus, value
    old_s, s = (), (1,)
    while r:
        quotient, remainder = fpdivmod(old_r, r, prime)
        old_r, r = r, remainder
        old_s, s = s, fpadd(
            old_s,
            tuple(-coefficient for coefficient in fpmul(quotient, s, prime)),
            prime,
        )
    if len(old_r) != 1:
        raise ArithmeticError("nonunit in finite quotient")
    scale = pow(old_r[0], prime - 2, prime)
    return fpreduce(tuple(scale * coefficient for coefficient in old_s), modulus, prime)


def rank_finite_quotient(
    matrix: Sequence[Sequence[Poly]], factor: Poly, prime: int
) -> int:
    modulus = fptrim(factor, prime)
    work = [
        [fpreduce(tuple(value), modulus, prime) for value in row]
        for row in matrix
    ]
    rank = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = fpinverse(work[rank][column], modulus, prime)
        work[rank] = [
            fpreduce(fpmul(value, inverse, prime), modulus, prime)
            for value in work[rank]
        ]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                fpreduce(
                    fpadd(
                        left,
                        tuple(
                            -coefficient
                            for coefficient in fpmul(scale, right, prime)
                        ),
                        prime,
                    ),
                    modulus,
                    prime,
                )
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def invariant_polynomials() -> dict[str, Poly]:
    # A=-4t(t-1)^2; B=(t^2-t+1)(t^2-3t+1).
    a = pscale(pmul(T, pmul((-1, 1), (-1, 1))), -4)
    b = pmul((1, -1, 1), (1, -3, 1))
    z2 = primitive(psub(pmul(b, b), pscale(pmul(a, a), 2)))
    plus = primitive(padd(pscale(b, 3), pscale(a, 2)))
    minus = primitive(psub(pscale(b, 3), pscale(a, 2)))
    return {
        "A": a,
        "B": b,
        "z_equals_2": z2,
        "three_B_plus_two_A": plus,
        "three_B_minus_two_A": minus,
        "z_equals_4_over_9": primitive(
            psub(pscale(pmul(b, b), 9), pscale(pmul(a, a), 4))
        ),
    }


def compose6(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(PARTIES))


def inverse6(value: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(value.index(index) for index in range(PARTIES))


def element_order(value: tuple[int, ...]) -> int:
    identity = tuple(range(PARTIES))
    power = identity
    for order in range(1, 13):
        power = compose6(value, power)
        if power == identity:
            return order
    raise AssertionError("permutation order exceeds 12")


def subgroup_summary(group: set[tuple[int, ...]]) -> dict[str, object]:
    unseen = set(range(PARTIES))
    orbits = []
    while unseen:
        point = min(unseen)
        orbit = sorted({value[point] for value in group})
        orbits.append(orbit)
        unseen -= set(orbit)
    return {
        "order": len(group),
        "element_order_histogram": dict(
            sorted(Counter(element_order(value) for value in group).items())
        ),
        "point_orbits": orbits,
    }


def support_double_coset(
    support: set[tuple[int, ...]], symmetric6: Sequence[tuple[int, ...]]
) -> dict[str, object]:
    left = {
        value
        for value in symmetric6
        if {compose6(value, member) for member in support} == support
    }
    right = {
        value
        for value in symmetric6
        if {compose6(member, value) for member in support} == support
    }
    representative = min(support)
    represented = {
        compose6(compose6(left_value, representative), right_value)
        for left_value in left
        for right_value in right
    }
    if represented != support:
        raise AssertionError("rank-drop support is not the claimed single double coset")
    conjugated_right = {
        compose6(compose6(representative, value), inverse6(representative))
        for value in right
    }
    seam = left & conjugated_right
    return {
        "representative": list(representative),
        "left": subgroup_summary(left),
        "right": subgroup_summary(right),
        "seam": subgroup_summary(seam),
        "size_from_orders": len(left) * len(right) // len(seam),
    }


def det_integer(matrix: Sequence[Sequence[int]]) -> int:
    work = [list(row) for row in matrix]
    sign = 1
    previous = 1
    for column in range(len(work) - 1):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]), None
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        pivot_value = work[column][column]
        for row in range(column + 1, len(work)):
            for target in range(column + 1, len(work)):
                work[row][target] = (
                    work[row][target] * pivot_value
                    - work[row][column] * work[column][target]
                ) // previous
            work[row][column] = 0
        previous = pivot_value
    return sign * work[-1][-1]


def resultant(left: Poly, right: Poly) -> int:
    left_descending = list(reversed(left))
    right_descending = list(reversed(right))
    left_degree = len(left) - 1
    right_degree = len(right) - 1
    matrix = []
    for shift in range(right_degree):
        matrix.append(
            [0] * shift
            + left_descending
            + [0] * (right_degree - 1 - shift)
        )
    for shift in range(left_degree):
        matrix.append(
            [0] * shift
            + right_descending
            + [0] * (left_degree - 1 - shift)
        )
    return det_integer(matrix)


def prime_factorization(value: int) -> dict[str, int]:
    remaining = abs(value)
    factors: dict[str, int] = {}
    divisor = 2
    while divisor * divisor <= remaining:
        while remaining % divisor == 0:
            key = str(divisor)
            factors[key] = factors.get(key, 0) + 1
            remaining //= divisor
        divisor += 1
    if remaining > 1:
        factors[str(remaining)] = factors.get(str(remaining), 0) + 1
    return factors


def exceptional_arithmetic(invariants: dict[str, Poly]) -> dict[str, object]:
    divisors = {
        "z=2": invariants["z_equals_2"],
        "3B+2A=0": invariants["three_B_plus_two_A"],
        "3B-2A=0": invariants["three_B_minus_two_A"],
    }
    boundary = {
        "t": T,
        "t-1": (-1, 1),
        "B": invariants["B"],
        "GRS": (1, -4, 7, -4, 1),
    }
    discriminants = {}
    boundary_resultants = {}
    for name, divisor in divisors.items():
        derivative = trim(
            (index + 1) * divisor[index + 1]
            for index in range(len(divisor) - 1)
        )
        discriminants[name] = prime_factorization(resultant(divisor, derivative))
        boundary_resultants[name] = {
            boundary_name: prime_factorization(resultant(divisor, factor))
            for boundary_name, factor in boundary.items()
        }
    return {
        "derivative_resultant_prime_factors": discriminants,
        "boundary_resultant_prime_factors": boundary_resultants,
        "cross_resultant_prime_factors": {
            "z=2_vs_z=4/9": prime_factorization(
                resultant(
                    invariants["z_equals_2"],
                    invariants["z_equals_4_over_9"],
                )
            ),
            "signed_4/9_sheets": prime_factorization(
                resultant(
                    invariants["three_B_plus_two_A"],
                    invariants["three_B_minus_two_A"],
                )
            ),
        },
        "complete_exceptional_prime_support": [2, 3, 5, 7, 11, 13, 41],
    }


def finite_prime_replay(
    symmetric6: Sequence[tuple[int, ...]], invariants: dict[str, Poly]
) -> dict[str, object]:
    result = {}
    grs = (1, -4, 7, -4, 1)
    for prime in (7, 11, 13, 17, 19, 23, 29, 31):
        classes: Counter[str] = Counter()
        for point in range(2, prime):
            if peval_mod(invariants["B"], point, prime) == 0:
                continue
            if peval_mod(grs, point, prime) == 0:
                continue
            on_z2 = peval_mod(invariants["z_equals_2"], point, prime) == 0
            on_z49 = (
                peval_mod(invariants["z_equals_4_over_9"], point, prime) == 0
            )
            expected = 96 * int(on_z2) + 192 * int(on_z49)
            histogram = Counter(
                rank_numeric(
                    contraction_matrix(permuted_sigmas(party_permutation)),
                    point,
                    prime,
                )
                for party_permutation in symmetric6
            )
            target = Counter({21: 720 - expected})
            if expected:
                target[20] = expected
            if histogram != target:
                raise AssertionError(
                    f"finite replay mismatch q={prime}, t={point}: {histogram}, expected {target}"
                )
            label = (
                "merged"
                if on_z2 and on_z49
                else "z=2"
                if on_z2
                else "z=4/9"
                if on_z49
                else "generic"
            )
            classes[label] += 1
        result[str(prime)] = dict(sorted(classes.items()))
    return result


def analyze() -> dict[str, object]:
    invariants = invariant_polynomials()
    symmetric6 = list(itertools.permutations(range(PARTIES)))
    class_word = []
    quotient_factors = {
        "z2a": (1, -10, 19, -10, 1),
        "z2b": (1, 2, -5, 2, 1),
        "minus_a": (1, 1, 1),
        "minus_b": (3, -7, 3),
        "plus_a": (1, -5, 1),
        "plus_b": (3, -5, 3),
    }
    supports: dict[str, set[tuple[int, ...]]] = {
        name: set() for name in quotient_factors
    }
    rank_histograms: dict[str, Counter[int]] = {
        name: Counter() for name in quotient_factors
    }
    divisor_histogram: Counter[str] = Counter()
    witness_histogram: Counter[int] = Counter()
    determinant_count = 0
    total_candidate = pmul(
        invariants["z_equals_2"], invariants["z_equals_4_over_9"]
    )
    for party_permutation in symmetric6:
        matrix = contraction_matrix(permuted_sigmas(party_permutation))
        active = []
        for name, factor in quotient_factors.items():
            quotient_rank = rank_quotient(matrix, factor)
            rank_histograms[name][quotient_rank] += 1
            if quotient_rank == 20:
                active.append(name)
                supports[name].add(party_permutation)
            elif quotient_rank != 21:
                raise AssertionError(
                    f"quotient rank {quotient_rank} for {party_permutation}, {name}"
                )
        divisor, witnesses = maximal_minor_witness(matrix, total_candidate)
        determinant_count += len(witnesses)
        quotient, remainder = pdivmod_q(total_candidate, divisor)
        if remainder or any(value.denominator != 1 for value in quotient):
            raise AssertionError(
                f"maximal-minor witness for {party_permutation} has extra divisor {divisor}"
            )
        divisor_histogram[str(list(divisor))] += 1
        witness_histogram[len(witnesses)] += 1
        mask = sum(1 << index for index, name in enumerate(quotient_factors) if name in active)
        class_word.append(f"{mask:02x}")
    characteristic7 = {}
    for point in (2, 4, 6):
        characteristic7[str(point)] = dict(
            sorted(
                Counter(
                    rank_numeric(
                        contraction_matrix(permuted_sigmas(party_permutation)),
                        point,
                        7,
                    )
                    for party_permutation in symmetric6
                ).items()
            )
        )
    characteristic7["quadratic_components"] = {
        str(list(factor)): dict(
            sorted(
                Counter(
                    rank_finite_quotient(
                        contraction_matrix(permuted_sigmas(party_permutation)),
                        factor,
                        7,
                    )
                    for party_permutation in symmetric6
                ).items()
            )
        )
        for factor in ((1, 3, 1), (1, 0, 1))
    }
    return {
        "schema": "c548-rank-drop-v1",
        "conventions": {
            "party_permutations": "zero-based images",
            "copy_permutations": "zero-based images",
            "seed_sigma_tail": [list(value) for value in SEED_TAIL],
            "matrix": "24 equations by 21 variables after deleting bra-copy-zero coordinates",
            "polynomials": "little-endian primitive integer coefficient lists",
        },
        "invariants": {name: list(value) for name, value in invariants.items()},
        "component_rank_histograms": {
            name: dict(sorted(histogram.items()))
            for name, histogram in rank_histograms.items()
        },
        "maximal_minor_witness_divisor_histogram": dict(sorted(divisor_histogram.items())),
        "component_mask_word_in_lexicographic_S6_order": "".join(class_word),
        "maximal_minor_witness_count_histogram": dict(sorted(witness_histogram.items())),
        "maximal_minors_computed": determinant_count,
        "double_cosets": {
            name: support_double_coset(support, symmetric6)
            for name, support in supports.items()
        },
        "characteristic_7_admitted_points": characteristic7,
        "exceptional_arithmetic": exceptional_arithmetic(invariants),
        "independent_finite_prime_replay": finite_prime_replay(
            symmetric6, invariants
        ),
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--generate", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = analyze()
    encoded = canonical_bytes(payload)
    if args.generate:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT.name}: {len(encoded)} bytes sha256={hashlib.sha256(encoded).hexdigest()}")
        return
    if not OUTPUT.exists():
        raise SystemExit(f"missing certificate: {OUTPUT}")
    expected = OUTPUT.read_bytes()
    if expected != encoded:
        with tempfile.NamedTemporaryFile(prefix=f"{STEM}-", suffix=".json", delete=False) as handle:
            handle.write(encoded)
            actual_path = handle.name
        raise SystemExit(f"certificate mismatch; regenerated output at {actual_path}")
    print(f"checked {OUTPUT.name}: {len(encoded)} bytes sha256={hashlib.sha256(encoded).hexdigest()}")


if __name__ == "__main__":
    main()
