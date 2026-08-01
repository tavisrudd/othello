#!/usr/bin/env python3
"""Independent replay of the C741 compression checkpoint."""

from __future__ import annotations

import itertools
import functools
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

N = 333


def correlations(sequence: tuple[int, ...]) -> tuple[int, ...]:
    size = len(sequence)
    return tuple(
        sum(sequence[(i - shift) % size] * sequence[i] for i in range(size))
        for shift in range(1, size)
    )


def generated(generator: int) -> tuple[int, ...]:
    values = {1}
    while True:
        enlarged = values | {(x * generator) % N for x in values}
        if enlarged == values:
            return tuple(sorted(values))
        values = enlarged


def partition(group: tuple[int, ...], modulus: int) -> list[tuple[int, ...]]:
    answer = []
    used = set()
    for seed in range(modulus):
        if seed not in used:
            orbit = tuple(sorted({g * seed % modulus for g in group}))
            answer.append(orbit)
            used.update(orbit)
    return answer


def reachable_value_set(sizes: list[int]) -> tuple[int, ...]:
    reachable = {0}
    for size in sizes:
        reachable = {value - size for value in reachable} | {value + size for value in reachable}
    return tuple(sorted(reachable))


def value_domains(group: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    image = tuple(sorted({g % 9 for g in group}))
    domains = []
    for positions in partition(image, 9):
        representative = positions[0]
        stabilizer = tuple(g for g in group if g * representative % 9 == representative)
        fibre = [x for x in range(N) if x % 9 == representative]
        unused = set(fibre)
        sizes = []
        while unused:
            seed = min(unused)
            orbit = {g * seed % N for g in stabilizer}
            sizes.append(len(orbit))
            unused.difference_update(orbit)
        domains.append(reachable_value_set(sizes))
    return tuple(domains)


def enumerate_compressions(group: tuple[int, ...]) -> tuple[dict, list[tuple]]:
    domains = value_domains(group)
    profiles: dict[tuple, list[tuple[int, ...]]] = defaultdict(list)
    accepted = 0
    # Variables are c0, x, y, c3, c6 in the position pattern below.
    for c0, x, y, c3 in itertools.product(domains[0], domains[1], domains[2], domains[3]):
        c6 = 1 - c0 - c3 - 3 * x - 3 * y
        if c6 not in domains[4]:
            continue
        sequence = (c0, x, y, c3, x, y, c6, x, y)
        norm = c0 * c0 + c3 * c3 + c6 * c6 + 3 * x * x + 3 * y * y
        if norm > 594:
            continue
        profiles[(norm, correlations(sequence))].append(sequence)
        accepted += 1

    good = {key for key in profiles if (594 - key[0], tuple(-74 - x for x in key[1])) in profiles}
    seen = set()
    pairs = []
    counts = []
    for key in sorted(good):
        other = (594 - key[0], tuple(-74 - x for x in key[1]))
        if key in seen:
            continue
        seen.update((key, other))
        counts.append([len(profiles[key]), len(profiles[other]), key[0], other[0]])
        pairs.extend((a, b) for a in profiles[key] for b in profiles[other])
    return {
        "accepted_sequences": accepted,
        "distinct_norm_paf_profiles": len(profiles),
        "participating_profiles": len(good),
        "unordered_profile_pairs": len(counts),
        "profile_pair_sequence_counts_and_norms": counts,
        "normalized_sequence_pairs": len(pairs),
    }, pairs


def transformed(sequence: tuple[int, ...], unit: int, translation: int) -> tuple[int, ...]:
    return tuple(sequence[(unit * i + translation) % 9] for i in range(9))


def canonical(pair: tuple[tuple[int, ...], tuple[int, ...]]) -> tuple:
    a, b = pair
    images = []
    for unit in (1, 2, 4, 5, 7, 8):
        for translation in (0, 3, 6):
            x, y = transformed(a, unit, translation), transformed(b, unit, translation)
            images.extend(((x, y), (y, x)))
    return min(images)


def fixed_canonical(pair: tuple[tuple[int, ...], tuple[int, ...]], case: str) -> tuple:
    a, b = pair
    if case == "same":
        images = []
        for unit in (1, 2, 4, 5, 7, 8):
            x, y = transformed(a, unit, 0), transformed(b, unit, 0)
            images.extend(((x, y), (y, x)))
        return min(images)
    images = [
        (transformed(a, unit, 0), transformed(b, unit, 0)) for unit in (1, 4, 7)
    ]
    images.extend(
        (transformed(b, unit, 3), transformed(a, unit, 3)) for unit in (2, 5, 8)
    )
    return min(images)


def compression_mark(sequence: tuple[int, ...]) -> int:
    candidates = []
    for residue in (0, 3, 6):
        # The fibre is one singleton plus twelve orbits of size three.  The
        # twelve orbit signs have even sum, so their contribution is 0 mod 6.
        if sequence[residue] % 6 == (-1) % 6:
            candidates.append(37 * residue)
        else:
            assert sequence[residue] % 6 == 1
    assert len(candidates) == 1
    return candidates[0]


@functools.lru_cache(None)
def replay_shift_111_counts(sequence: tuple[int, ...]) -> set[int]:
    minus = [(37 - value) // 2 for value in sequence]
    singleton = [1 if sequence[r] % 6 == 5 else 0 for r in (0, 3, 6)]
    scaled_target = tuple((minus[r] - singleton[i]) // 3 for i, r in enumerate((0, 3, 6)))
    # Count mixed nonzero K37-orbits after scaling their common weight from 3 to 1.
    fixed_states = {(0, 0, 0, 0)}
    for _ in range(12):
        fixed_states = {
            (a+x, b+y, c+z, m + (1 if 0 < x+y+z < 3 else 0))
            for a,b,c,m in fixed_states
            for x,y,z in itertools.product((0,1), repeat=3)
            if a+x <= scaled_target[0]
            and b+y <= scaled_target[1]
            and c+z <= scaled_target[2]
        }
    possible = {
        1 + 3*m for a,b,c,m in fixed_states if (a,b,c) == scaled_target
    }
    for residues in ((1,4,7),(2,5,8)):
        target = minus[residues[0]]
        rotating = set()
        # Independent stars-and-bars enumeration of counts of orbit patterns
        # having 0,1,2,3 ones, rather than the generator's orbit-by-orbit DP.
        for zero_bit in (0,1):
            for n0 in range(13):
                for n1 in range(13-n0):
                    for n2 in range(13-n0-n1):
                        n3 = 12-n0-n1-n2
                        if zero_bit+n1+2*n2+3*n3 == target:
                            rotating.add(3*(n1+n2))
        possible = {a+b for a in possible for b in rotating}
    return possible


def check_witness(record: dict, target: int) -> None:
    a, b = map(tuple, record["sequences"])
    assert sum(a) == sum(b) == 1
    assert sum(x * x for x in a + b) == record["joint_squared_norm"]
    joint = tuple(x + y for x, y in zip(correlations(a), correlations(b)))
    assert joint == (target,) * (len(a) - 1)
    assert list(joint) == record["joint_paf_nonzero_shifts"]
    assert record["status"] == "FEASIBLE_COMPRESSION_ONLY"


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {Path(sys.argv[0]).name} CERTIFICATE.json")
    data = json.loads(Path(sys.argv[1]).read_text())
    assert data["schema"] == "c741-lp333-ids4-5-compression-checkpoint-v2"

    ledgers = []
    pair_sets = []
    for case in data["cases"]:
        group = generated(case["generators"][0])
        assert list(group) == case["group"]
        full_orbits = partition(group, N)
        assert len(full_orbits) == case["full_orbit_count"] == 113
        assert {str(k): v for k, v in sorted(Counter(map(len, full_orbits)).items())} == case[
            "full_orbit_size_counts"
        ]
        assert sorted(orbit[0] for orbit in full_orbits if len(orbit) == 1) == [0, 111, 222]
        assert sorted({g % 9 for g in group}) == case["image_mod_9"] == [1, 4, 7]
        assert sorted({g % 37 for g in group}) == case["image_mod_37"] == [1, 10, 26]
        ledger, pairs = enumerate_compressions(group)
        ledgers.append(ledger)
        pair_sets.append(pairs)
    assert ledgers[0] == ledgers[1] == data["common_9_compression_ledger"]
    assert pair_sets[0] == pair_sets[1]
    assert len(pair_sets[0]) == data["row_sum_positive_pair_count"] == 648
    assert len({canonical(pair) for pair in pair_sets[0]}) == data[
        "affine_decimation_translation_swap_representatives"
    ] == 108
    assert data["signed_zero_normalized_branch_count_before_affine_reduction"] == 2592

    lemma = data["fixed_point_lemma"]
    assert lemma["singleton_positions"] == [0, 111, 222]
    # A positive row has 166 minus signs.  Every other orbit has size three,
    # so its singleton contribution is 166 mod 3, hence exactly one of 0..3.
    assert 166 % 3 == lemma["minus_signs_per_positive_row_on_singletons"] == 1
    assert lemma["normalized_relative_cases"] == ["same", "different"]
    oriented = set(pair_sets[0]) | {(b, a) for a, b in pair_sets[0]}
    assert len(oriented) == lemma["oriented_positive_compression_pairs"] == 1296
    fixed_counts = {
        case: len({fixed_canonical(pair, case) for pair in oriented})
        for case in ("same", "different")
    }
    assert fixed_counts == lemma["stabilizer_representatives"] == {
        "same": 324,
        "different": 648,
    }
    assert lemma["recovery_rule"] == (
        "for r in {0,3,6}, compressed_value[r] == singleton_sign[r] (mod 6)"
    )
    global_reps = {canonical(pair) for pair in pair_sets[0]}
    geometry = Counter(
        "same" if compression_mark(a) == compression_mark(b) else "different"
        for a, b in global_reps
    )
    assert dict(geometry) == lemma["global_108_geometry_counts"] == {
        "same": 36,
        "different": 72,
    }

    screen = data["shift_111_compression_screen"]
    assert screen["required_joint_mixed_triples"] == 167
    summary = Counter()
    feasible_count = 0
    for a,b in global_reps:
        possible_a = replay_shift_111_counts(a)
        possible_b = replay_shift_111_counts(b)
        feasible = any(167-x in possible_b for x in possible_a)
        summary[(len(possible_a),len(possible_b),feasible)] += 1
        feasible_count += feasible
    replay_summary = [
        {
            "row_a_possible_count_size": key[0],
            "row_b_possible_count_size": key[1],
            "feasible": key[2],
            "representatives": count,
        }
        for key,count in sorted(summary.items())
    ]
    assert replay_summary == screen["summary"]
    assert feasible_count == screen["feasible_representatives"] == 108
    assert screen["conclusion"] == "NO_EXCLUSION"

    check_witness(data["positive_control_9"], -74)
    check_witness(data["positive_control_37"], -18)
    assert data["exact_lift_status"] == "OPEN"
    assert data["conclusion"] == "both separate quotient compressions are feasible; neither ID is decided"
    print("PASS: independent quotient census, fixed geometry, shift-111 screen, and controls")


if __name__ == "__main__":
    main()
