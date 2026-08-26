"""Exact bounded-alphabet and sparse-incidence search primitives.

The routines here separate reusable finite-state mechanisms from the geometry
that supplies a particular incidence matrix or orbit decomposition.
"""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
from math import comb
from typing import Hashable, Iterable, Sequence


def binomial_basis_coefficients(values: Sequence[int]) -> tuple[int, ...]:
    """Interpolate integer data in the Newton binomial basis.

    If ``values[d] = f(d)`` for ``0 <= d <= m``, the result is the unique
    tuple ``c`` such that ``f(d) = sum_j c[j] * binom(d, j)`` throughout that
    bounded alphabet.  Forward differences keep the computation integral.
    """

    if not values:
        raise ValueError("at least one value is required")
    differences = tuple(values)
    coefficients = []
    while differences:
        coefficients.append(differences[0])
        differences = tuple(
            differences[i + 1] - differences[i]
            for i in range(len(differences) - 1)
        )
    return tuple(coefficients)


def bounded_threshold_coefficients(
    maximum: int, threshold: int
) -> tuple[int, ...]:
    """Exact binomial-basis polynomial for ``1[d >= threshold]`` on ``0..maximum``."""

    if maximum < 0 or not 0 <= threshold <= maximum + 1:
        raise ValueError("need maximum >= 0 and 0 <= threshold <= maximum + 1")
    return binomial_basis_coefficients(
        tuple(int(value >= threshold) for value in range(maximum + 1))
    )


def evaluate_binomial_polynomial(coefficients: Sequence[int], value: int) -> int:
    """Evaluate a Newton-binomial polynomial at a nonnegative integer."""

    if value < 0:
        raise ValueError("value must be nonnegative")
    return sum(
        coefficient * comb(value, degree)
        for degree, coefficient in enumerate(coefficients)
        if degree <= value
    )


def pack_ternary(values: Sequence[int]) -> int:
    """Pack trits into three-bit lanes, leaving one carry-safety bit per lane."""

    packed = 0
    for index, value in enumerate(values):
        if value not in (0, 1, 2):
            raise ValueError("ternary coordinates must lie in {0,1,2}")
        packed |= value << (3 * index)
    return packed


@lru_cache(maxsize=None)
def _ternary_masks(width: int) -> tuple[int, int, int, int]:
    if width < 0:
        raise ValueError("width must be nonnegative")
    one_mask = sum(1 << (3 * index) for index in range(width))
    two_mask = one_mask << 1
    high_mask = one_mask << 2
    return one_mask, two_mask, high_mask, one_mask | two_mask


def _validate_packed_ternary(packed: int, width: int) -> None:
    one_mask, two_mask, _, valid_mask = _ternary_masks(width)
    has_three = (packed & one_mask) & ((packed & two_mask) >> 1)
    if packed < 0 or packed & ~valid_mask or has_three:
        raise ValueError("integer is not a packed ternary vector of the given width")


def unpack_ternary(packed: int, width: int) -> tuple[int, ...]:
    _validate_packed_ternary(packed, width)
    result = tuple((packed >> (3 * index)) & 7 for index in range(width))
    return result


def add_packed_ternary(left: int, right: int, width: int) -> int:
    """Coordinatewise addition modulo three without unpacking the lanes."""

    # Three-bit lanes prevent carries because normalized inputs sum to at most
    # four.  Mark both 011 (three) and 100 (four), then subtract three.
    _validate_packed_ternary(left, width)
    _validate_packed_ternary(right, width)
    raw = left + right
    one_mask, two_mask, high_mask, _ = _ternary_masks(width)
    three_markers = (raw & one_mask) & ((raw & two_mask) >> 1)
    four_markers = (raw & high_mask) >> 2
    return raw - 3 * (three_markers | four_markers)


@dataclass(frozen=True)
class OrbitOption:
    """One contribution choice for an orbit block."""

    label: Hashable
    residue: tuple[int, ...]
    totals: tuple[int, ...] = ()


@dataclass(frozen=True)
class OrbitSyndromeResult:
    choices: tuple[Hashable, ...] | None
    states_examined: int
    bound_prunes: int
    residue_prunes: int
    memo_prunes: int

    @property
    def feasible(self) -> bool:
        return self.choices is not None


@dataclass(frozen=True)
class TernaryAffineProblem:
    option_families: tuple[tuple[OrbitOption, ...], ...]
    target_residue: tuple[int, ...]
    target_totals: tuple[int, ...]
    original_width: int
    compressed_width: int


@dataclass(frozen=True)
class TernaryAffineObstruction:
    baseline_residue: tuple[int, ...]
    target_difference: tuple[int, ...]
    annihilator: tuple[int, ...]
    nonzero_pairing: int
    span_rank: int


