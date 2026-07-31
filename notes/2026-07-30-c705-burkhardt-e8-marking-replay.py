#!/usr/bin/env python3
"""Independent finite-field replay for the C705 S6 marking certificate."""

from itertools import product


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

print("C705 independent replay: [6], [1,5], [1,1,1,1,2]")
