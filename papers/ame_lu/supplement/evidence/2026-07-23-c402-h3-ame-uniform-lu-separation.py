#!/usr/bin/env python3
"""Exact certificate for C402's uniform H3/GRS AME separation theorem."""

from __future__ import annotations

import argparse
import collections
import itertools
import json
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path
from typing import Iterable, Sequence, TypeVar

N = 6
Q = 19
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-23-c402-h3-ame-uniform-lu-separation.json"
T = TypeVar("T")


@dataclass(frozen=True, order=True)
class Golden:
    """Element a+b*tau of Q(tau), with tau^2=tau+1."""

    a: Fraction
    b: Fraction = Fraction(0)

    @staticmethod
    def make(a: int | Fraction, b: int | Fraction = 0) -> "Golden":
        return Golden(Fraction(a), Fraction(b))

    def __add__(self, other: object) -> "Golden":
        rhs = other if isinstance(other, Golden) else Golden.make(other)  # type: ignore[arg-type]
        return Golden(self.a + rhs.a, self.b + rhs.b)

    def __sub__(self, other: object) -> "Golden":
        rhs = other if isinstance(other, Golden) else Golden.make(other)  # type: ignore[arg-type]
        return Golden(self.a - rhs.a, self.b - rhs.b)

    def __neg__(self) -> "Golden":
        return Golden(-self.a, -self.b)

    def __mul__(self, other: object) -> "Golden":
        rhs = other if isinstance(other, Golden) else Golden.make(other)  # type: ignore[arg-type]
        return Golden(
            self.a * rhs.a + self.b * rhs.b,
            self.a * rhs.b + self.b * rhs.a + self.b * rhs.b,
        )

    def conjugate(self) -> "Golden":
        return Golden(self.a + self.b, -self.b)

    def norm(self) -> Fraction:
        return self.a * self.a + self.a * self.b - self.b * self.b

    def inverse(self) -> "Golden":
        if self == GOLDEN_ZERO:
            raise ZeroDivisionError("zero has no inverse")
        conjugate = self.conjugate()
        norm = self.norm()
        return Golden(conjugate.a / norm, conjugate.b / norm)

    def __truediv__(self, other: object) -> "Golden":
        rhs = other if isinstance(other, Golden) else Golden.make(other)  # type: ignore[arg-type]
        return self * rhs.inverse()

    def display(self) -> str:
        if self.b == 0:
            return str(self.a)
        return f"{self.a}+({self.b})*tau"


GOLDEN_ZERO = Golden.make(0)
GOLDEN_ONE = Golden.make(1)
TAU = Golden.make(0, 1)


def rref_generic(
    rows: Iterable[Sequence[T]], zero: T, one: T, inv
) -> tuple[tuple[tuple[T, ...], ...], tuple[int, ...]]:
    matrix = [list(row) for row in rows]
    if not matrix:
        return (), ()
    width = len(matrix[0])
    pivot_row = 0
    pivots: list[int] = []
    for column in range(width):
        pivot = next(
            (index for index in range(pivot_row, len(matrix)) if matrix[index][column] != zero),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = inv(matrix[pivot_row][column])
        matrix[pivot_row] = [scale * value for value in matrix[pivot_row]]  # type: ignore[operator]
        for index in range(len(matrix)):
            if index == pivot_row:
                continue
            coefficient = matrix[index][column]
            if coefficient != zero:
                matrix[index] = [
                    value - coefficient * pivot_value  # type: ignore[operator]
                    for value, pivot_value in zip(matrix[index], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    nonzero = tuple(tuple(row) for row in matrix if any(value != zero for value in row))
    return nonzero, tuple(pivots)


def nullspace_generic(
    rows: Sequence[Sequence[T]], width: int, zero: T, one: T, inv
) -> tuple[tuple[T, ...], ...]:
    reduced, pivots = rref_generic(rows, zero, one, inv)
    free = [column for column in range(width) if column not in pivots]
    result: list[tuple[T, ...]] = []
    for column in free:
        vector = [zero] * width
        vector[column] = one
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column]  # type: ignore[operator]
        result.append(tuple(vector))
    return tuple(result)


def cross(a: Sequence[T], b: Sequence[T]) -> tuple[T, T, T]:
    return (
        a[1] * b[2] - a[2] * b[1],  # type: ignore[operator]
        a[2] * b[0] - a[0] * b[2],  # type: ignore[operator]
        a[0] * b[1] - a[1] * b[0],  # type: ignore[operator]
    )


def det3(rows: Sequence[Sequence[T]]) -> T:
    a, b, c = rows
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])  # type: ignore[operator]
        - a[1] * (b[0] * c[2] - b[2] * c[0])  # type: ignore[operator]
        + a[2] * (b[0] * c[1] - b[1] * c[0])  # type: ignore[operator]
    )


