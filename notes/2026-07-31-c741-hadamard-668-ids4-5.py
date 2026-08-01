#!/usr/bin/env python3
"""Exact compression checkpoint for LP(333) multiplier IDs 4 and 5."""

from __future__ import annotations

import argparse
import functools
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from pathlib import Path

LENGTH = 333
GENERATORS = {4: (121,), 5: (211,)}
WITNESS_9 = (
    (-17, 5, -3, 1, 5, -3, 11, 5, -3),
    (-7, 3, -1, 1, 3, -1, 1, 3, -1),
)
WITNESS_37_ORBIT_VALUES = (
    (1, 3, 1, -1, 3, -1, -3, -1, 3, -3, -1, 1, -1),
    (1, 3, -1, 1, -1, 5, 3, -5, 3, -5, -5, 5, -3),
)


def closure(generators: tuple[int, ...], modulus: int = LENGTH) -> tuple[int, ...]:
    group = {1}
    while True:
        enlarged = group | {x * g % modulus for x in group for g in generators}
        if enlarged == group:
            return tuple(sorted(group))
        group = enlarged


def orbits(points: range, group: tuple[int, ...], modulus: int) -> list[tuple[int, ...]]:
    unused = set(points)
    answer = []
    while unused:
        seed = min(unused)
        orbit = tuple(sorted({g * seed % modulus for g in group}))
        answer.append(orbit)
        unused.difference_update(orbit)
    return answer


def paf(sequence: tuple[int, ...]) -> tuple[int, ...]:
    n = len(sequence)
    return tuple(
        sum(sequence[x] * sequence[(x + shift) % n] for x in range(n))
        for shift in range(1, n)
    )


def compressed_variables(group: tuple[int, ...], modulus: int) -> list[dict]:
    image = tuple(sorted({g % modulus for g in group}))
    variables = []
    for positions in orbits(range(modulus), image, modulus):
        representative = positions[0]
        stabilizer = tuple(g for g in group if g * representative % modulus == representative)
        fibre = range(representative, LENGTH, modulus)
        fibre_orbits = orbits(fibre, stabilizer, LENGTH)
        reachable = {0}
        for orbit in fibre_orbits:
            size = len(orbit)
            reachable = {x + size for x in reachable} | {x - size for x in reachable}
        variables.append(
            {"positions": positions, "weight": len(positions), "values": tuple(sorted(reachable))}
        )
    return variables


def compression_9_ledger(group: tuple[int, ...]) -> tuple[dict, list[tuple]]:
    variables = compressed_variables(group, 9)
    last_index = max(range(len(variables)), key=lambda i: len(variables[i]["values"]))
    ordered = [v for i, v in enumerate(variables) if i != last_index] + [variables[last_index]]
    last_values = set(ordered[-1]["values"])
    profiles: dict[tuple, list[tuple[int, ...]]] = defaultdict(list)
    accepted = 0
    for prefix in itertools.product(*(v["values"] for v in ordered[:-1])):
        numerator = 1 - sum(v["weight"] * x for v, x in zip(ordered[:-1], prefix))
        if numerator % ordered[-1]["weight"]:
            continue
        final = numerator // ordered[-1]["weight"]
        if final not in last_values:
            continue
        values = prefix + (final,)
        norm = sum(v["weight"] * x * x for v, x in zip(ordered, values))
        if norm > 594:
            continue
        sequence = [0] * 9
        for variable, value in zip(ordered, values):
            for position in variable["positions"]:
                sequence[position] = value
        sequence_t = tuple(sequence)
        profiles[(norm, paf(sequence_t))].append(sequence_t)
        accepted += 1

    good = {
        key
        for key in profiles
        if (594 - key[0], tuple(-74 - value for value in key[1])) in profiles
    }
    pairs = []
    seen = set()
    profile_pair_counts = []
    for key in sorted(good):
        complement = (594 - key[0], tuple(-74 - value for value in key[1]))
        if key in seen:
            continue
        seen.update((key, complement))
        left = profiles[key]
        right = profiles[complement]
        pairs.extend((a, b) for a in left for b in right)
        profile_pair_counts.append([len(left), len(right), key[0], complement[0]])
    return (
        {
            "accepted_sequences": accepted,
            "distinct_norm_paf_profiles": len(profiles),
            "participating_profiles": len(good),
            "unordered_profile_pairs": len(profile_pair_counts),
            "profile_pair_sequence_counts_and_norms": profile_pair_counts,
            "normalized_sequence_pairs": len(pairs),
        },
        pairs,
    )


