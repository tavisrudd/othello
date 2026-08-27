"""Relative-weight and coefficient-presentation design algorithms."""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from itertools import combinations, product
from typing import Sequence

from .finite import (
    Matrix,
    flatten,
    mat_mul,
    matrix_rank,
    row_space,
    shape,
    transpose,
    vector_weight,
)


def _restriction_rank(basis: Matrix, coordinates: Sequence[int], p: int) -> int:
    return matrix_rank(tuple(tuple(row[j] for j in coordinates) for row in basis), p)


def relative_profile(d_basis: Matrix, k_basis: Matrix, p: int) -> tuple[int, ...]:
    """Compute K_s(D,K) by exhaustive helper subsets and rank identities."""

    if not d_basis:
        raise ValueError("D needs a basis")
    length = len(d_basis[0])
    if any(len(row) != length for row in d_basis + k_basis):
        raise ValueError("basis width mismatch")
    d_dim = matrix_rank(d_basis, p)
    k_dim = matrix_rank(k_basis, p) if k_basis else 0
    if d_dim != len(d_basis) or k_dim != len(k_basis):
        raise ValueError("inputs must be row bases")
    profile = [0] * (length + 1)
    for mask in range(1 << length):
        helper = tuple(j for j in range(length) if mask >> j & 1)
        complement = tuple(j for j in range(length) if not (mask >> j & 1))
        d_supported = d_dim - _restriction_rank(d_basis, complement, p)
        k_supported = k_dim - (_restriction_rank(k_basis, complement, p) if k_basis else 0)
        value = d_supported - k_supported
        profile[len(helper)] = max(profile[len(helper)], value)
    return tuple(profile)


def relative_weights(d_basis: Matrix, k_basis: Matrix, p: int) -> tuple[int, ...]:
    profile = relative_profile(d_basis, k_basis, p)
    quotient_dim = matrix_rank(d_basis, p) - (matrix_rank(k_basis, p) if k_basis else 0)
    return tuple(next(s for s, value in enumerate(profile) if value >= t) for t in range(1, quotient_dim + 1))


def _supported_dimension(basis: Matrix, support: Sequence[int], p: int) -> int:
    length = len(basis[0])
    outside = tuple(j for j in range(length) if j not in support)
    return len(basis) - _restriction_rank(basis, outside, p)


def cooperative_helper_cost(c_dual_basis: Matrix, targets: Sequence[int], p: int) -> int:
    """Compute kappa_C(P) directly from supported-subcode dimensions."""

    if not c_dual_basis:
        return 10**18
    length = len(c_dual_basis[0])
    target_set = tuple(sorted(targets))
    e = len(target_set)
    remaining = tuple(j for j in range(length) if j not in target_set)
    for helper_count in range(len(remaining) + 1):
        for helpers in combinations(remaining, helper_count):
            combined = tuple(sorted(target_set + helpers))
            total_dim = _supported_dimension(c_dual_basis, combined, p)
            kernel_dim = _supported_dimension(c_dual_basis, helpers, p)
            if total_dim - kernel_dim == e:
                return helper_count
    return 10**18


def all_invertible_matrices(dimension: int, p: int):
    nonzero = tuple(
        vector
        for vector in product(range(p), repeat=dimension)
        if any(vector)
    )

    def extend(rows: tuple[tuple[int, ...], ...]):
        if len(rows) == dimension:
            yield rows
            return
        span = set(row_space(rows, p)) if rows else {(0,) * dimension}
        for vector in nonzero:
            if vector not in span:
                yield from extend(rows + (vector,))

    yield from extend(())


def _linear_combination(coefficients: Sequence[int], basis: Matrix, p: int) -> tuple[int, ...]:
    if not basis:
        return ()
    return tuple(
        sum(coefficients[i] * basis[i][j] for i in range(len(basis))) % p
        for j in range(len(basis[0]))
    )


def presentation_dual_distance(
    k_basis: Matrix, quotient_basis: Matrix, identification: Matrix, p: int
) -> int:
    """Minimum weight of the graph-code presentation of K <= D."""

    ell = len(quotient_basis)
    if shape(identification) != (ell, ell) or matrix_rank(identification, p) != ell:
        raise ValueError("identification must be invertible")
    best = 10**18
    for k_coeff in product(range(p), repeat=len(k_basis)):
        k_word = _linear_combination(k_coeff, k_basis, p) if k_basis else (0,) * len(quotient_basis[0])
        for q_coeff in product(range(p), repeat=ell):
            if not any(k_coeff) and not any(q_coeff):
                continue
            q_word = _linear_combination(q_coeff, quotient_basis, p)
            helper = tuple((x + y) % p for x, y in zip(k_word, q_word))
            target_column = tuple((x,) for x in q_coeff)
            target = tuple(row[0] for row in mat_mul(identification, target_column, p))
            best = min(best, vector_weight(target) + vector_weight(helper))
    return best


@dataclass(frozen=True)
class PresentationSpectrum:
    relative_weights: tuple[int, ...]
    distance_counts: tuple[tuple[int, int], ...]
    best_distance: int
    best_identifications: tuple[tuple[int, ...], ...]
    candidates: int


def coefficient_presentation_spectrum(
    k_basis: Matrix, quotient_basis: Matrix, p: int
) -> PresentationSpectrum:
    """Enumerate target identifications and optimize the additive threshold."""

    d_basis = k_basis + quotient_basis
    weights = relative_weights(d_basis, k_basis, p)
    distances: Counter[int] = Counter()
    best = -1
    best_ids: list[tuple[int, ...]] = []
    candidates = 0
    for identification in all_invertible_matrices(len(quotient_basis), p):
        candidates += 1
        distance = presentation_dual_distance(k_basis, quotient_basis, identification, p)
        distances[distance] += 1
        key = flatten(identification)
        if distance > best:
            best = distance
            best_ids = [key]
        elif distance == best:
            best_ids.append(key)
    return PresentationSpectrum(
        weights,
        tuple(sorted(distances.items())),
        best,
        tuple(sorted(best_ids)),
        candidates,
    )
