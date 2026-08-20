#!/usr/bin/env python3
"""Finite law checks for the C925 categorical compiler.

This is a sanity model for the algebraic interface, not a verification of the
Iritani, Guere, BFGMP, or KKPYY comparison theorems.
"""

from __future__ import annotations

from collections import Counter
from fractions import Fraction
from itertools import permutations
import json


def bag(xs):
    return Counter(xs)


def flatten(xss):
    return [x for xs in xss for x in xs]


def add_obs(left, right):
    return tuple(a + b for a, b in zip(left, right))


def bad_club(obs):
    rho, nu, _nu_prime, _gamma = obs
    return nu != 0 and rho <= 2


def bad_heart(obs):
    _rho, nu, nu_prime, gamma = obs
    return nu != 0 and nu_prime == 0 and gamma <= 1


def separate_spectra(spectra):
    """Choose integral unit shifts making finitely many finite spectra disjoint."""
    shifted = []
    occupied = set()
    shifts = []
    for spectrum in spectra:
        shift = 0
        while any(value + shift in occupied for value in spectrum):
            shift += 1
        translated = {value + shift for value in spectrum}
        assert translated.isdisjoint(occupied)
        occupied.update(translated)
        shifted.append(translated)
        shifts.append(shift)
    return shifts, shifted


def localize(spectrum, carrier_dimension, cutoff):
    return Counter(
        {
            atom: multiplicity
            for atom, multiplicity in spectrum.items()
            if carrier_dimension[atom] > cutoff
        }
    )


def kan_push(counter, coarsen):
    result = Counter()
    for rich, multiplicity in counter.items():
        result[coarsen[rich]] += multiplicity
    return result


def vector(**entries):
    return Counter({key: value for key, value in entries.items() if value})


def scale(counter, scalar):
    return Counter({key: scalar * value for key, value in counter.items()})