def transform(sequence: tuple[int, ...], unit: int, translation: int) -> tuple[int, ...]:
    return tuple(sequence[(unit * x + translation) % 9] for x in range(9))


def canonical_pair(pair: tuple[tuple[int, ...], tuple[int, ...]]) -> tuple:
    a, b = pair
    return min(
        candidate
        for unit in (1, 2, 4, 5, 7, 8)
        for translation in (0, 3, 6)
        for candidate in (
            (transform(a, unit, translation), transform(b, unit, translation)),
            (transform(b, unit, translation), transform(a, unit, translation)),
        )
    )


def fixed_point_canonical_pair(
    pair: tuple[tuple[int, ...], tuple[int, ...]], case: str
) -> tuple:
    """Canonicalize under the stabilizer of a normalized fixed-point pattern."""
    a, b = pair
    if case == "same":
        return min(
            candidate
            for unit in (1, 2, 4, 5, 7, 8)
            for candidate in (
                (transform(a, unit, 0), transform(b, unit, 0)),
                (transform(b, unit, 0), transform(a, unit, 0)),
            )
        )
    if case == "different":
        return min(
            [(transform(a, unit, 0), transform(b, unit, 0)) for unit in (1, 4, 7)]
            + [(transform(b, unit, 3), transform(a, unit, 3)) for unit in (2, 5, 8)]
        )
    raise ValueError(case)


def marked_singleton_from_compression(sequence: tuple[int, ...]) -> int:
    """Recover the unique minus singleton from residues 0,3,6 modulo 9."""
    marked_residues = [r for r in (0, 3, 6) if sequence[r] % 6 == 5]
    assert len(marked_residues) == 1
    return 37 * marked_residues[0]


@functools.lru_cache(None)
def fixed_cycle_mixed_counts(
    margins: tuple[int, int, int], singletons: tuple[int, int, int]
) -> set[int]:
    states = {(*singletons, 1)}
    for _ in range(12):
        following = set()
        for a, b, c, mixed in states:
            for x, y, z in itertools.product((0, 1), repeat=3):
                candidate = (a + 3 * x, b + 3 * y, c + 3 * z)
                if all(candidate[i] <= margins[i] for i in range(3)):
                    following.add(
                        (*candidate, mixed + (3 if 0 < x + y + z < 3 else 0))
                    )
        states = following
    return {mixed for a, b, c, mixed in states if (a, b, c) == margins}


@functools.lru_cache(None)
def rotating_cycle_mixed_counts(target: int) -> set[int]:
    answer = set()
    for zero_bit in (0, 1):
        states = {(zero_bit, 0)}
        for _ in range(12):
            states = {
                (ones + orbit_ones, mixed + (3 if orbit_ones in (1, 2) else 0))
                for ones, mixed in states
                for orbit_ones in range(4)
                if ones + orbit_ones <= target
            }
        answer.update(mixed for ones, mixed in states if ones == target)
    return answer


