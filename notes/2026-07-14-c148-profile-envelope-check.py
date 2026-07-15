#!/usr/bin/env python3
"""Independent exact-arithmetic check for the C148 profile envelope.

The coefficient lists are for twice the profile lower bound, in ascending powers of ``s``.
For the ``s >= 10`` branch, substituting ``s=t+10`` into every difference ``2(L_f-L_8)``
produces a polynomial with nonnegative coefficients.  This is an all-integer certificate for every
``t >= 0``, not a bounded numerical scan.
"""

from math import comb


PROFILES = ((0, 4), (2, 3), (4, 2), (6, 1), (8, 0))

# Coefficients of 2*L_f(s), low degree first, for f = 0,2,4,6,8.
TWICE_BOUND = {
    0: (72, -21, -28, 0, 1),
    2: (72, 27, -26, -2, 1),
    4: (-20, 59, -16, -4, 1),
    6: (-108, 51, 2, -6, 1),
    8: (0, -21, 28, -8, 1),
}


def profile_bound(s: int, f: int, e: int) -> int:
    empty = s * s + s + 1 - (f * (s + 1) - comb(f, 2) + e)
    candidates = (s * s - s) // 2
    forbidden = f * e + e * (e - 1)
    return empty * (candidates - forbidden)


def poly_eval(coeffs: tuple[int, ...], x: int) -> int:
    return sum(c * x**i for i, c in enumerate(coeffs))


def poly_sub(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
    n = max(len(a), len(b))
    return tuple((a[i] if i < len(a) else 0) - (b[i] if i < len(b) else 0)
                 for i in range(n))


def poly_mul(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            out[i + j] += ai * bj
    return tuple(out)


def poly_add(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[int, ...]:
    n = max(len(a), len(b))
    return tuple((a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
                 for i in range(n))


def poly_shift(coeffs: tuple[int, ...], shift: int) -> tuple[int, ...]:
    """Coefficients of p(t+shift), low degree first."""
    result = (0,)
    power = (1,)
    for coefficient in coeffs:
        result = poly_add(result, tuple(coefficient * x for x in power))
        power = poly_mul(power, (shift, 1))
    return result


def poly_forward_difference(coeffs: tuple[int, ...]) -> tuple[int, ...]:
    """Coefficients of p(s+1)-p(s), low degree first."""
    return poly_sub(poly_shift(coeffs, 1), coeffs)


def main() -> None:
    # Cross-check the closed polynomials against the defining carrier/secant formula.
    for s in range(7, 1001):
        for f, e in PROFILES:
            twice = poly_eval(TWICE_BOUND[f], s)
            assert twice % 2 == 0
            assert twice // 2 == profile_bound(s, f, e)

    values7 = tuple(profile_bound(7, f, e) for f, e in PROFILES)
    assert values7 == (477, 351, 319, 345, 441)
    assert min(values7) - 1 == 318
    assert PROFILES[values7.index(min(values7))][0] == 4

    # The two finite boundary values in the piecewise lower envelope.
    values8 = tuple(profile_bound(8, f, e) for f, e in PROFILES)
    values9 = tuple(profile_bound(9, f, e) for f, e in PROFILES)
    assert values8 == (1104, 848, 738, 726, 812)
    assert values9 == (2088, 1656, 1430, 1350, 1404)
    assert PROFILES[values8.index(min(values8))][0] == 6
    assert PROFILES[values9.index(min(values9))][0] == 6

    # For s=t+10, every L_f-L_8 has a nonnegative-coefficient doubled polynomial.
    shifted_differences: dict[int, tuple[int, ...]] = {}
    for f in (0, 2, 4, 6):
        shifted = poly_shift(poly_sub(TWICE_BOUND[f], TWICE_BOUND[8]), 10)
        assert all(coefficient >= 0 for coefficient in shifted)
        shifted_differences[f] = shifted

    # Every profile bound is nondecreasing from s=7 onward.  Since all five values at s=7 are at
    # least 319, this separately certifies the uniform envelope lower bound 319 for all s>=7.
    shifted_increments: dict[int, tuple[int, ...]] = {}
    for f in (0, 2, 4, 6, 8):
        increment = poly_forward_difference(TWICE_BOUND[f])
        shifted = poly_shift(increment, 7)
        assert all(coefficient >= 0 for coefficient in shifted)
        shifted_increments[f] = shifted

    print(f"s=7 values={values7} alternate_min={min(values7) - 1}")
    print(f"s=8 values={values8}; s=9 values={values9}")
    print("envelope profiles: s=7 -> f=4; s=8,9 -> f=6; s>=10 -> f=8")
    for f, shifted in shifted_differences.items():
        print(f"2*(L_{f}-L_8) at s=t+10 coefficients={shifted}")
    for f, shifted in shifted_increments.items():
        print(f"2*(L_{f}(s+1)-L_{f}(s)) at s=t+7 coefficients={shifted}")


if __name__ == "__main__":
    main()