def perfect_matchings(vertices: tuple[int, ...]) -> Iterable[tuple[tuple[int, int], ...]]:
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for matching in perfect_matchings(rest):
            yield ((first, second),) + matching


MATCHINGS = tuple(perfect_matchings(tuple(range(N))))


def matching_name(matching: Sequence[tuple[int, int]]) -> str:
    return "|".join(f"{a}{b}" for a, b in matching)


def transformed_matching_name(
    matching: Sequence[tuple[int, int]], permutation: Sequence[int]
) -> str:
    transformed = tuple(
        sorted(
            (min(permutation[a], permutation[b]), max(permutation[a], permutation[b]))
            for a, b in matching
        )
    )
    return matching_name(transformed)


def permutation_even(permutation: Sequence[int]) -> bool:
    inversions = sum(
        permutation[left] > permutation[right]
        for left in range(N)
        for right in range(left + 1, N)
    )
    return inversions % 2 == 0


def matching_concurrent(points: Sequence[Sequence[T]], matching, zero: T) -> bool:
    return det3(tuple(cross(points[a], points[b]) for a, b in matching)) == zero


def h3_golden_certificate() -> dict[str, object]:
    z, o, t = GOLDEN_ZERO, GOLDEN_ONE, TAU
    points = (
        (z, o, o - t),
        (z, o, t - o),
        (o, o - t, z),
        (o, t - o, z),
        (o, z, -t),
        (o, z, t),
    )
    parity_check = tuple(tuple(points[column][row] for column in range(N)) for row in range(3))
    code = nullspace_generic(parity_check, N, z, o, lambda value: value.inverse())
    if any(value.a.denominator != 1 or value.b.denominator != 1 for row in code for value in row):
        raise AssertionError("the chosen Gale basis must be integral over Z[tau]")
    gale_points = tuple(tuple(code[row][column] for row in range(3)) for column in range(N))
    primal = tuple(
        matching_name(matching)
        for matching in MATCHINGS
        if matching_concurrent(points, matching, z)
    )
    gale = tuple(
        matching_name(matching)
        for matching in MATCHINGS
        if matching_concurrent(gale_points, matching, z)
    )
    if primal != gale or len(primal) != 10:
        raise AssertionError("H3 and its Gale dual must share exactly ten concurrent matchings")
    nonconcurrent = tuple(
        matching_name(matching)
        for matching in MATCHINGS
        if matching_name(matching) not in set(primal)
    )
    nonconcurrent_determinants: list[dict[str, object]] = []
    for matching in MATCHINGS:
        name = matching_name(matching)
        if name not in set(nonconcurrent):
            continue
        primal_determinant = det3(tuple(cross(points[a], points[b]) for a, b in matching))
        gale_determinant = det3(
            tuple(cross(gale_points[a], gale_points[b]) for a, b in matching)
        )
        if primal_determinant.norm() != -64 or gale_determinant.norm() != -4:
            raise AssertionError("unexpected nonconcurrent determinant norm")
        nonconcurrent_determinants.append(
            {
                "matching": name,
                "primal_determinant": primal_determinant.display(),
                "primal_norm": int(primal_determinant.norm()),
                "gale_determinant": gale_determinant.display(),
                "gale_norm": int(gale_determinant.norm()),
            }
        )
    nonconcurrent_edges = [
        edge
        for matching in MATCHINGS
        if matching_name(matching) in set(nonconcurrent)
        for edge in matching
    ]
    if len(nonconcurrent_edges) != 15 or len(set(nonconcurrent_edges)) != 15:
        raise AssertionError("the five nonconcurrent matchings must factor K6")
    pentad = frozenset(nonconcurrent)
    stabilizer: list[tuple[int, ...]] = []
    orbit: set[frozenset[str]] = set()
    for permutation in itertools.permutations(range(N)):
        image = frozenset(
            transformed_matching_name(matching, permutation)
            for matching in MATCHINGS
            if matching_name(matching) in pentad
        )
        orbit.add(image)
        if image == pentad:
            stabilizer.append(permutation)
    if len(orbit) != 6 or len(stabilizer) != 120:
        raise AssertionError("unexpected one-factorization orbit/stabilizer")
    even_stabilizer = sum(permutation_even(permutation) for permutation in stabilizer)
    if even_stabilizer != 60:
        raise AssertionError("the pentad stabilizer must have an even index-two half")
    return {
        "base_ring": "Q(tau), tau^2=tau+1",
        "integral_gale_generator_rref": [
            [value.display() for value in row] for row in code
        ],
        "perfect_matchings": len(MATCHINGS),
        "primal_concurrent_matchings": list(primal),
        "gale_dual_concurrent_matchings": list(gale),
        "common_concurrent_matchings": len(primal),
        "nonconcurrent_matching_pentad": list(nonconcurrent),
        "nonconcurrent_determinants": nonconcurrent_determinants,
        "nonconcurrent_determinant_norms": {
            "primal": -64,
            "gale_dual": -4,
            "consequence": "no extra concurrent matching occurs in any odd reduction",
        },
        "nonconcurrent_pentad_is_one_factorization": True,
        "one_factorization_S6_orbit_size": len(orbit),
        "one_factorization_party_stabilizer_order": len(stabilizer),
        "even_party_stabilizer_order": even_stabilizer,
        "rank_four_marginal_triples_every_odd_reduction": 60 + len(primal),
        "rank_six_marginal_triples": 455 - 60 - len(primal),
    }


