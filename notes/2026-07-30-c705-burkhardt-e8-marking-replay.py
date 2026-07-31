#!/usr/bin/env python3
"""Independent finite-field replay for the C705 S6 marking certificate."""

from itertools import product
from math import comb, factorial


F = [
    295130390826722844,
    -62251283304984120046,
    -5519843141820561948,
    1960910801972693616,
    -445189061771697891,
    103910980411175652,
    39706983135965148,
]


def trim(poly):
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def remainder(dividend, divisor, prime):
    work = [value % prime for value in dividend]
    divisor = trim([value % prime for value in divisor])
    inverse = pow(divisor[-1], -1, prime)
    while len(work) >= len(divisor) and work != [0]:
        scalar = work[-1] * inverse % prime
        shift = len(work) - len(divisor)
        for i, value in enumerate(divisor):
            work[i + shift] = (work[i + shift] - scalar * value) % prime
        trim(work)
    return work


def no_factor_through(poly, prime, maximum_degree):
    for degree in range(1, maximum_degree + 1):
        for lower in product(range(prime), repeat=degree):
            if remainder(poly, list(lower) + [1], prime) == [0]:
                return False
    return True


def divide_linear(poly, root, prime):
    quotient = [0] * (len(poly) - 1)
    quotient[-1] = poly[-1] % prime
    for index in range(len(quotient) - 2, -1, -1):
        quotient[index] = (poly[index + 1] + root * quotient[index + 1]) % prime
    assert (poly[0] + root * quotient[0]) % prime == 0
    return quotient


def qreduce(poly, modulus, prime):
    return remainder(poly, modulus, prime) + [0] * (
        len(modulus) - 1 - len(remainder(poly, modulus, prime))
    )


def qmul(left, right, modulus, prime):
    result = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            result[i + j] = (result[i + j] + x * y) % prime
    return qreduce(result, modulus, prime)


def qpow(base, exponent, modulus, prime):
    result = [1]
    while exponent:
        if exponent & 1:
            result = qmul(result, base, modulus, prime)
        base = qmul(base, base, modulus, prime)
        exponent //= 2
    return qreduce(result, modulus, prime)


def qscale(poly, scalar, modulus, prime):
    return qreduce([scalar * value % prime for value in poly], modulus, prime)


def qadd(left, right, modulus, prime):
    size = max(len(left), len(right))
    return qreduce(
        [
            ((left[i] if i < len(left) else 0) + (right[i] if i < len(right) else 0))
            % prime
            for i in range(size)
        ],
        modulus,
        prime,
    )


assert no_factor_through(F, 17, 3)

mod7 = divide_linear(F, 3, 7)
assert mod7 == [2, 3, 4, 5, 3, 3]
assert no_factor_through(mod7, 7, 2)

mod1303 = F
for root in (5, 338, 778, 1262):
    mod1303 = divide_linear(mod1303, root, 1303)
assert mod1303 == [1044, 1279, 166]
discriminant = (1279**2 - 4 * 1044 * 166) % 1303
assert pow(discriminant, (1303 - 1) // 2, 1303) == 1302

# Independently replay the root-to-infinity normal form over F_17[r]/(f).
p = 17
modulus = [value % p for value in F]
r = [0, 1]
derivatives = {}
work = modulus
for order in range(1, 7):
    work = [i * work[i] % p for i in range(1, len(work))]
    derivatives[order] = qreduce(work, modulus, p)
d = derivatives[1]
weights = {}
for order, weight, sign in (
    (2, 6, -1),
    (3, 12, 1),
    (4, 18, -1),
    (5, 24, 1),
    (6, 30, -1),
):
    term = qmul(qpow(d, order - 2, modulus, p), derivatives[order], modulus, p)
    weights[weight] = qscale(
        term, sign * pow(factorial(order), -1, p), modulus, p
    )

numerator = [[0] * 6 for _ in range(7)]
minus_d = qscale(d, -1, modulus, p)
for index, coefficient in enumerate(modulus):
    for chosen in range(index + 1):
        term = qmul(
            qpow(r, index - chosen, modulus, p),
            qpow(minus_d, chosen, modulus, p),
            modulus,
            p,
        )
        term = qscale(term, coefficient * comb(index, chosen), modulus, p)
        numerator[6 - chosen] = qadd(
            numerator[6 - chosen], term, modulus, p
        )
d2 = qpow(d, 2, modulus, p)
assert numerator[6] == [0] * 6
assert numerator[5] == qscale(d2, -1, modulus, p)
for degree, weight in ((4, 6), (3, 12), (2, 18), (1, 24), (0, 30)):
    assert numerator[degree] == qscale(
        qmul(d2, weights[weight], modulus, p), -1, modulus, p
    )

print("C705 independent replay: S6 patterns and marked E8 normal form")