def compile_ternary_affine_constraints(
    option_families: Sequence[Iterable[OrbitOption]],
    target_residue: Sequence[int],
    target_totals: Sequence[int] = (),
) -> TernaryAffineProblem | TernaryAffineObstruction:
    """Quotient ternary syndromes by the affine span of option differences."""

    families = tuple(tuple(family) for family in option_families)
    if any(not family for family in families):
        raise ValueError("every orbit needs at least one option")
    width = len(target_residue)
    total_width = len(target_totals)
    if any(
        len(option.residue) != width or len(option.totals) != total_width
        for family in families
        for option in family
    ):
        raise ValueError("orbit option dimensions do not match the targets")

    def difference(left: Sequence[int], right: Sequence[int]) -> list[int]:
        return [(a - b) % 3 for a, b in zip(left, right)]

    rows: list[list[int]] = []
    pivots: list[int] = []

    def reduce(vector: Sequence[int]) -> tuple[list[int], list[int]]:
        remainder = [value % 3 for value in vector]
        coordinates = []
        for pivot, row in zip(pivots, rows):
            coefficient = remainder[pivot]
            coordinates.append(coefficient)
            remainder = [
                (value - coefficient * basis) % 3
                for value, basis in zip(remainder, row)
            ]
        return coordinates, remainder

    def insert(vector: Sequence[int]) -> None:
        _, remainder = reduce(vector)
        pivot = next((i for i, value in enumerate(remainder) if value), None)
        if pivot is None:
            return
        if remainder[pivot] == 2:
            remainder = [(2 * value) % 3 for value in remainder]
        for index, row in enumerate(rows):
            coefficient = row[pivot]
            rows[index] = [
                (value - coefficient * basis) % 3
                for value, basis in zip(row, remainder)
            ]
        position = next((i for i, old in enumerate(pivots) if old > pivot), len(pivots))
        pivots.insert(position, pivot)
        rows.insert(position, remainder)

    baseline = [0] * width
    for family in families:
        family_baseline = family[0].residue
        baseline = [(a + b) % 3 for a, b in zip(baseline, family_baseline)]
        for option in family[1:]:
            insert(difference(option.residue, family_baseline))

    target_difference = difference(target_residue, baseline)
    compressed_target, remainder = reduce(target_difference)
    free = next((i for i, value in enumerate(remainder) if value), None)
    if free is not None:
        annihilator = [0] * width
        annihilator[free] = 1
        for pivot, row in zip(pivots, rows):
            annihilator[pivot] = (-row[free]) % 3
        pairing = sum(a * b for a, b in zip(annihilator, target_difference)) % 3
        assert pairing
        return TernaryAffineObstruction(
            tuple(baseline),
            tuple(target_difference),
            tuple(annihilator),
            pairing,
            len(rows),
        )

    compressed_families = []
    for family in families:
        family_baseline = family[0].residue
        compressed_family = []
        for option in family:
            coordinates, remainder = reduce(difference(option.residue, family_baseline))
            assert not any(remainder)
            compressed_family.append(
                OrbitOption(option.label, tuple(coordinates), option.totals)
            )
        compressed_families.append(tuple(compressed_family))
    return TernaryAffineProblem(
        tuple(compressed_families),
        tuple(compressed_target),
        tuple(target_totals),
        width,
        len(rows),
    )