Permutation = tuple[int, ...]
IDENTITY: Permutation = tuple(range(N))


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[index]] for index in range(N))


def permutation_closure(generators: Sequence[Permutation]) -> frozenset[Permutation]:
    group = {IDENTITY}
    frontier = [IDENTITY]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            for product in (compose(element, generator), compose(generator, element)):
                if product not in group:
                    group.add(product)
                    frontier.append(product)
    return frozenset(group)


def fixed_points(permutation: Permutation) -> int:
    return sum(permutation[index] == index for index in range(N))


def permutation_lemma_certificate() -> dict[str, object]:
    fixed_free_involutions = tuple(
        permutation
        for permutation in itertools.permutations(range(N))
        if permutation != IDENTITY
        and compose(permutation, permutation) == IDENTITY
        and fixed_points(permutation) == 0
    )
    groups: set[frozenset[Permutation]] = {frozenset((IDENTITY,))}
    frontier = [frozenset((IDENTITY,))]
    while frontier:
        group = frontier.pop()
        for involution in fixed_free_involutions:
            if involution in group:
                continue
            extension = permutation_closure(tuple(group) + (involution,))
            if extension not in groups:
                groups.add(extension)
                frontier.append(extension)
    valid: list[tuple[int, int, frozenset[Permutation]]] = []
    for group in groups:
        if all(element == IDENTITY or fixed_points(element) <= 2 for element in group):
            count = sum(element in fixed_free_involutions for element in group)
            valid.append((len(group), count, group))
    type_counts = collections.Counter((order, count) for order, count, _ in valid)
    exceptional = [group for order, count, group in valid if order == 120 and count == 10]
    if sorted(type_counts) != [(1, 0), (2, 1), (4, 2), (6, 3), (12, 4), (24, 6), (120, 10)]:
        raise AssertionError("unexpected six-point permutation lemma types")
    if len(exceptional) != 6:
        raise AssertionError("unexpected number of labelled exceptional actions")
    for group in exceptional:
        ordered_triple_images = {
            (element[0], element[1], element[2]) for element in group
        }
        if len(ordered_triple_images) != 120:
            raise AssertionError("exceptional action is not sharply three-transitive")
    return {
        "fixed_free_involutions_in_S6": len(fixed_free_involutions),
        "generated_subgroups_checked": len(groups),
        "subgroups_satisfying_nonidentity_fixed_point_bound": len(valid),
        "type_counts": [
            {
                "group_order": order,
                "fixed_free_involutions": count,
                "labelled_subgroups": multiplicity,
            }
            for (order, count), multiplicity in sorted(type_counts.items())
        ],
        "exceptional_labelled_actions": len(exceptional),
        "exceptional_order": 120,
        "exceptional_fixed_free_involutions": 10,
        "exceptional_action": "sharply three-transitive on six points",
        "exceptional_geometry": (
            "After projective normalization the set is P^1(F_5); conversely an "
            "F_5-subline has ten fixed-free involutions."
        ),
        "characteristic_stop": (
            "A point stabilizer in the sharply three-transitive order-120 action is "
            "the sharply two-transitive Frobenius group C5 semidirect C4. If the "
            "characteristic is not 5, C5 is semisimple in PGL2 and its torus "
            "normalizer induces at most inversion, contradicting the faithful C4 "
            "action. Hence the characteristic is 5."
        ),
    }