@functools.lru_cache(None)
def shift_111_mixed_counts(sequence: tuple[int, ...]) -> set[int]:
    minus = tuple((37 - value) // 2 for value in sequence)
    singleton_bits = tuple(1 if sequence[r] % 6 == 5 else 0 for r in (0, 3, 6))
    possible = fixed_cycle_mixed_counts(
        tuple(minus[r] for r in (0, 3, 6)), singleton_bits
    )
    for residues in ((1, 4, 7), (2, 5, 8)):
        assert len({minus[r] for r in residues}) == 1
        rotating = rotating_cycle_mixed_counts(minus[residues[0]])
        possible = {left + right for left in possible for right in rotating}
    return possible


def witness_record(sequence_pair: tuple[tuple[int, ...], tuple[int, ...]], target: int) -> dict:
    a, b = sequence_pair
    joint_paf = tuple(x + y for x, y in zip(paf(a), paf(b)))
    assert sum(a) == sum(b) == 1
    assert joint_paf == (target,) * (len(a) - 1)
    return {
        "sequences": [list(a), list(b)],
        "row_sums": [1, 1],
        "joint_squared_norm": sum(x * x for x in a + b),
        "joint_paf_nonzero_shifts": list(joint_paf),
        "status": "FEASIBLE_COMPRESSION_ONLY",
    }


def build_certificate() -> dict:
    cases = []
    ledgers = []
    pair_sets = []
    for stable_id, generators in GENERATORS.items():
        group = closure(generators)
        full_orbits = orbits(range(LENGTH), group, LENGTH)
        ledger, pairs = compression_9_ledger(group)
        ledgers.append(ledger)
        pair_sets.append(pairs)
        cases.append(
            {
                "id": stable_id,
                "generators": list(generators),
                "group": list(group),
                "order": len(group),
                "full_orbit_count": len(full_orbits),
                "full_orbit_size_counts": {
                    str(k): v for k, v in sorted(Counter(map(len, full_orbits)).items())
                },
                "shift_orbit_count": len(full_orbits) - 1,
                "image_mod_9": sorted({g % 9 for g in group}),
                "image_mod_37": sorted({g % 37 for g in group}),
            }
        )
    assert ledgers[0] == ledgers[1]
    assert pair_sets[0] == pair_sets[1]
    assert len(pair_sets[0]) == 648
    canonical = {canonical_pair(pair) for pair in pair_sets[0]}
    assert len(canonical) == 108
    oriented_pairs = set(pair_sets[0]) | {(b, a) for a, b in pair_sets[0]}
    assert len(oriented_pairs) == 1296
    fixed_point_counts = {
        case: len({fixed_point_canonical_pair(pair, case) for pair in oriented_pairs})
        for case in ("same", "different")
    }
    assert fixed_point_counts == {"same": 324, "different": 648}
    compression_geometry = Counter(
        "same"
        if marked_singleton_from_compression(a) == marked_singleton_from_compression(b)
        else "different"
        for a, b in canonical
    )
    assert compression_geometry == {"same": 36, "different": 72}
    shift_111_summary = Counter()
    shift_111_feasible = 0
    for a, b in canonical:
        possible_a = shift_111_mixed_counts(a)
        possible_b = shift_111_mixed_counts(b)
        feasible = any(167 - value in possible_b for value in possible_a)
        shift_111_summary[(len(possible_a), len(possible_b), feasible)] += 1
        shift_111_feasible += feasible
    assert shift_111_feasible == 108

    group37 = (1, 10, 26)
    orbits37 = orbits(range(37), group37, 37)
    expanded37 = []
    for values in WITNESS_37_ORBIT_VALUES:
        sequence = [0] * 37
        for value, orbit in zip(values, orbits37):
            for position in orbit:
                sequence[position] = value
        expanded37.append(tuple(sequence))

    return {
        "schema": "c741-lp333-ids4-5-compression-checkpoint-v2",
        "length": LENGTH,
        "scope": "fixed untranslated common multipliers IDs 4 and 5",
        "cases": cases,
        "common_9_compression_ledger": ledgers[0],
        "row_sum_positive_pair_count": 648,
        "affine_decimation_translation_swap_representatives": len(canonical),
        "signed_zero_normalized_branch_count_before_affine_reduction": 2592,
        "fixed_point_lemma": {
            "singleton_positions": [0, 111, 222],
            "minus_signs_per_positive_row_on_singletons": 1,
            "normalized_relative_cases": ["same", "different"],
            "oriented_positive_compression_pairs": len(oriented_pairs),
            "stabilizer_representatives": fixed_point_counts,
            "global_108_geometry_counts": dict(sorted(compression_geometry.items())),
            "recovery_rule": "for r in {0,3,6}, compressed_value[r] == singleton_sign[r] (mod 6)",
        },
        "shift_111_compression_screen": {
            "required_joint_mixed_triples": 167,
            "feasible_representatives": shift_111_feasible,
            "summary": [
                {
                    "row_a_possible_count_size": key[0],
                    "row_b_possible_count_size": key[1],
                    "feasible": key[2],
                    "representatives": count,
                }
                for key, count in sorted(shift_111_summary.items())
            ],
            "conclusion": "NO_EXCLUSION",
        },
        "positive_control_9": witness_record(WITNESS_9, -74),
        "positive_control_37": witness_record(tuple(expanded37), -18),
        "exact_lift_status": "OPEN",
        "conclusion": "both separate quotient compressions are feasible; neither ID is decided",
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    choice = parser.add_mutually_exclusive_group(required=True)
    choice.add_argument("--output", type=Path)
    choice.add_argument("--check", type=Path)
    args = parser.parse_args()
    encoded = canonical_bytes(build_certificate())
    if args.output:
        args.output.write_bytes(encoded)
        print(f"wrote {args.output} sha256={hashlib.sha256(encoded).hexdigest()}")
    else:
        if args.check.read_bytes() != encoded:
            raise SystemExit("FAIL: regenerated certificate differs")
        print(f"PASS sha256={hashlib.sha256(encoded).hexdigest()}")


if __name__ == "__main__":
    main()
