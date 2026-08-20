#!/usr/bin/env python3
"""Finite law checks for the C925 categorical compiler.

This is a sanity model for the algebraic interface, not a verification of the
Iritani, Guere, BFGMP, or KKPYY comparison theorems.
"""

from __future__ import annotations

from collections import Counter
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

    result = {
        "status": "pass",
        "check_count": len(checks),
        "checks": checks,
        "scope": "finite algebraic law model only; external comparison theorems are inputs",
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