def mod_inv(value: int) -> int:
    if value % Q == 0:
        raise ZeroDivisionError("zero has no inverse")
    return pow(value, Q - 2, Q)


def mod_rref(rows: Iterable[Sequence[int]]) -> tuple[tuple[int, ...], ...]:
    matrix = [[value % Q for value in row] for row in rows]
    if not matrix:
        return ()
    pivot_row = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (index for index in range(pivot_row, len(matrix)) if matrix[index][column] % Q),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = mod_inv(matrix[pivot_row][column])
        matrix[pivot_row] = [scale * value % Q for value in matrix[pivot_row]]
        for index in range(len(matrix)):
            if index == pivot_row:
                continue
            coefficient = matrix[index][column]
            matrix[index] = [
                (value - coefficient * pivot_value) % Q
                for value, pivot_value in zip(matrix[index], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return tuple(tuple(row) for row in matrix if any(value % Q for value in row))


def mod_nullspace(rows: Sequence[Sequence[int]], width: int = N) -> tuple[tuple[int, ...], ...]:
    reduced = mod_rref(rows)
    pivots = tuple(next(index for index, value in enumerate(row) if value) for row in reduced)
    free = [column for column in range(width) if column not in pivots]
    result: list[tuple[int, ...]] = []
    for column in free:
        vector = [0] * width
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column] % Q
        result.append(tuple(vector))
    return tuple(result)


def mod_matmul_row(vector: Sequence[int], rows: Sequence[Sequence[int]]) -> tuple[int, ...]:
    return tuple(
        sum(vector[row] * rows[row][column] for row in range(len(rows))) % Q
        for column in range(len(rows[0]))
    )


def mod_rowspace(rows: Iterable[Sequence[int]]) -> tuple[tuple[int, ...], ...]:
    return mod_rref(rows)


def grs_code(evaluation_set: Sequence[int]) -> tuple[tuple[int, ...], ...]:
    columns = tuple(
        (0, 0, 1) if value == Q else (1, value, value * value % Q)
        for value in evaluation_set
    )
    return tuple(tuple(columns[column][row] for column in range(N)) for row in range(3))


def h3_code_mod_19() -> tuple[tuple[int, ...], ...]:
    tau = 5
    columns = (
        (0, 1, 1 - tau),
        (0, 1, tau - 1),
        (1, 1 - tau, 0),
        (1, tau - 1, 0),
        (1, 0, -tau),
        (1, 0, tau),
    )
    parity_check = tuple(
        tuple(columns[column][row] % Q for column in range(N)) for row in range(3)
    )
    return mod_rowspace(mod_nullspace(parity_check))


def stabilizer_space(code: Sequence[Sequence[int]]) -> tuple[tuple[int, ...], ...]:
    dual = mod_nullspace(tuple(code))
    rows = [tuple(row) + (0,) * N for row in code]
    rows += [(0,) * N + tuple(row) for row in dual]
    return mod_rowspace(rows)


def direct_marginal_distribution(
    code: Sequence[Sequence[int]],
) -> tuple[tuple[int, int], ...]:
    shortenings = marginal_shortenings(code)
    ranks = collections.Counter(
        len(
            mod_rowspace(
                coefficient
                for shortening_index in triple
                for coefficient in shortenings[shortening_index]
            )
        )
        for triple in itertools.combinations(range(len(shortenings)), 3)
    )
    return tuple(sorted(ranks.items()))


def marginal_shortenings(
    code: Sequence[Sequence[int]],
) -> tuple[tuple[tuple[int, ...], ...], ...]:
    stabilizer = stabilizer_space(code)
    shortenings: list[tuple[tuple[int, ...], ...]] = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = mod_nullspace(equations, N)
        if len(coefficients) != 2:
            raise AssertionError("four-party stabilizer shortening must have dimension two")
        shortenings.append(coefficients)
    return tuple(shortenings)


def full_marginal_word_certificate(
    code: Sequence[Sequence[int]],
) -> dict[str, object]:
    """All distinct-word ranks for the fifteen commuting four-party marginals."""

    omitted_pairs = tuple(itertools.combinations(range(N), 2))
    pair_index = {pair: index for index, pair in enumerate(omitted_pairs)}
    shortenings = marginal_shortenings(code)
    ranks: dict[int, int] = {0: 0}
    histograms: dict[int, collections.Counter[int]] = {
        degree: collections.Counter() for degree in range(1, len(omitted_pairs) + 1)
    }
    for mask in range(1, 1 << len(omitted_pairs)):
        indices = tuple(index for index in range(len(omitted_pairs)) if mask >> index & 1)
        rank = len(
            mod_rowspace(
                coefficient for index in indices for coefficient in shortenings[index]
            )
        )
        ranks[mask] = rank
        histograms[len(indices)][rank] += 1

    def image_mask(mask: int, permutation: Sequence[int]) -> int:
        image = 0
        for index, pair in enumerate(omitted_pairs):
            if not (mask >> index & 1):
                continue
            transformed = tuple(sorted((permutation[pair[0]], permutation[pair[1]])))
            image |= 1 << pair_index[transformed]
        return image

    cubic_masks = tuple(mask for mask in ranks if mask.bit_count() == 3)
    cubic_automorphisms = tuple(
        permutation
        for permutation in itertools.permutations(range(N))
        if all(ranks[image_mask(mask, permutation)] == ranks[mask] for mask in cubic_masks)
    )
    full_automorphisms = tuple(
        permutation
        for permutation in cubic_automorphisms
        if all(ranks[image_mask(mask, permutation)] == rank for mask, rank in ranks.items())
    )
    if len(cubic_automorphisms) != 120 or len(full_automorphisms) != 120:
        raise AssertionError("the q=19 marginal rank data must retain exactly the S5 pentad roof")
    return {
        "field": "F_19",
        "distinct_marginal_subsets_checked": len(ranks),
        "rank_histogram_by_number_of_distinct_marginals": [
            {
                "degree": degree,
                "ranks": [
                    {"sum_rank": rank, "subsets": count}
                    for rank, count in sorted(histograms[degree].items())
                ],
            }
            for degree in sorted(histograms)
        ],
        "cubic_rank_tensor_party_automorphisms": len(cubic_automorphisms),
        "full_rank_function_party_automorphisms": len(full_automorphisms),
        "full_rank_function_even_automorphisms": sum(
            permutation_even(permutation) for permutation in full_automorphisms
        ),
        "orientation_boundary": (
            "Every trace word in the commuting identity-extended four-party marginals "
            "reduces, up to repetition scalars, to this subset-rank function. Its party "
            "symmetry is S5, not the even A5 half, so no such marginal trace word "
            "recovers the H3 orientation bit at q=19."
        ),
    }


def mobius_image(matrix: tuple[int, int, int, int], value: int) -> int:
    a, b, c, d = matrix
    if value == Q:
        return Q if c == 0 else a * mod_inv(c) % Q
    denominator = (c * value + d) % Q
    return Q if denominator == 0 else (a * value + b) * mod_inv(denominator) % Q


def pgl2_permutations() -> tuple[Permutation, ...]:
    normalized: set[tuple[int, int, int, int]] = set()
    for matrix in itertools.product(range(Q), repeat=4):
        a, b, c, d = matrix
        if (a * d - b * c) % Q == 0:
            continue
        first = next(value for value in matrix if value)
        scale = mod_inv(first)
        normalized.add(tuple(scale * value % Q for value in matrix))
    permutations = {
        tuple(mobius_image(matrix, value) for value in range(Q + 1))
        for matrix in normalized
    }
    if len(permutations) != Q * (Q * Q - 1):
        raise AssertionError("incorrect PGL(2,19) order")
    return tuple(sorted(permutations))


def evaluation_orbits() -> tuple[tuple[tuple[int, ...], int], ...]:
    permutations = pgl2_permutations()
    remaining = set(itertools.combinations(range(Q + 1), N))
    result: list[tuple[tuple[int, ...], int]] = []
    while remaining:
        representative = min(remaining)
        orbit = {
            tuple(sorted(permutation[value] for value in representative))
            for permutation in permutations
        }
        remaining -= orbit
        result.append((representative, len(orbit)))
    if sum(size for _, size in result) != 38760:
        raise AssertionError("PGL(2,19) orbits must cover all six-subsets")
    return tuple(result)


def conic_points(evaluation_set: Sequence[int]) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        (0, 0, 1) if value == Q else (1, value, value * value % Q)
        for value in evaluation_set
    )


