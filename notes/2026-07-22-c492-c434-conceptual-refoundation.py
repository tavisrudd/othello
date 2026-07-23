#!/usr/bin/env python3
"""Exact small-group certificate for the C492 six-stratum proof."""

from __future__ import annotations

import argparse
import itertools
import json
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-22-c492-c434-conceptual-refoundation.json"

Perm = tuple[int, ...]


def compose(a: Perm, b: Perm) -> Perm:
    return tuple(a[b[i]] for i in range(len(a)))


def inverse(a: Perm) -> Perm:
    out = [0] * len(a)
    for i, x in enumerate(a):
        out[x] = i
    return tuple(out)


def even(a: Perm) -> bool:
    inversions = sum(a[i] > a[j] for i in range(len(a)) for j in range(i + 1, len(a)))
    return inversions % 2 == 0


def generated(generators: list[Perm]) -> frozenset[Perm]:
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    steps = generators + [inverse(g) for g in generators]
    while frontier:
        x = frontier.pop()
        for g in steps:
            y = compose(g, x)
            if y not in group:
                group.add(y)
                frontier.append(y)
    return frozenset(group)


def cyclic(generator: Perm) -> frozenset[Perm]:
    return generated([generator])


def conjugate_subgroup(g: Perm, subgroup: frozenset[Perm]) -> frozenset[Perm]:
    gi = inverse(g)
    return frozenset(compose(compose(g, x), gi) for x in subgroup)


def normalizer(group: frozenset[Perm], subgroup: frozenset[Perm]) -> frozenset[Perm]:
    return frozenset(g for g in group if conjugate_subgroup(g, subgroup) == subgroup)


def left_cosets(group: frozenset[Perm], subgroup: frozenset[Perm]) -> list[frozenset[Perm]]:
    unseen = set(group)
    result = []
    while unseen:
        h = min(unseen)
        coset = frozenset(compose(h, s) for s in subgroup)
        result.append(coset)
        unseen -= coset
    return sorted(result, key=lambda c: min(c))


def orbit_sizes_on_cosets(
    acting: frozenset[Perm], group: frozenset[Perm], stabilizer: frozenset[Perm]
) -> list[int]:
    cosets = left_cosets(group, stabilizer)
    lookup = {element: i for i, coset in enumerate(cosets) for element in coset}
    unseen = set(range(len(cosets)))
    sizes = []
    while unseen:
        seed = min(unseen)
        representative = min(cosets[seed])
        orbit = {lookup[compose(k, representative)] for k in acting}
        sizes.append(len(orbit))
        unseen -= orbit
    return sorted(sizes)


def product_is_group(
    left: frozenset[Perm], right: frozenset[Perm], group: frozenset[Perm]
) -> bool:
    return {compose(a, b) for a in left for b in right} == set(group)


def case_record(
    *,
    name: str,
    group: frozenset[Perm],
    own_stabilizer: frozenset[Perm],
    types: list[tuple[str, frozenset[Perm], str]],
) -> dict:
    records = []
    for i, (kind, k, borel_model) in enumerate(types):
        other_kind, other, _ = types[1 - i]
        own_leg = orbit_sizes_on_cosets(k, group, own_stabilizer)
        same_leg = orbit_sizes_on_cosets(k, group, k)
        cross_leg = orbit_sizes_on_cosets(k, group, other)
        own_sheet = sorted([1, *own_leg])
        opposite_sheet = sorted([*same_leg, *cross_leg])
        records.append(
            {
                "K_type": kind,
                "K_order": len(k),
                "borel_model": borel_model,
                "cross_type": other_kind,
                "own_stabilizer_order": len(own_stabilizer),
                "own_leg_double_cosets": len(own_leg),
                "own_leg_orbit_sizes": own_leg,
                "same_type_bruhat_double_cosets": len(same_leg),
                "same_type_orbit_sizes": same_leg,
                "cross_type_double_cosets": len(cross_leg),
                "cross_type_orbit_sizes": cross_leg,
                "exact_factorization": product_is_group(k, other, group),
                "cross_intersection_order": len(k & other),
                "own_sheet_K_orbits": own_sheet,
                "opposite_sheet_K_orbits": opposite_sheet,
                "orbits_per_sheet": [len(own_sheet), len(opposite_sheet)],
                "total_strata": len(own_sheet) + len(opposite_sheet),
            }
        )
    return {
        "H": name,
        "H_order": len(group),
        "own_transitive_orbit_size": len(group) // len(own_stabilizer),
        "opposite_component_sizes": [len(group) // len(x[1]) for x in types],
        "golden_pair_types": records,
    }


def build_certificate() -> dict:
    s4 = frozenset(itertools.permutations(range(4)))
    s3_in_s4 = frozenset(g for g in s4 if g[3] == 3)
    r4 = (1, 2, 3, 0)
    reflection = (0, 3, 2, 1)
    d8 = generated([r4, reflection])
    edge_stabilizer = frozenset(g for g in s4 if {g[0], g[1]} == {0, 1})

    a5 = frozenset(g for g in itertools.permutations(range(5)) if even(g))
    a4 = frozenset(g for g in a5 if g[4] == 4)
    d10 = normalizer(a5, cyclic((1, 2, 3, 4, 0)))
    s3_in_a5 = normalizer(a5, cyclic((1, 2, 0, 3, 4)))

    cases = [
        case_record(
            name="S4",
            group=s4,
            own_stabilizer=edge_stabilizer,
            types=[
                ("D8", d8, "pullback of B(PGL2(2))"),
                ("S3", s3_in_s4, "B(PGL2(3))"),
            ],
        ),
        case_record(
            name="A5",
            group=a5,
            own_stabilizer=s3_in_a5,
            types=[
                ("A4", a4, "B(PSL2(4))"),
                ("D10", d10, "B(PSL2(5))"),
            ],
        ),
    ]
    assertions = {
        "all_total_strata_six": all(
            t["total_strata"] == 6 for c in cases for t in c["golden_pair_types"]
        ),
        "all_three_orbits_per_sheet": all(
            t["orbits_per_sheet"] == [3, 3]
            for c in cases
            for t in c["golden_pair_types"]
        ),
        "all_same_type_rank_one_bruhat": all(
            t["same_type_bruhat_double_cosets"] == 2
            for c in cases
            for t in c["golden_pair_types"]
        ),
        "all_cross_types_transverse": all(
            t["cross_type_double_cosets"] == 1
            and t["exact_factorization"]
            and t["cross_intersection_order"] == 2
            for c in cases
            for t in c["golden_pair_types"]
        ),
        "all_own_legs_rank_two": all(
            t["own_leg_double_cosets"] == 2 for c in cases for t in c["golden_pair_types"]
        ),
    }
    if not all(assertions.values()):
        raise AssertionError(assertions)
    return {
        "schema": "c492-c434-conceptual-refoundation-v1",
        "scope": (
            "Exact A5/S4 double-coset tables underlying the abstract two-sheet theorem; "
            "the ambient finite-geometric realization and Dickson exhaustion are not recomputed."
        ),
        "cases": cases,
        "assertions": assertions,
    }


def canonical_bytes(certificate: dict) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(expected)
        print(f"wrote {OUTPUT.name}")
        return
    with tempfile.TemporaryDirectory() as _:
        actual = OUTPUT.read_bytes()
        if actual != expected:
            raise SystemExit(f"{OUTPUT.name} is stale; run with --write")
    print("PASS: C492 exact small-group certificate matches")


if __name__ == "__main__":
    main()