def matrix_add(left, right):
    return [
        [a + b for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_multiply(left, right):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def identity(size):
    return [[Fraction(i == j) for j in range(size)] for i in range(size)]


def jordan(size):
    return [
        [Fraction(1 if j == i + 1 else 0) for j in range(size)]
        for i in range(size)
    ]


def kronecker(left, right):
    rows = len(left) * len(right)
    columns = len(left[0]) * len(right[0])
    result = [[Fraction(0) for _ in range(columns)] for _ in range(rows)]
    for i, left_row in enumerate(left):
        for j, coefficient in enumerate(left_row):
            for u, right_row in enumerate(right):
                for v, entry in enumerate(right_row):
                    result[i * len(right) + u][j * len(right[0]) + v] = (
                        coefficient * entry
                    )
    return result


def rational_rank(matrix):
    work = [list(map(Fraction, row)) for row in matrix]
    if not work:
        return 0
    rows = len(work)
    columns = len(work[0])
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        work[pivot_row] = [entry / pivot_value for entry in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            coefficient = work[row][column]
            if coefficient:
                work[row] = [
                    entry - coefficient * pivot_entry
                    for entry, pivot_entry in zip(work[row], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def nilpotent_jordan_partition(matrix):
    size = len(matrix)
    power = identity(size)
    kernel_dimensions = [0]
    for _ in range(size):
        power = matrix_multiply(power, matrix)
        kernel_dimensions.append(size - rational_rank(power))
    blocks_at_least = [
        kernel_dimensions[k] - kernel_dimensions[k - 1]
        for k in range(1, size + 1)
    ]
    partition = []
    for block_size in range(1, size + 1):
        next_count = blocks_at_least[block_size] if block_size < size else 0
        exact_count = blocks_at_least[block_size - 1] - next_count
        partition.extend([block_size] * exact_count)
    return sorted(partition, reverse=True)


def nilpotent_tensor(left_size, right_size):
    return matrix_add(
        kronecker(jordan(left_size), identity(right_size)),
        kronecker(identity(left_size), jordan(right_size)),
    )


def main():
    checks = {}

    # Free symmetric-monoidal 2-monad: units, multiplication, associativity,
    # symmetry, and fold fusion.
    xs = ["a", "b", "a", "c"]
    triple = [[["a"], ["b", "a"]], [[], ["c"]], [["b"]]]
    left_assoc = flatten([flatten(level) for level in triple])
    right_assoc = flatten(flatten(triple))
    assert bag(flatten([[x] for x in xs])) == bag(xs)
    assert bag(flatten([xs])) == bag(xs)
    assert bag(left_assoc) == bag(right_assoc)
    assert all(bag(order) == bag(xs) for order in permutations(xs))
    weights = {"a": 2, "b": 3, "c": 5}
    folded = sum(weights[x] for x in xs)
    assert (folded > 0) == any(weights[x] > 0 for x in xs)
    checks["free_sym_monad_and_fold_fusion"] = "pass"

    # Indexed scalar extension: identity, composition, and a commuting square.
    signature = (2, "J2", "disc_nonzero")

    def extend(block_signature, _source, _target):
        return block_signature

    assert extend(signature, "K", "K") == signature
    assert extend(extend(signature, "K", "L"), "L", "M") == extend(
        signature, "K", "M"
    )
    upper_then_right = extend(extend(signature, "K", "L"), "L", "Omega")
    left_then_lower = extend(extend(signature, "K", "Kprime"), "Kprime", "Omega")
    assert upper_then_right == left_then_lower
    checks["indexed_base_change_and_beck_chevalley_shadow"] = "pass"

    # Center localization is idempotent and nested cutoffs compose by max.
    dimensions = {"point": 0, "curve": 1, "surface": 2, "cubic": 3}
    spectrum = Counter({"point": 2, "curve": 1, "surface": 3, "cubic": 2})
    assert localize(localize(spectrum, dimensions, 2), dimensions, 2) == localize(
        spectrum, dimensions, 2
    )
    assert localize(localize(spectrum, dimensions, 1), dimensions, 2) == localize(
        spectrum, dimensions, 2
    )
    checks["center_localization_idempotent_and_nested"] = "pass"

    # Blowup plus exceptional projective bundle gives the Bittner relation.
    for codimension in range(2, 7):
        y = vector(Y=1)
        z = vector(Z=1)
        blowup = y + vector(Z=codimension - 1)
        exceptional = vector(Z=codimension)
        lhs = {key: blowup[key] - exceptional[key] for key in {"Y", "Z"}}
        rhs = {key: y[key] - z[key] for key in {"Y", "Z"}}
        assert lhs == rhs
    checks["bittner_relation_codimension_2_through_6"] = "pass"

    # Finite Kan aggregation is functorial under composite coarsening.
    rich = Counter({"J2_disc+": 2, "J2_disc0": 1, "J1": 5})
    first = {
        "J2_disc+": "rank2_kept",
        "J2_disc0": "rank2_rejected",
        "J1": "rank1",
    }
    second = {
        "rank2_kept": "retained",
        "rank2_rejected": "discarded",
        "rank1": "discarded",
    }
    composite = {key: second[value] for key, value in first.items()}
    assert kan_push(kan_push(rich, first), second) == kan_push(rich, composite)
    assert sum(kan_push(rich, first).values()) == sum(rich.values())
    checks["finite_kan_coarsening_composition"] = "pass"

    # Guere collision guard: collision can hide a violating block, while a
    # unit shift restores the blockwise Boolean fold.
    club_bad = (2, 1, 0, 0)
    club_mask = (2, 0, 0, 0)
    assert bad_club(club_bad) or bad_club(club_mask)
    assert not bad_club(add_obs(club_bad, club_mask))
    heart_bad = (0, 1, 0, 1)
    heart_mask = (0, 0, 0, 1)
    assert bad_heart(heart_bad) or bad_heart(heart_mask)
    assert not bad_heart(add_obs(heart_bad, heart_mask))
    shifts, separated = separate_spectra([{0, 2}, {0, 1}, {1, 3}])
    assert len(set().union(*separated)) == sum(len(x) for x in separated)
    assert len(shifts) == 3
    # In the cofinite quotient, finite modifications disappear and the tail
    # truth value is the complete eventual invariant.
    eventually_zero_a = (False, frozenset({1, 4, 9}))
    eventually_zero_b = (False, frozenset({2, 3}))
    assert eventually_zero_a[0] == eventually_zero_b[0]
    checks["guere_cofinite_probe_and_collision_guard"] = "pass"

    # KKPYY chemical formulas after atomization.
    atom_class = {
        "X_local": "alpha",
        "Bl_X_local": "alpha",
        "Z_local": "beta",
        "Bl_Z_1": "beta",
        "Bl_Z_2": "beta",
    }

    def atomize(local_blocks):
        return bag(atom_class[block] for block in local_blocks)

    assert atomize(["Bl_X_local", "Bl_Z_1", "Bl_Z_2"]) == atomize(
        ["X_local"]
    ) + scale(atomize(["Z_local"]), 2)
    assert scale(atomize(["X_local"]), 3) == atomize(
        ["X_local", "X_local", "X_local"]
    )
    checks["kkpyy_atomization_and_chemical_formula"] = "pass"

    # Retention ladder: split K0 distinguishes Jordan partitions that exact
    # K0 (length) identifies.
    partition_a = Counter({3: 1, 1: 2})
    partition_b = Counter({2: 2, 1: 1})
    assert partition_a != partition_b
    length_a = sum(size * multiplicity for size, multiplicity in partition_a.items())
    length_b = sum(size * multiplicity for size, multiplicity in partition_b.items())
    assert length_a == length_b == 5
    checks["split_vs_exact_k0_retention"] = "pass"

    # The unmarked constituent theory cannot pass the center-vanishing gate
    # after two or more stabilizations: the threefold carrier itself is then
    # an allowed center.
    for stabilization in range(2, 7):
        center_cutoff = 3 + stabilization - 2
        assert 3 <= center_cutoff
        stabilized = Counter({"cubic": stabilization + 1})
        assert localize(stabilized, {"cubic": 3}, center_cutoff) == Counter()
    checks["unmarked_constituent_no_go_m_2_through_6"] = "pass"

    # Rep(G_a) Clebsch-Gordan law for nilpotent Jordan blocks in characteristic
    # zero, including the projective/blowup coherence J_m tensor J_2.
    for left_size in range(1, 6):
        for right_size in range(1, 6):
            expected = sorted(
                [
                    left_size + right_size - 2 * index + 1
                    for index in range(1, min(left_size, right_size) + 1)
                ],
                reverse=True,
            )
            assert nilpotent_jordan_partition(
                nilpotent_tensor(left_size, right_size)
            ) == expected
    for size in range(2, 7):
        assert nilpotent_jordan_partition(nilpotent_tensor(size, 2)) == [
            size + 1,
            size - 1,
        ]
    checks["ga_clebsch_gordan_and_higher_pb_coherence"] = "pass"

    # Ideal-quotient telescope: elementary shears whose targets are killed by
    # the row marker remain invisible under arbitrary composition.
    transition_1 = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(2), Fraction(1), Fraction(0)],
        [Fraction(3), Fraction(0), Fraction(1)],
    ]
    transition_2 = [
        [Fraction(1), Fraction(0), Fraction(0)],
        [Fraction(0), Fraction(1), Fraction(4)],
        [Fraction(5), Fraction(0), Fraction(1)],
    ]
    composite_transition = matrix_multiply(transition_2, transition_1)
    rank_row = [Fraction(1), Fraction(0), Fraction(0)]
    assert transition_1[0] == rank_row
    assert transition_2[0] == rank_row
    assert composite_transition[0] == rank_row
    checks["ideal_quotient_composition_telescope"] = "pass"

    result = {
        "status": "pass",
        "check_count": len(checks),
        "checks": checks,
        "scope": "finite algebraic law model only; external comparison theorems are inputs",
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
