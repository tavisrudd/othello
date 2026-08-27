#!/usr/bin/env python3
"""Bounded falsification checks for the C973 digit-stripping sequences."""

from math import comb, prod


PRIMES: tuple[int, ...] = (2, 3, 5, 7, 11, 13)
MAX_LOWER_ROW = 24


def coefficient(row: int, index: int, prime: int) -> int:
    if not 0 <= index <= row:
        return 0
    return comb(row, index) % prime


def nucleus_support(row: int, prime: int) -> set[int]:
    return {index for index in range(row + 1) if coefficient(row, index, prime) == 0}


def carrier_support(row: int, prime: int) -> set[int]:
    return {
        index
        for index in range(row + 2)
        if coefficient(row, index, prime) == 0
        and coefficient(row, index - 1, prime) == 0
    }


def digit_statistics(row: int, prime: int) -> tuple[int, int]:
    digits = []
    remaining = row
    while remaining:
        digits.append(remaining % prime)
        remaining //= prime
    if not digits:
        digits = [0]
    nonzero_count = 1
    for digit in digits:
        nonzero_count *= digit + 1
    first_gap = next(
        (index for index, digit in enumerate(digits) if digit < prime - 1),
        None,
    )
    run_count = (
        1
        if first_gap is None
        else prod(digit + 1 for digit in digits[first_gap + 1 :])
    )
    return nonzero_count, run_count


def assert_translation_stable(
    support: set[int], degree: int, prime: int
) -> None:
    for source in support:
        for target in range(source, degree + 1):
            if comb(target, source) % prime:
                assert target in support, (prime, degree, source, target)


def check_nucleus(prime: int, lower_row: int, digit: int) -> None:
    row = prime * lower_row + digit
    lower_nucleus = nucleus_support(lower_row, prime)
    submodule = {
        prime * high + low
        for high in range(lower_row)
        for low in range(digit + 1, prime)
    }
    quotient = {
        prime * high + low
        for high in lower_nucleus
        for low in range(digit + 1)
    }
    actual = nucleus_support(row, prime)
    assert submodule.isdisjoint(quotient)
    assert actual == submodule | quotient
    assert_translation_stable(submodule, row, prime)


def check_carrier(prime: int, lower_row: int, digit: int) -> None:
    row = prime * lower_row + digit
    degree = row + 1
    lower_nucleus = nucleus_support(lower_row, prime)
    if digit <= prime - 2:
        submodule = {
            prime * high + low
            for high in range(lower_row)
            for low in range(digit + 2, prime)
        }
        quotient = {
            prime * high + low
            for high in lower_nucleus
            for low in range(digit + 2)
        }
    else:
        submodule = {
            prime * high + low
            for high in lower_nucleus
            for low in range(1, prime)
        }
        quotient = {
            prime * high for high in carrier_support(lower_row, prime)
        }
    actual = carrier_support(row, prime)
    nonzero_count, run_count = digit_statistics(row, prime)
    assert len(actual) == row + 2 - nonzero_count - run_count
    assert submodule.isdisjoint(quotient)
    assert actual == submodule | quotient
    assert_translation_stable(submodule, degree, prime)


def check_rescaling(prime: int, shift: int, module_degree: int) -> None:
    for source in range(module_degree + 1):
        source_scale = comb(shift + source, source) % prime
        assert source_scale
        expected_scale = ((-1) ** source * comb(module_degree, source)) % prime
        assert source_scale == expected_scale
        for target in range(source, module_degree + 1):
            target_scale = comb(shift + target, target) % prime
            transported = (
                source_scale
                * comb(shift + target, shift + source)
                * pow(target_scale, -1, prime)
            ) % prime
            assert transported == comb(target, source) % prime


def main() -> None:
    for prime in PRIMES:
        for lower_row in range(1, MAX_LOWER_ROW + 1):
            for digit in range(prime):
                check_nucleus(prime, lower_row, digit)
                check_carrier(prime, lower_row, digit)
                nucleus_degree = prime - digit - 2
                if nucleus_degree >= 0:
                    check_rescaling(prime, digit + 1, nucleus_degree)
                carrier_degree = prime - digit - 3
                if carrier_degree >= 0:
                    check_rescaling(prime, digit + 2, carrier_degree)
    print(
        "digit-stripping checks: PASS "
        f"(primes={PRIMES}, lower rows=1..{MAX_LOWER_ROW})"
    )


if __name__ == "__main__":
    main()