def mod_matching_count(evaluation_set: Sequence[int]) -> int:
    points = conic_points(evaluation_set)
    return sum(
        det3(tuple(cross(points[a], points[b]) for a, b in matching)) % Q == 0
        for matching in MATCHINGS
    )


def q19_pilot_certificate() -> dict[str, object]:
    h3_code = h3_code_mod_19()
    target = direct_marginal_distribution(h3_code)
    if target != ((4, 70), (6, 385)):
        raise AssertionError("unexpected H3 q=19 marginal distribution")
    rows: list[dict[str, object]] = []
    matching_counts: collections.Counter[int] = collections.Counter()
    for representative, orbit_size in evaluation_orbits():
        matching_count = mod_matching_count(representative)
        distribution = direct_marginal_distribution(mod_rowspace(grs_code(representative)))
        expected = ((4, 60 + matching_count), (6, 395 - matching_count))
        if distribution != expected:
            raise AssertionError(
                "direct stabilizer and chord-concurrence replays disagree: "
                f"{representative=} {matching_count=} {distribution=} {expected=}"
            )
        matching_counts[matching_count] += orbit_size
        rows.append(
            {
                "representative": [
                    "infinity" if value == Q else value for value in representative
                ],
                "orbit_size": orbit_size,
                "concurrent_perfect_matchings": matching_count,
                "rank_four_marginal_triples": 60 + matching_count,
            }
        )
    if any(row["rank_four_marginal_triples"] == 70 for row in rows):
        raise AssertionError("q=19 GRS collision")
    return {
        "field": "F_19",
        "h3_tau": 5,
        "h3_direct_marginal_distribution": [
            {"sum_rank": rank, "count": count} for rank, count in target
        ],
        "pgl2_order": Q * (Q * Q - 1),
        "evaluation_sets": 38760,
        "pgl2_orbits": len(rows),
        "grs_matching_count_census_by_evaluation_set": [
            {"concurrent_matchings": count, "evaluation_sets": multiplicity}
            for count, multiplicity in sorted(matching_counts.items())
        ],
        "grs_orbits": rows,
        "collisions": 0,
        "independent_replay": (
            "Each orbit is checked both by conic chord determinants and by direct ranks "
            "of sums of shortened six-dimensional Pauli-label Lagrangians."
        ),
        "full_h3_marginal_word_boundary": full_marginal_word_certificate(h3_code),
    }


