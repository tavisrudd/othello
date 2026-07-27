#!/usr/bin/env python3
"""Exact certificate for FOUR_COPY_HOLONOMY's four-copy cover-holonomy theorem."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
import tempfile
from collections import Counter
from fractions import Fraction
from pathlib import Path
from typing import Iterable, Sequence


STEM = "2026-07-23-four-copy-cover-holonomy"
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / f"{STEM}.json"
CONTRACTION_DIVISOR_STEM = "2026-07-23-contraction-rank-drop-divisor"
CONTRACTION_DIVISOR_SCRIPT = HERE / f"{CONTRACTION_DIVISOR_STEM}.py"
CONTRACTION_DIVISOR_CERTIFICATE = HERE / f"{CONTRACTION_DIVISOR_STEM}.json"
CONTRACTION_DIVISOR_HASHES = {
    "script": "abd4f23d1ac3b4c610eb3c0a5610866bd941dccdf3bcd59550fa5fd81bb4f1df",
    "certificate": "9ca05a5ed99bb5342ecff817dc964c6f9424ca4cdd69684298b8cd938225525b",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_contraction_divisor():
    observed = {
        "script": sha256(CONTRACTION_DIVISOR_SCRIPT),
        "certificate": sha256(CONTRACTION_DIVISOR_CERTIFICATE),
    }
    if observed != CONTRACTION_DIVISOR_HASHES:
        raise AssertionError(f"CONTRACTION_DIVISOR input drift: {observed}")
    spec = importlib.util.spec_from_file_location("contraction_divisor_frozen", CONTRACTION_DIVISOR_SCRIPT)
    if spec is None or spec.loader is None:
        raise AssertionError("cannot load frozen CONTRACTION_DIVISOR checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module, json.loads(CONTRACTION_DIVISOR_CERTIFICATE.read_text())


CONTRACTION_DIVISOR, CONTRACTION_DIVISOR_DATA = load_contraction_divisor()
Poly = tuple[int, ...]
Perm = tuple[int, ...]
S6 = tuple(itertools.permutations(range(6)))
IDENTITY6 = tuple(range(6))


def compose(left: Perm, right: Perm) -> Perm:
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(value: Perm) -> Perm:
    return tuple(value.index(index) for index in range(len(value)))


def conjugate(value: Perm, group: set[Perm]) -> set[Perm]:
    value_inverse = inverse(value)
    return {compose(compose(value, member), value_inverse) for member in group}


def parity(value: Sequence[int]) -> int:
    inversions = sum(
        value[left] > value[right]
        for left in range(len(value))
        for right in range(left + 1, len(value))
    )
    return -1 if inversions % 2 else 1


def permutation_order(value: Perm) -> int:
    return math.lcm(
        *[
            cycle_length
            for start in range(len(value))
            for cycle_length in [
                _cycle_length(value, start),
            ]
        ]
    )


def _cycle_length(value: Perm, start: int) -> int:
    point = value[start]
    length = 1
    while point != start:
        point = value[point]
        length += 1
    return length


def subgroup_generated(generators: Iterable[Perm]) -> set[Perm]:
    generators = tuple(generators)
    group = {IDENTITY6}
    frontier = [IDENTITY6]
    while frontier:
        left = frontier.pop()
        for right in generators:
            value = compose(left, right)
            if value not in group:
                group.add(value)
                frontier.append(value)
    return group


def derived_subgroup(group: set[Perm]) -> set[Perm]:
    commutators = []
    for left in group:
        for right in group:
            commutators.append(
                compose(
                    compose(compose(left, right), inverse(left)),
                    inverse(right),
                )
            )
    return subgroup_generated(commutators)


def group_summary(group: set[Perm]) -> dict[str, object]:
    unseen = set(range(6))
    orbits = []
    while unseen:
        start = min(unseen)
        orbit = {member[start] for member in group}
        orbits.append(sorted(orbit))
        unseen -= orbit
    return {
        "order": len(group),
        "element_order_histogram": dict(
            sorted(Counter(permutation_order(member) for member in group).items())
        ),
        "point_orbits": orbits,
    }


def quotient_copy_matrix(sigma: tuple[int, ...]) -> list[list[int]]:
    """Action on k^4/k(1,1,1,1), in the classes of e1,e2,e3."""
    output = [[0] * 3 for _ in range(3)]
    for column in range(1, 4):
        vector = [0] * 4
        vector[column] = 1
        pulled_back = [vector[sigma[row]] for row in range(4)]
        for row in range(1, 4):
            output[row - 1][column - 1] = pulled_back[row] - pulled_back[0]
    return output


def transport_matrix(party_permutation: Perm) -> list[list[Poly]]:
    """The 9x9 systematic two-matching transport operator."""
    sigmas = CONTRACTION_DIVISOR.permuted_sigmas(party_permutation)
    transports = [quotient_copy_matrix(sigma) for sigma in sigmas]
    code_columns = CONTRACTION_DIVISOR.code_columns()
    output = [[CONTRACTION_DIVISOR.ZERO] * 9 for _ in range(9)]
    for constrained_party in range(3):
        for free_party in range(3):
            coefficient = code_columns[constrained_party][free_party]
            left = transports[constrained_party]
            right = transports[3 + free_party]
            for copy_row in range(3):
                for copy_column in range(3):
                    output[3 * constrained_party + copy_row][
                        3 * free_party + copy_column
                    ] = CONTRACTION_DIVISOR.pscale(
                        coefficient,
                        left[copy_row][copy_column] - right[copy_row][copy_column],
                    )
    return output


def raw_transport_blocks(party_permutation: Perm) -> list[list[int]]:
    """The 9x9 integer matrix before inserting the nine code coefficients."""
    sigmas = CONTRACTION_DIVISOR.permuted_sigmas(party_permutation)
    transports = [quotient_copy_matrix(sigma) for sigma in sigmas]
    output = [[0] * 9 for _ in range(9)]
    for block_row in range(3):
        for block_column in range(3):
            for row in range(3):
                for column in range(3):
                    output[3 * block_row + row][3 * block_column + column] = (
                        transports[block_row][row][column]
                        - transports[3 + block_column][row][column]
                    )
    return output


def reduced_cycle_ledger(party_permutation: Perm) -> dict[tuple[int, int], int]:
    """Group the Leibniz expansion by b,c after a=b+c; divide by 64 d^3."""
    matrix = raw_transport_blocks(party_permutation)
    # The systematic coefficient array is [[a,b,c],[a,c,b],[d,d,d]].
    variable = ((0, 1, 2), (0, 2, 1), (3, 3, 3))
    abcd: Counter[tuple[int, int, int, int]] = Counter()
    for permutation in itertools.permutations(range(9)):
        coefficient = parity(permutation)
        exponents = [0, 0, 0, 0]
        for row, column in enumerate(permutation):
            coefficient *= matrix[row][column]
            if coefficient == 0:
                break
            exponents[variable[row // 3][column // 3]] += 1
        if coefficient:
            abcd[tuple(exponents)] += coefficient

    bc: Counter[tuple[int, int]] = Counter()
    for (a_power, b_power, c_power, d_power), coefficient in abcd.items():
        if d_power != 3:
            raise AssertionError("unexpected d-degree in cycle ledger")
        for b_from_a in range(a_power + 1):
            bc[(b_power + b_from_a, c_power + a_power - b_from_a)] += (
                coefficient * math.comb(a_power, b_from_a)
            )
    output = {}
    for monomial, coefficient in bc.items():
        if coefficient:
            if coefficient % 64:
                raise AssertionError("cycle coefficient is not divisible by 64")
            output[monomial] = coefficient // 64
    return dict(sorted(output.items()))


REPRESENTATIVES = {
    "minus": IDENTITY6,
    "plus": (0, 1, 2, 3, 5, 4),
    "z2": (0, 2, 3, 4, 1, 5),
}
EXPECTED_LEDGERS = {
    "minus": {
        (1, 5): -2,
        (2, 4): 3,
        (3, 3): 4,
        (4, 2): -3,
        (5, 1): -2,
    },
    "plus": {
        (1, 5): 2,
        (2, 4): 3,
        (3, 3): -4,
        (4, 2): -3,
        (5, 1): 2,
    },
    "z2": {
        (0, 6): -2,
        (2, 4): 7,
        (4, 2): -7,
        (6, 0): 2,
    },
}


def determinant_identities() -> dict[str, object]:
    invariants = CONTRACTION_DIVISOR.invariant_polynomials()
    a_value = (0, -4, 8, -4)
    b_value = invariants["B"]
    d_value = (2, -2)
    signed_minus = CONTRACTION_DIVISOR.psub(
        CONTRACTION_DIVISOR.pscale(b_value, 3), CONTRACTION_DIVISOR.pscale(a_value, 2)
    )
    signed_plus = CONTRACTION_DIVISOR.padd(
        CONTRACTION_DIVISOR.pscale(b_value, 3), CONTRACTION_DIVISOR.pscale(a_value, 2)
    )
    z2_value = CONTRACTION_DIVISOR.psub(
        CONTRACTION_DIVISOR.pmul(b_value, b_value),
        CONTRACTION_DIVISOR.pscale(CONTRACTION_DIVISOR.pmul(a_value, a_value), 2),
    )
    resonances = {
        "minus": (signed_minus, b_value),
        "plus": (signed_plus, b_value),
        "z2": (z2_value, CONTRACTION_DIVISOR.ONE),
    }
    output = {}
    for name, representative in REPRESENTATIVES.items():
        ledger = reduced_cycle_ledger(representative)
        if ledger != EXPECTED_LEDGERS[name]:
            raise AssertionError(f"{name} cycle-ledger drift")
        resonance, extra_unit = resonances[name]
        expected = CONTRACTION_DIVISOR.pscale(
            CONTRACTION_DIVISOR.pmul(
                CONTRACTION_DIVISOR.pmul(
                    CONTRACTION_DIVISOR.pmul(
                        CONTRACTION_DIVISOR.pmul(d_value, CONTRACTION_DIVISOR.pmul(d_value, d_value)),
                        a_value,
                    ),
                    extra_unit,
                ),
                resonance,
            ),
            64,
        )
        observed = CONTRACTION_DIVISOR.det_bareiss(transport_matrix(representative))
        if observed != expected:
            raise AssertionError(f"{name} transport determinant identity failed")
        output[name] = {
            "representative": list(representative),
            "cycle_polynomial_coefficients_b_power_c_power": {
                f"{b_power},{c_power}": coefficient
                for (b_power, c_power), coefficient in ledger.items()
            },
            "determinant_little_endian": list(observed),
            "localized_obstruction": {
                "minus": "3B-2A",
                "plus": "3B+2A",
                "z2": "B^2-2A^2",
            }[name],
        }
    return output


def resonance_root_spectrum() -> dict[str, object]:
    def w(value: Fraction) -> Fraction:
        return value / (1 - value * value)

    signed_minus = (Fraction(1, 2), Fraction(-2, 1))
    signed_plus = (Fraction(-1, 2), Fraction(2, 1))
    axial_squares = (Fraction(1, 2), Fraction(2, 1))
    if {w(value) for value in signed_minus} != {Fraction(2, 3)}:
        raise AssertionError("negative signed root orbit drift")
    if {w(value) for value in signed_plus} != {Fraction(-2, 3)}:
        raise AssertionError("positive signed root orbit drift")
    if {
        value / (1 - value) ** 2 for value in axial_squares
    } != {Fraction(2, 1)}:
        raise AssertionError("axial root orbit drift")
    # HOLONOMY_COMPLETENESS's y=(t-1)^2/t satisfies y+1=-b/t and y-1=-c/t.
    y_numerator = (1, -2, 1)
    if CONTRACTION_DIVISOR.padd(y_numerator, CONTRACTION_DIVISOR.T) != (1, -1, 1):
        raise AssertionError("y+1 numerator drift")
    if CONTRACTION_DIVISOR.psub(y_numerator, CONTRACTION_DIVISOR.T) != (1, -3, 1):
        raise AssertionError("y-1 numerator drift")
    a_value = (0, -4, 8, -4)
    b_value = CONTRACTION_DIVISOR.invariant_polynomials()["B"]
    signed_product = CONTRACTION_DIVISOR.pmul(
        CONTRACTION_DIVISOR.psub(CONTRACTION_DIVISOR.pscale(b_value, 3), CONTRACTION_DIVISOR.pscale(a_value, 2)),
        CONTRACTION_DIVISOR.padd(CONTRACTION_DIVISOR.pscale(b_value, 3), CONTRACTION_DIVISOR.pscale(a_value, 2)),
    )
    axial_factor = CONTRACTION_DIVISOR.psub(
        CONTRACTION_DIVISOR.pmul(b_value, b_value),
        CONTRACTION_DIVISOR.pscale(CONTRACTION_DIVISOR.pmul(a_value, a_value), 2),
    )
    if CONTRACTION_DIVISOR.psub(signed_product, CONTRACTION_DIVISOR.pscale(axial_factor, 2)) != CONTRACTION_DIVISOR.pscale(
        CONTRACTION_DIVISOR.pmul(b_value, b_value), 7
    ):
        raise AssertionError("characteristic-seven scheme identity drift")
    ramification_root = Fraction(3, 5)
    axial_values = (
        2 * ramification_root**2 - 1,
        ramification_root**2 - 2,
    )
    signed_minus_values = (
        2 * ramification_root - 1,
        ramification_root + 2,
    )
    signed_plus_values = (
        2 * ramification_root + 1,
        ramification_root - 2,
    )
    if axial_values != (Fraction(-7, 25), Fraction(-41, 25)):
        raise AssertionError("axial ramification collision drift")
    if signed_minus_values != (Fraction(1, 5), Fraction(13, 5)):
        raise AssertionError("negative signed ramification collision drift")
    if signed_plus_values != (Fraction(11, 5), Fraction(-7, 5)):
        raise AssertionError("positive signed ramification collision drift")
    return {
        "coordinate": "r=b/c",
        "map": "w=r/(1-r^2), z=r^2/(1-r^2)^2",
        "holonomy_completeness_bridge": {
            "y": "(t-1)^2/t",
            "cayley_transform": "r=(y+1)/(y-1), y=(r+1)/(r-1)",
            "deck_dictionary": {
                "y->1/y": "r->-r",
                "y->-y": "r->1/r",
                "y->-1/y": "r->-1/r",
            },
        },
        "boundary_roots": ["0", "infinity", "1", "-1"],
        "signed_minus": {
            "r_roots": ["1/2", "-2"],
            "involution": "r -> -1/r",
            "w": "2/3",
        },
        "signed_plus": {
            "r_roots": ["-1/2", "2"],
            "involution": "r -> -1/r",
            "w": "-2/3",
        },
        "axial": {
            "r_squared_roots": ["1/2", "2"],
            "involution": "r^2 -> 1/r^2",
            "z": "2",
        },
        "characteristic_7_scheme_identity": (
            "(3B-2A)(3B+2A)-2(B^2-2A^2)=7B^2"
        ),
        "ramification_collision": {
            "nonboundary_branch": "t=-1, r=3/5",
            "axial_factor_values": ["-7/25", "-41/25"],
            "signed_minus_factor_values": ["1/5", "13/5"],
            "signed_plus_factor_values": ["11/5", "-7/5"],
            "exceptional_primes": [7, 11, 13, 41],
        },
    }


def octahedral_groups() -> tuple[set[Perm], set[Perm], set[Perm]]:
    full = set()
    rotations = set()
    for axis_permutation in itertools.permutations(range(3)):
        axis_parity = parity(axis_permutation)
        for sign_changes in itertools.product(range(2), repeat=3):
            value = tuple(
                2 * axis_permutation[point // 2]
                + ((point % 2) ^ sign_changes[point // 2])
                for point in range(6)
            )
            full.add(value)
            determinant = axis_parity * (-1) ** sum(sign_changes)
            if determinant == 1:
                rotations.add(value)
    axis_stabilizer = {
        member for member in full if {member[0], member[1]} == {0, 1}
    }
    return full, rotations, axis_stabilizer


def double_cosets(left: set[Perm], right: set[Perm]) -> list[dict[str, object]]:
    unseen = set(S6)
    output = []
    while unseen:
        representative = min(unseen)
        cell = {
            compose(compose(left_value, representative), right_value)
            for left_value in left
            for right_value in right
        }
        output.append({"representative": representative, "members": cell})
        unseen -= cell
    return sorted(output, key=lambda item: (len(item["members"]), item["representative"]))


def matching_image(matching: set[frozenset[int]], value: Perm) -> set[frozenset[int]]:
    return {frozenset(value[point] for point in edge) for edge in matching}


def bare_cover_automorphisms() -> dict[str, object]:
    """Automorphisms of the unweighted colored cover, before linear reduction."""
    symmetric4 = tuple(itertools.permutations(range(4)))
    seed = (CONTRACTION_DIVISOR.IDENTITY4,) + CONTRACTION_DIVISOR.SEED_TAIL
    seed_index = {value: index for index, value in enumerate(seed)}
    images = {"bipartition_preserving": set(), "bipartition_swapping": set()}
    lift_counts = Counter()
    for swaps_parts, key in (
        (False, "bipartition_preserving"),
        (True, "bipartition_swapping"),
    ):
        for left in symmetric4:
            for right in symmetric4:
                transformed = [
                    compose(
                        compose(
                            right,
                            inverse(sigma) if swaps_parts else sigma,
                        ),
                        inverse(left),
                    )
                    for sigma in seed
                ]
                if all(value in seed_index for value in transformed):
                    images[key].add(
                        tuple(seed_index[value] for value in transformed)
                    )
                    lift_counts[key] += 1
    total_image = images["bipartition_preserving"] | images["bipartition_swapping"]
    if (
        lift_counts["bipartition_preserving"],
        lift_counts["bipartition_swapping"],
        len(total_image),
    ) != (2, 2, 4):
        raise AssertionError("bare-cover automorphism boundary drift")
    return {
        "bipartition_preserving_lifts": lift_counts["bipartition_preserving"],
        "bipartition_swapping_lifts": lift_counts["bipartition_swapping"],
        "party_image": group_summary(total_image),
        "interpretation": (
            "the octahedral groups act on the reduced linear transport frame, "
            "not on the unweighted bipartite multigraph alone"
        ),
    }


def support_from_contraction_divisor(bit: int) -> set[Perm]:
    word = CONTRACTION_DIVISOR_DATA["component_mask_word_in_lexicographic_S6_order"]
    masks = [int(word[2 * index : 2 * index + 2], 16) for index in range(720)]
    return {
        permutation
        for permutation, mask in zip(S6, masks, strict=True)
        if mask & (1 << bit)
    }


def polyhedral_classification() -> dict[str, object]:
    full, rotations, axis_stabilizer = octahedral_groups()
    if (len(full), len(rotations), len(axis_stabilizer)) != (48, 24, 16):
        raise AssertionError("octahedral group construction failed")
    transport_relabelling = (0, 4, 1, 3, 2, 5)
    right_full = conjugate(transport_relabelling, full)
    right_axis = conjugate(transport_relabelling, axis_stabilizer)
    base_matching = {
        frozenset((0, 1)),
        frozenset((2, 3)),
        frozenset((4, 5)),
    }
    transport_matching = matching_image(base_matching, transport_relabelling)
    marked_transport_axis = frozenset(
        (transport_relabelling[0], transport_relabelling[1])
    )

    axis_cells = double_cosets(full, right_axis)
    signed_cells = double_cosets(rotations, right_full)
    expected_axis_sizes = [48, 96, 192, 384]
    expected_signed_sizes = [48, 192, 192, 288]
    if [len(cell["members"]) for cell in axis_cells] != expected_axis_sizes:
        raise AssertionError("axis double-coset classification drift")
    if [len(cell["members"]) for cell in signed_cells] != expected_signed_sizes:
        raise AssertionError("signed double-coset classification drift")

    axis_support = next(
        cell["members"]
        for cell in axis_cells
        if cell["representative"] == REPRESENTATIVES["z2"]
    )
    minus_support = next(
        cell["members"]
        for cell in signed_cells
        if cell["representative"] == REPRESENTATIVES["minus"]
    )
    plus_support = next(
        cell["members"]
        for cell in signed_cells
        if cell["representative"] == REPRESENTATIVES["plus"]
    )
    for bit in (0, 1):
        if support_from_contraction_divisor(bit) != axis_support:
            raise AssertionError("CONTRACTION_DIVISOR z=2 mask is not the axial double coset")
    for bit in (2, 3):
        if support_from_contraction_divisor(bit) != minus_support:
            raise AssertionError("CONTRACTION_DIVISOR minus mask is not the negative chiral cell")
    for bit in (4, 5):
        if support_from_contraction_divisor(bit) != plus_support:
            raise AssertionError("CONTRACTION_DIVISOR plus mask is not the positive chiral cell")

    def describe_cells(
        cells: list[dict[str, object]], marked: bool
    ) -> list[dict[str, object]]:
        descriptions = []
        for cell in cells:
            representative = cell["representative"]
            moved_matching = matching_image(transport_matching, representative)
            common = base_matching & moved_matching
            item = {
                "representative": list(representative),
                "size": len(cell["members"]),
                "shared_opposite_pairs": len(common),
            }
            if marked:
                moved_mark = frozenset(
                    representative[point] for point in marked_transport_axis
                )
                item["marked_axis_is_shared"] = moved_mark in common
            descriptions.append(item)
        return descriptions

    seams = {}
    for name, left, right in (
        ("z2", full, right_axis),
        ("minus", rotations, right_full),
        ("plus", rotations, right_full),
    ):
        representative = REPRESENTATIVES[name]
        seam = left & conjugate(representative, right)
        seams[name] = group_summary(seam)
    if seams["z2"]["element_order_histogram"] != {1: 1, 2: 7}:
        raise AssertionError("axial seam is not C2^3")
    for name in ("minus", "plus"):
        if seams[name]["element_order_histogram"] != {1: 1, 2: 3, 3: 2}:
            raise AssertionError("signed seam is not S3")

    tetrahedral = derived_subgroup(rotations)
    if len(tetrahedral) != 12 or not tetrahedral <= full:
        raise AssertionError("common A4 construction failed")
    rotational_point_stabilizer = {
        member for member in rotations if member[0] == 0
    }
    if group_summary(rotational_point_stabilizer)[
        "element_order_histogram"
    ] != {1: 1, 2: 1, 4: 2}:
        raise AssertionError("rotational degree-six action does not have C4 stabilizer")

    invariants = CONTRACTION_DIVISOR.invariant_polynomials()
    a_value = (0, -4, 8, -4)
    resonance_factors = {
        "B^2-2A^2": CONTRACTION_DIVISOR.psub(
            CONTRACTION_DIVISOR.pmul(invariants["B"], invariants["B"]),
            CONTRACTION_DIVISOR.pscale(CONTRACTION_DIVISOR.pmul(a_value, a_value), 2),
        ),
        "3B-2A": CONTRACTION_DIVISOR.psub(
            CONTRACTION_DIVISOR.pscale(invariants["B"], 3), CONTRACTION_DIVISOR.pscale(a_value, 2)
        ),
        "3B+2A": CONTRACTION_DIVISOR.padd(
            CONTRACTION_DIVISOR.pscale(invariants["B"], 3), CONTRACTION_DIVISOR.pscale(a_value, 2)
        ),
    }

    def resonance_hits(cells: list[dict[str, object]]) -> list[dict[str, object]]:
        output = []
        for cell in cells:
            representative = cell["representative"]
            determinant = CONTRACTION_DIVISOR.det_bareiss(transport_matrix(representative))
            hits = [
                name
                for name, factor in resonance_factors.items()
                if not CONTRACTION_DIVISOR.pdivmod_q(determinant, factor)[1]
            ]
            output.append(
                {
                    "representative": list(representative),
                    "size": len(cell["members"]),
                    "resonance_factors": hits,
                }
            )
        return output

    axis_hits = resonance_hits(axis_cells)
    signed_hits = resonance_hits(signed_cells)
    if [item["size"] for item in axis_hits if "B^2-2A^2" in item["resonance_factors"]] != [96]:
        raise AssertionError("axial representative reduction is incomplete")
    if [
        (item["size"], item["resonance_factors"])
        for item in signed_hits
        if item["resonance_factors"]
    ] != [(192, ["3B-2A"]), (192, ["3B+2A"])]:
        raise AssertionError("signed representative reduction is incomplete")
    return {
        "party_axis_pairs": [sorted(edge) for edge in sorted(base_matching, key=sorted)],
        "transport_axis_pairs": [
            sorted(edge) for edge in sorted(transport_matching, key=sorted)
        ],
        "transport_relabelling": list(transport_relabelling),
        "groups": {
            "full_octahedral": group_summary(full),
            "rotational_octahedral": group_summary(rotations),
            "axis_equator_stabilizer": group_summary(axis_stabilizer),
            "common_tetrahedral_A4": group_summary(tetrahedral),
            "rotational_point_stabilizer_C4": group_summary(
                rotational_point_stabilizer
            ),
        },
        "bare_cover_automorphisms": bare_cover_automorphisms(),
        "axis_relative_cells": describe_cells(axis_cells, marked=True),
        "signed_relative_cells": describe_cells(signed_cells, marked=False),
        "axis_cell_resonance_tests": axis_hits,
        "signed_cell_resonance_tests": signed_hits,
        "seams": seams,
        "support_sizes": {
            "z2": len(axis_support),
            "minus": len(minus_support),
            "plus": len(plus_support),
            "z2_mod_A4": len(axis_support) // len(tetrahedral),
            "signed_mod_A4": len(minus_support) // len(tetrahedral),
        },
    }


def finite_rank(matrix: Sequence[Sequence[Poly]], point: int, prime: int) -> int:
    return CONTRACTION_DIVISOR.rank_numeric(matrix, point, prime)


def finite_bridge() -> dict[str, object]:
    replay_points = ((7, 2), (7, 4), (7, 6), (11, 10), (13, 12), (41, 40))
    output = {}
    for prime, point in replay_points:
        transport_histogram: Counter[int] = Counter()
        quotient_histogram: Counter[int] = Counter()
        for party_permutation in S6:
            quotient_rank = finite_rank(
                CONTRACTION_DIVISOR.contraction_matrix(
                    CONTRACTION_DIVISOR.permuted_sigmas(party_permutation)
                ),
                point,
                prime,
            )
            transport_rank = finite_rank(
                transport_matrix(party_permutation), point, prime
            )
            if 21 - quotient_rank != 9 - transport_rank:
                raise AssertionError(
                    f"section/transport kernel mismatch at F_{prime}, t={point}"
                )
            quotient_histogram[quotient_rank] += 1
            transport_histogram[transport_rank] += 1
        output[f"F_{prime}_t_{point}"] = {
            "quotient_24x21_rank_histogram": dict(sorted(quotient_histogram.items())),
            "transport_9x9_rank_histogram": dict(
                sorted(transport_histogram.items())
            ),
        }
    return output


def analyze() -> dict[str, object]:
    return {
        "schema": "four_copy_holonomy-four-copy-cover-holonomy-v1",
        "frozen_inputs": CONTRACTION_DIVISOR_HASHES,
        "conventions": {
            "copy_quotient_basis": "classes of e1,e2,e3 in k^4/k(1,1,1,1)",
            "party_permutations": "zero-based images in lexicographic S6 order",
            "transport_blocks": "g_ik*(rho_i-rho_(3+k)), i,k=0,1,2",
            "systematic_coefficients": "[[a,b,c],[a,c,b],[d,d,d]]",
            "pencil_identities": {
                "a": "b+c",
                "d^2": "-2a",
                "A": "a(c-b)",
                "B": "bc",
            },
        },
        "determinant_identities": determinant_identities(),
        "resonance_root_spectrum": resonance_root_spectrum(),
        "polyhedral_classification": polyhedral_classification(),
        "finite_section_transport_bridge": finite_bridge(),
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = analyze()
    encoded = canonical_bytes(payload)
    if args.check:
        with tempfile.TemporaryDirectory(prefix="four_copy_holonomy-check-") as temporary:
            candidate = Path(temporary) / OUTPUT.name
            candidate.write_bytes(encoded)
            if not OUTPUT.exists():
                raise AssertionError(f"missing canonical output {OUTPUT}")
            if candidate.read_bytes() != OUTPUT.read_bytes():
                raise AssertionError("canonical FOUR_COPY_HOLONOMY certificate is stale")
        print("FOUR_COPY_HOLONOMY cover-holonomy certificate: PASS")
    else:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
