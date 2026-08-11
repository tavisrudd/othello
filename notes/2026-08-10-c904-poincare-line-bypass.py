#!/usr/bin/env python3
"""Exact exterior-algebra normalization for the failed C904 Poincare bypass."""

from math import factorial


def wedge(left, right):
    result = {}
    for mask_left, value_left in left.items():
        for mask_right, value_right in right.items():
            if mask_left & mask_right:
                continue
            inversions = 0
            bits = mask_left
            while bits:
                lowest = bits & -bits
                index = lowest.bit_length() - 1
                inversions += (mask_right & (lowest - 1)).bit_count()
                bits ^= lowest
            mask = mask_left | mask_right
            sign = -1 if inversions % 2 else 1
            result[mask] = result.get(mask, 0) + sign * value_left * value_right
            if result[mask] == 0:
                del result[mask]
    return result


def add(*forms):
    result = {}
    for form in forms:
        for mask, value in form.items():
            result[mask] = result.get(mask, 0) + value
            if result[mask] == 0:
                del result[mask]
    return result


def monomial(*indices):
    result = {0: 1}
    for index in indices:
        result = wedge(result, {1 << index: 1})
    return result


def divided_power(form, exponent):
    result = {0: 1}
    for _ in range(exponent):
        result = wedge(result, form)
    divisor = factorial(exponent)
    assert all(value % divisor == 0 for value in result.values())
    return {mask: value // divisor for mask, value in result.items()}


def main():
    # On each factor use (e_i,f_i), i=0,...,4.  The second factor starts at 10.
    theta_first = add(*(monomial(2 * i, 2 * i + 1) for i in range(5)))
    theta_second = add(*(monomial(10 + 2 * i, 10 + 2 * i + 1)
                         for i in range(5)))
    # m^*theta-theta_1-theta_2 = sum(e_i F_i-f_i E_i).
    poincare = add(*(
        add(monomial(2 * i, 10 + 2 * i + 1),
            {mask: -value for mask, value in
             monomial(2 * i + 1, 10 + 2 * i).items()})
        for i in range(5)
    ))

    alpha_first = monomial(0)
    beta_second = monomial(11)
    integrand = {0: 1}
    for factor in (
        alpha_first,
        beta_second,
        divided_power(theta_first, 3),
        divided_power(theta_second, 3),
        divided_power(poincare, 3),
    ):
        integrand = wedge(integrand, factor)

    top_mask = (1 << 20) - 1
    scalar = integrand.get(top_mask, 0)

    principal = wedge(
        monomial(0, 1),
        divided_power(theta_first, 4),
    ).get((1 << 10) - 1, 0)

    print("C904 Poincare-line normalization")
    print(f"principal pairing <e0,f0>={principal}")
    print(f"Fano-kernel pairing scalar={scalar}")
    assert principal == 1
    assert scalar == 4
    print("PASS: bypass has multiplier four, not one")


if __name__ == "__main__":
    main()
