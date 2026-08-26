"""Exact projective-simplex thresholds and reliability polynomials."""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations, product
from math import comb
from typing import Mapping

from .finite import binary_rank_masks, gaussian_binomial, matrix_rank


def projective_size(dimension: int, q: int) -> int:
    return (q**dimension - 1) // (q - 1)


def projective_threshold(q: int, m: int, t: int) -> int:
    if not 1 <= t <= m:
        raise ValueError("t must lie between one and m")
    return (q**m - q ** (m - t)) // (q - 1)


def maximum_recoverable_rank(q: int, m: int, helper_budget: int) -> int:
    """Invert the projective threshold staircase exactly."""

    if helper_budget < 0:
        return 0
    residual = q**m - (q - 1) * helper_budget
    if residual <= 1:
        return m
    if residual > q**m:
        return 0
    if q == 2:
        exponent = (residual - 1).bit_length()
    else:
        low, high = 0, m
        while low < high:
            middle = (low + high) // 2
            if q**middle >= residual:
                high = middle
            else:
                low = middle + 1
        exponent = low
    return m - exponent


def projective_reliability_polynomial(q: int, m: int, t: int) -> dict[int, int]:
    """Return coefficients of R_t(s) using subspace-lattice inversion."""

    if not 1 <= t <= m:
        raise ValueError("t must lie between one and m")
    return all_rank_reliability_polynomials(q, m)[t - 1]


def projective_points(q: int, m: int) -> tuple[tuple[int, ...], ...]:
    points: set[tuple[int, ...]] = set()
    for vector in product(range(q), repeat=m):
        if not any(vector):
            continue
        first = next(x for x in vector if x)
        inverse = pow(first, -1, q)
        normalized = tuple(x * inverse % q for x in vector)
        points.add(normalized)
    return tuple(sorted(points))


def projective_reliability_direct(q: int, m: int, t: int) -> dict[int, int]:
    """Independent subset enumeration, expanded into the power basis."""

    points = projective_points(q, m)
    total = len(points)
    coefficients: dict[int, int] = {}
    for failed_count in range(total + 1):
        for failed_indices in combinations(range(total), failed_count):
            failed = tuple(points[i] for i in failed_indices)
            if q == 2:
                packed = (
                    sum(bit << coordinate for coordinate, bit in enumerate(point))
                    for point in failed
                )
                failed_rank = binary_rank_masks(packed)
            else:
                failed_rank = matrix_rank(failed, q)
            if failed_rank > m - t:
                continue
            base_degree = total - failed_count
            for j in range(failed_count + 1):
                degree = base_degree + j
                coefficient = (-1) ** j * comb(failed_count, j)
                coefficients[degree] = coefficients.get(degree, 0) + coefficient
    return {degree: coefficient for degree, coefficient in sorted(coefficients.items()) if coefficient}


def evaluate_polynomial(coefficients: Mapping[int, int], value: Fraction) -> Fraction:
    return sum(Fraction(coefficient) * value**degree for degree, coefficient in coefficients.items())


def all_rank_reliability_polynomials(q: int, m: int) -> tuple[dict[int, int], ...]:
    """Compute every R_t from one O(m^2)-summand span-rank pass."""

    gaussian = [[1]]
    for n in range(1, m + 1):
        previous = gaussian[-1]
        row = [1] * (n + 1)
        for k in range(1, n):
            row[k] = previous[k - 1] + q**k * previous[k]
        gaussian.append(row)
    projective_sizes = [0]
    for _ in range(m):
        projective_sizes.append(q * projective_sizes[-1] + 1)
    mobius = [1]
    for difference in range(m):
        mobius.append(-mobius[-1] * q**difference)

    total = projective_sizes[m]
    exact_span: list[dict[int, int]] = []
    for u in range(m):
        coefficients: dict[int, int] = {}
        outer = gaussian[m][u]
        for v in range(u + 1):
            exponent = total - projective_sizes[v]
            coefficient = (
                outer
                * gaussian[u][v]
                * mobius[u - v]
            )
            coefficients[exponent] = coefficients.get(exponent, 0) + coefficient
        exact_span.append(coefficients)
    prefixes: list[dict[int, int]] = []
    running: dict[int, int] = {}
    for coefficients in exact_span:
        for degree, coefficient in coefficients.items():
            running[degree] = running.get(degree, 0) + coefficient
        prefixes.append(
            {degree: coefficient for degree, coefficient in sorted(running.items()) if coefficient}
        )
    return tuple(prefixes[m - t] for t in range(1, m + 1))
