#!/usr/bin/env python3
"""Independent finite-algebra replay for the C682 prime-23 separator."""

from __future__ import annotations


P = 23


def add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return ((left[0] + right[0]) % P, (left[1] + right[1]) % P)


def mul(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    # Pairs represent a+b*w with w^2=-3.  This intentionally does not use
    # the sqrt(5) presentation of the primary certificate.
    return (
        (left[0] * right[0] - 3 * left[1] * right[1]) % P,
        (left[0] * right[1] + left[1] * right[0]) % P,
    )


def power(value: tuple[int, int], exponent: int) -> tuple[int, int]:
    result = (1, 0)
    while exponent:
        if exponent & 1:
            result = mul(result, value)
        value = mul(value, value)
        exponent //= 2
    return result


def main() -> None:
    elements = [(a, b) for a in range(P) for b in range(P)]
    zero = (0, 0)
    one = (1, 0)
    w = (0, 1)

    assert all((x * x + 3) % P != 0 for x in range(P))
    assert mul(w, w) == (P - 3, 0)
    assert power(w, P) == (0, P - 1)
    assert all(
        value == zero or mul(value, power(value, P * P - 2)) == one
        for value in elements
    )

    # The coarse scalar-image special fibre is the dual-number algebra.
    dual_elements = [(a, b) for a in range(P) for b in range(P)]

    def dual_mul(
        left: tuple[int, int], right: tuple[int, int]
    ) -> tuple[int, int]:
        return (
            left[0] * right[0] % P,
            (left[0] * right[1] + left[1] * right[0]) % P,
        )

    nilpotents = [
        value for value in dual_elements if dual_mul(value, value) == zero
    ]
    units = [value for value in dual_elements if value[0] != 0]
    assert len(nilpotents) == P
    assert len(units) == P * (P - 1)
    assert add(w, power(w, P)) == zero

    print(
        "PASS: F_529 is inert etale with Frobenius-odd separator; "
        "the coarse scalar fibre has a 23-element nilpotent ideal"
    )


if __name__ == "__main__":
    main()