def ternary_orbit_syndrome_search(
    option_families: Sequence[Iterable[OrbitOption]],
    target_residue: Sequence[int],
    target_totals: Sequence[int] = (),
) -> OrbitSyndromeResult:
    """Find one exact orbit assignment with a ternary syndrome and integer totals.

    The search memoizes failed packed-syndrome states.  Suffix min/max bounds
    prune impossible integer totals, while coordinatewise suffix residue sets
    provide a cheap necessary modular condition.  The latter deliberately
    ignores correlations between syndrome coordinates and therefore cannot
    discard a feasible assignment.
    """

    families = tuple(tuple(family) for family in option_families)
    if any(not family for family in families):
        raise ValueError("every orbit needs at least one option")
    width = len(target_residue)
    total_width = len(target_totals)
    target = tuple(value % 3 for value in target_residue)
    normalized: list[tuple[OrbitOption, ...]] = []
    for family in families:
        if any(
            len(option.residue) != width or len(option.totals) != total_width
            for option in family
        ):
            raise ValueError("orbit option dimensions do not match the targets")
        normalized.append(
            tuple(
                OrbitOption(
                    option.label,
                    tuple(value % 3 for value in option.residue),
                    option.totals,
                )
                for option in family
            )
        )
    families = tuple(normalized)

    suffix_min = [[0] * total_width for _ in range(len(families) + 1)]
    suffix_max = [[0] * total_width for _ in range(len(families) + 1)]
    suffix_residues = [
        [frozenset({0}) for _ in range(width)] for _ in range(len(families) + 1)
    ]
    for index in range(len(families) - 1, -1, -1):
        for coordinate in range(total_width):
            entries = [option.totals[coordinate] for option in families[index]]
            suffix_min[index][coordinate] = min(entries) + suffix_min[index + 1][coordinate]
            suffix_max[index][coordinate] = max(entries) + suffix_max[index + 1][coordinate]
        for coordinate in range(width):
            suffix_residues[index][coordinate] = frozenset(
                (option.residue[coordinate] + tail) % 3
                for option in families[index]
                for tail in suffix_residues[index + 1][coordinate]
            )

    target_packed = pack_ternary(target)
    packed_options = tuple(
        tuple((option, pack_ternary(option.residue)) for option in family)
        for family in families
    )
    dead: set[tuple[int, int, tuple[int, ...]]] = set()
    states_examined = bound_prunes = residue_prunes = memo_prunes = 0

    def visit(
        index: int, packed: int, totals: tuple[int, ...]
    ) -> tuple[Hashable, ...] | None:
        nonlocal states_examined, bound_prunes, residue_prunes, memo_prunes
        states_examined += 1
        if any(
            totals[j] + suffix_min[index][j] > target_totals[j]
            or totals[j] + suffix_max[index][j] < target_totals[j]
            for j in range(total_width)
        ):
            bound_prunes += 1
            return None
        if any(
            (target[j] - ((packed >> (3 * j)) & 7)) % 3
            not in suffix_residues[index][j]
            for j in range(width)
        ):
            residue_prunes += 1
            return None
        state = (index, packed, totals)
        if state in dead:
            memo_prunes += 1
            return None
        if index == len(families):
            return () if packed == target_packed and totals == tuple(target_totals) else None
        for option, option_packed in packed_options[index]:
            tail = visit(
                index + 1,
                add_packed_ternary(packed, option_packed, width),
                tuple(totals[j] + option.totals[j] for j in range(total_width)),
            )
            if tail is not None:
                return (option.label,) + tail
        dead.add(state)
        return None

    choices = visit(0, 0, (0,) * total_width)
    return OrbitSyndromeResult(
        choices, states_examined, bound_prunes, residue_prunes, memo_prunes
    )


@dataclass(frozen=True)
class SignedIncidenceProfile:
    degrees: tuple[int, ...]
    signed_sums: tuple[int, ...]
    tangent_rows: tuple[int, ...]
    same_sign_secants: tuple[int, ...]

    @property
    def support_constraints_hold(self) -> bool:
        return not self.tangent_rows and not self.same_sign_secants


def signed_incidence_profile(
    incidence_rows: Sequence[Iterable[int]], signs: Sequence[int]
) -> SignedIncidenceProfile:
    """Compile incidence rows to bitsets and check signed-support constraints."""

    if any(sign not in (-1, 0, 1) for sign in signs):
        raise ValueError("signs must lie in {-1,0,1}")
    row_masks = []
    for row in incidence_rows:
        points = tuple(row)
        if len(set(points)) != len(points) or any(
            point < 0 or point >= len(signs) for point in points
        ):
            raise ValueError("incidence rows need distinct valid point indices")
        row_masks.append(sum(1 << point for point in points))
    positive_mask = sum(1 << point for point, sign in enumerate(signs) if sign == 1)
    negative_mask = sum(1 << point for point, sign in enumerate(signs) if sign == -1)
    return signed_incidence_profile_masks(
        row_masks, positive_mask, negative_mask, len(signs)
    )


def signed_incidence_profile_masks(
    row_masks: Sequence[int],
    positive_mask: int,
    negative_mask: int,
    point_count: int,
) -> SignedIncidenceProfile:
    """Bit-parallel signed incidence check using arbitrary-precision ``bit_count``."""

    if point_count < 0 or positive_mask < 0 or negative_mask < 0:
        raise ValueError("point count and masks must be nonnegative")
    universe_mask = (1 << point_count) - 1
    if (
        positive_mask & negative_mask
        or (positive_mask | negative_mask) & ~universe_mask
        or any(mask < 0 or mask & ~universe_mask for mask in row_masks)
    ):
        raise ValueError("signed and incidence masks must be valid and disjoint")
    support_mask = positive_mask | negative_mask
    degrees = tuple((row & support_mask).bit_count() for row in row_masks)
    signed_sums = tuple(
        (row & positive_mask).bit_count() - (row & negative_mask).bit_count()
        for row in row_masks
    )
    tangent_rows = tuple(index for index, degree in enumerate(degrees) if degree == 1)
    same_sign_secants = tuple(
        index
        for index, (degree, signed_sum) in enumerate(zip(degrees, signed_sums))
        if degree == 2 and abs(signed_sum) == 2
    )
    return SignedIncidenceProfile(
        degrees, signed_sums, tangent_rows, same_sign_secants
    )