def build_certificate() -> dict[str, object]:
    return {
        "schema": "c402-h3-ame-uniform-lu-separation-v1",
        "invariant": (
            "The multiset of Tr(A_T A_U A_V), with A_T=rho_T tensor I_(T^c), "
            "over unordered triples of four-party subsets."
        ),
        "rank_four_reduction": (
            "For a six-arc and its Gale dual, rank four occurs for the 60 triples "
            "of omitted pairs forming a three-edge star, plus perfect matchings "
            "whose three chords concur in both arcs."
        ),
        "h3_exact": h3_golden_certificate(),
        "six_point_permutation_lemma": permutation_lemma_certificate(),
        "uniform_grs_bound": {
            "characteristic": "odd and not 5",
            "maximum_concurrent_perfect_matchings": 6,
            "maximum_rank_four_marginal_triples": 66,
            "reason": (
                "A concurrent perfect matching is a fixed-point-free involution of "
                "the six evaluation points. The permutation lemma leaves only 0,1,2,3,4,6 "
                "or the sharply-three-transitive value 10; the latter forces characteristic 5."
            ),
            "sharp_collision_boundary": (
                "A GRS six-set has 70 rank-four triples exactly when it is a "
                "projective F_5-subline; this can occur only in characteristic 5."
            ),
        },
        "q19_full_moduli_pilot": q19_pilot_certificate(),
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_certificate())
    if args.write:
        CERTIFICATE.write_bytes(generated)
        print(f"wrote {CERTIFICATE.name} ({len(generated)} bytes)")
        return
    tracked = CERTIFICATE.read_bytes()
    if tracked != generated:
        raise SystemExit("certificate is stale; rerun with --write")
    print(
        "C402 certificate OK: H3=70, GRS<=66 outside characteristic 5; "
        "q=19 has 13 PGL2 orbits and zero collisions"
    )


if __name__ == "__main__":
    main()
