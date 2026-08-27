#!/usr/bin/env python3
"""Bounded exact replay for the C973 family minimum-support formulas."""

from __future__ import annotations

from collections.abc import Iterable
from dataclasses import dataclass
from enum import Enum
from itertools import combinations
from math import comb, gcd


P = 11
REDUNDANCY = 6
M = REDUNDANCY - 1


@dataclass(frozen=True)
class Finite:
    value: int


class Infinity(Enum):
    POINT = "infinity"


Root = Finite | Infinity


@dataclass(frozen=True)
class Fp2:
    """Element a+b*x of F_11[x]/(x^2+1)."""

    a: int
    b: int

    def __add__(self, other: Fp2) -> Fp2:
        return Fp2((self.a + other.a) % P, (self.b + other.b) % P)

    def __neg__(self) -> Fp2:
        return Fp2(-self.a % P, -self.b % P)

    def __sub__(self, other: Fp2) -> Fp2:
        return self + (-other)

    def __mul__(self, other: Fp2) -> Fp2:
        return Fp2(
            (self.a * other.a - self.b * other.b) % P,
            (self.a * other.b + self.b * other.a) % P,
        )

    def __pow__(self, exponent: int) -> Fp2:
        result = Fp2(1, 0)
        base = self
        while exponent:
            if exponent & 1:
                result = result * base
            base = base * base
            exponent >>= 1
        return result

    def inverse(self) -> Fp2:
        assert self != Fp2(0, 0)
        return self ** (P * P - 2)

    def frobenius(self) -> Fp2:
        return self**P


def nrc(root: Root) -> list[int]:
    if root is Infinity.POINT:
        return [0] * M + [1]
    assert isinstance(root, Finite)
    return [pow(root.value, degree, P) for degree in range(REDUNDANCY)]


def rank_mod_p(columns: list[list[int]]) -> int:
    if not columns:
        return 0
    matrix = [list(row) for row in zip(*columns, strict=True)]
    rows = len(matrix)
    cols = len(matrix[0])
    pivot_row = 0
    for col in range(cols):
        pivot = next((row for row in range(pivot_row, rows) if matrix[row][col] % P), None)
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = pow(matrix[pivot_row][col], P - 2, P)
        matrix[pivot_row] = [(scale * value) % P for value in matrix[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            factor = matrix[row][col]
            matrix[row] = [
                (left - factor * right) % P
                for left, right in zip(matrix[row], matrix[pivot_row], strict=True)
            ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def spans(support: tuple[Root, ...], syndrome: list[int]) -> bool:
    columns = [nrc(root) for root in support]
    return rank_mod_p(columns) == rank_mod_p(columns + [syndrome])


def fp2_from_root(root: Root, alpha: Fp2, alpha_q: Fp2) -> Fp2:
    if root is Infinity.POINT:
        return Fp2(1, 0)
    assert isinstance(root, Finite)
    t = Fp2(root.value, 0)
    return (t - alpha) * (t - alpha_q).inverse()


def main() -> None:
    finite = tuple(Finite(value) for value in range(P))

    tangent_parameter = 3
    tangent = [0] * REDUNDANCY
    tangent[M - 1] = 1
    tangent[M] = tangent_parameter
    tangent_supports = tuple(combinations(finite, M))
    tangent_span = sum(spans(support, tangent) for support in tangent_supports)
    tangent_sum = sum(
        sum(root.value for root in support) % P == tangent_parameter
        for support in tangent_supports
    )
    assert tangent_span == tangent_sum == comb(P, M) // P == 42

    nonzero = tuple(Finite(value) for value in range(1, P))
    split_supports = tuple(combinations(nonzero, M))
    split_counts: dict[int, int] = {}
    for kappa in range(1, P):
        split = [0] * REDUNDANCY
        split[0] = 1
        split[M] = kappa
        target = kappa if M % 2 else -kappa % P
        span_count = sum(spans(support, split) for support in split_supports)
        product_count = sum(
            product_mod_p(root.value for root in support) == target
            for support in split_supports
        )
        assert span_count == product_count
        split_counts[target] = span_count
    assert {target for target, count in split_counts.items() if count == 26} == {1, P - 1}
    assert all(count in {25, 26} for count in split_counts.values())

    alpha = Fp2(0, 1)
    alpha_q = alpha.frobenius()
    conjugate: list[int] = []
    for degree in range(REDUNDANCY):
        trace = alpha**degree + alpha_q**degree
        assert trace.b == 0
        conjugate.append(trace.a)
    tau = Fp2(-1 % P, 0)
    projective = finite + (Infinity.POINT,)
    conjugate_counts: dict[str, int] = {}
    for name, universe in (("projective", projective), ("affine", finite)):
        supports = tuple(combinations(universe, M))
        span_count = sum(spans(support, conjugate) for support in supports)
        torus_count = sum(
            product_fp2(fp2_from_root(root, alpha, alpha_q) for root in support) == tau
            for support in supports
        )
        assert span_count == torus_count
        conjugate_counts[name] = span_count
    assert conjugate_counts == {"projective": 66, "affine": 38}

    print(f"tangent={tangent_span}")
    print(f"split={split_counts}")
    print(f"conjugate={conjugate_counts}")
    print("C973 family minimum-support replay: PASS")


def product_mod_p(values: Iterable[int]) -> int:
    product = 1
    for value in values:
        product = product * value % P
    return product


def product_fp2(values: Iterable[Fp2]) -> Fp2:
    product = Fp2(1, 0)
    for value in values:
        product = product * value
    return product


def divisors(value: int) -> list[int]:
    return [divisor for divisor in range(1, value + 1) if value % divisor == 0]


def mobius(value: int) -> int:
    remaining = value
    factors = 0
    prime = 2
    while prime * prime <= remaining:
        if remaining % prime == 0:
            remaining //= prime
            factors += 1
            if remaining % prime == 0:
                return 0
            while remaining % prime == 0:
                remaining //= prime
        prime += 1
    if remaining > 1:
        factors += 1
    return -1 if factors % 2 else 1


def ramanujan(order: int, exponent: int) -> int:
    return sum(
        divisor * mobius(order // divisor)
        for divisor in divisors(gcd(order, exponent))
    )


def cyclic_full(order: int, size: int, exponent: int) -> int:
    numerator = sum(
        (-1) ** ((divisor + 1) * (size // divisor))
        * comb(order // divisor, size // divisor)
        * ramanujan(divisor, exponent)
        for divisor in divisors(gcd(order, size))
    )
    assert numerator % order == 0
    return numerator // order


def cyclic_punctured(order: int, size: int, exponent: int) -> int:
    numerator = sum(
        (-1) ** (size + size // divisor)
        * comb(order // divisor - 1, size // divisor)
        * ramanujan(divisor, exponent)
        for divisor in divisors(order)
    )
    assert numerator % order == 0
    return numerator // order


def check_cyclic_formulas() -> None:
    for order in range(3, 16):
        for size in range(1, order):
            for exponent in range(order):
                full = sum(
                    sum(subset) % order == exponent
                    for subset in combinations(range(order), size)
                )
                punctured = sum(
                    sum(subset) % order == exponent
                    for subset in combinations(range(1, order), size)
                )
                assert full == cyclic_full(order, size, exponent)
                assert punctured == cyclic_punctured(order, size, exponent)
    print("cyclic full/punctured formulas: PASS (3 <= order <= 15)")


if __name__ == "__main__":
    check_cyclic_formulas()
    main()
