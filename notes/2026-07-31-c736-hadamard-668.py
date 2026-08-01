#!/usr/bin/env python3
"""Exact compression audit for the nine residual LP(333) multiplier cases.

The subgroup generators are the stable ids in Ramos--Hulak--de Queiroz,
arXiv:2607.20765v1, Table A1.  This program independently reconstructs each
subgroup and its action on Z/333Z.  For d in {9,37}, it enumerates every
compressed sequence allowed by that action, row sum +1, and the forced joint
squared-norm bound.  It then decides whether two such compressed sequences can
have complementary periodic autocorrelation at every nonzero shift.

An INFEASIBLE result is a proof for the original multiplier case.  A FEASIBLE
result only supplies a witness to the compression relaxation.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import defaultdict
from pathlib import Path

L = 333
OPEN_GENERATORS = {
    0: (1,),
    1: (73,),
    2: (112,),
    3: (10,),
    4: (121,),
    5: (211,),
    7: (73, 112),
    9: (73, 85),
    10: (73, 121),
}
EXPECTED_ORDERS = {0: 1, 1: 2, 2: 3, 3: 3, 4: 3, 5: 3, 7: 6, 9: 6, 10: 6}


def closure(generators: tuple[int, ...]) -> tuple[int, ...]:
    group = {1}
    changed = True
    while changed:
        changed = False
        for x in tuple(group):
            for g in generators:
                y = x * g % L
                if y not in group:
                    group.add(y)
                    changed = True
    return tuple(sorted(group))


def action_orbits(points: list[int], multipliers: tuple[int, ...], modulus: int) -> list[list[int]]:
    remaining = set(points)
    ans = []
    while remaining:
        seed = min(remaining)
        orbit = {seed}
        frontier = [seed]
        while frontier:
            x = frontier.pop()
            for h in multipliers:
                y = h * x % modulus
                if y not in orbit:
                    orbit.add(y)
                    frontier.append(y)
        ans.append(sorted(orbit))
        remaining -= orbit
    return ans


def value_set(sizes: list[int]) -> tuple[int, ...]:
    reachable = {0}
    for size in sizes:
        reachable = {x + size for x in reachable} | {x - size for x in reachable}
    return tuple(sorted(reachable))


def compressed_variables(group: tuple[int, ...], d: int) -> list[dict]:
    """Return exact variables for H-allowed d-compressions.

    One variable represents an orbit of compressed positions.  Its domain is
    the exact signed-orbit-sum value set in a representative fibre.
    """
    image = tuple(sorted({h % d for h in group}))
    position_orbits = action_orbits(list(range(d)), image, d)
    variables = []
    for positions in position_orbits:
        representative = positions[0]
        stabilizer = tuple(h for h in group if h * representative % d == representative)
        fibre = [x for x in range(L) if x % d == representative]
        fibre_orbits = action_orbits(fibre, stabilizer, L)
        variables.append(
            {
                "positions": positions,
                "weight": len(positions),
                "fibre_orbit_sizes": sorted(map(len, fibre_orbits)),
                "values": value_set(sorted(map(len, fibre_orbits))),
            }
        )
    return variables


def paf(sequence: tuple[int, ...]) -> tuple[int, ...]:
    n = len(sequence)
    return tuple(sum(sequence[j] * sequence[(j + s) % n] for j in range(n)) for s in range(1, n))


def enumerate_sequences(variables: list[dict], d: int, joint_norm: int):
    """Enumerate canonical compressed sequences of row sum +1.

    The last variable is derived from the row-sum equation, reducing the raw
    Cartesian product by one dimension.  Global negation justifies fixing +1.
    """
    # Derive a variable with a large domain; membership is cheaper than looping it.
    last_index = max(range(len(variables)), key=lambda i: len(variables[i]["values"]))
    ordered = [v for i, v in enumerate(variables) if i != last_index] + [variables[last_index]]
    last = ordered[-1]
    last_values = set(last["values"])
    out = {}
    visited = 0
    accepted = 0
    for prefix in itertools.product(*(v["values"] for v in ordered[:-1])):
        visited += 1
        partial_sum = sum(v["weight"] * x for v, x in zip(ordered[:-1], prefix))
        numerator = 1 - partial_sum
        if numerator % last["weight"]:
            continue
        final = numerator // last["weight"]
        if final not in last_values:
            continue
        values = prefix + (final,)
        norm = sum(v["weight"] * x * x for v, x in zip(ordered, values))
        if norm > joint_norm:
            continue
        sequence = [0] * d
        for var, x in zip(ordered, values):
            for position in var["positions"]:
                sequence[position] = x
        sequence_t = tuple(sequence)
        key = (norm, paf(sequence_t))
        out.setdefault(key, sequence_t)
        accepted += 1
    return out, visited, accepted


def decide(group: tuple[int, ...], d: int) -> dict:
    m = L // d
    target_paf = -2 * m
    joint_norm = 2 - (d - 1) * target_paf
    variables = compressed_variables(group, d)
    # The bounded enumerator is intended only for at most seven quotient variables.
    raw_prefixes = 1
    last_index = max(range(len(variables)), key=lambda i: len(variables[i]["values"]))
    for i, variable in enumerate(variables):
        if i != last_index:
            raw_prefixes *= len(variable["values"])
    if raw_prefixes > 12_000_000:
        return {
            "d": d,
            "status": "SKIPPED",
            "reason": "exact prefix domain exceeds deterministic 12,000,000-state budget",
            "variables": variables,
            "raw_prefixes": raw_prefixes,
            "target_paf": target_paf,
            "joint_norm": joint_norm,
        }
    profiles, visited, accepted = enumerate_sequences(variables, d, joint_norm)
    witness = None
    for (norm, profile), sequence in profiles.items():
        needed = (joint_norm - norm, tuple(target_paf - x for x in profile))
        other = profiles.get(needed)
        if other is not None:
            witness = [list(sequence), list(other)]
            break
    return {
        "d": d,
        "status": "FEASIBLE" if witness else "INFEASIBLE",
        "variables": variables,
        "raw_prefixes": visited,
        "accepted_sequences": accepted,
        "distinct_norm_paf_profiles": len(profiles),
        "target_paf": target_paf,
        "joint_norm": joint_norm,
        "witness": witness,
        "profile_ledger": (
            [[norm, list(profile)] for norm, profile in sorted(profiles)]
            if witness is None
            else None
        ),
    }


def build_certificate() -> dict:
    cases = []
    for stable_id, generators in OPEN_GENERATORS.items():
        group = closure(generators)
        assert len(group) == EXPECTED_ORDERS[stable_id]
        decisions = [decide(group, 9), decide(group, 37)]
        cases.append(
            {
                "id": stable_id,
                "generators": list(generators),
                "group": list(group),
                "order": len(group),
                "compressions": decisions,
                "analytic_obstruction": (
                    {
                        "kind": "mod-8 PAF contradiction in the 9-compression",
                        "fixed_position_values_mod_12": [1, 11],
                        "normalized_row_sum": 1,
                        "forced_paf_mod_8": 5,
                        "pair_paf_mod_8": 2,
                        "required_pair_paf": -74,
                        "required_pair_paf_mod_8": 6,
                    }
                    if stable_id in (9, 10)
                    else None
                ),
            }
        )
    return {
        "schema": "c736-lp333-residual-compression-v1",
        "length": L,
        "row_sum_normalization": 1,
        "scope": "necessary compressed systems for the nine open fixed common-multiplier cases",
        "cases": cases,
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if bool(args.output) == bool(args.check):
        parser.error("choose exactly one of --output or --check")
    data = build_certificate()
    encoded = canonical_bytes(data)
    if args.output:
        args.output.write_bytes(encoded)
        print(f"wrote {args.output} sha256={hashlib.sha256(encoded).hexdigest()}")
    else:
        expected = args.check.read_bytes()
        if encoded != expected:
            raise SystemExit("FAIL: regenerated certificate differs")
        print(f"PASS sha256={hashlib.sha256(encoded).hexdigest()}")
    for case in data["cases"]:
        summary = ", ".join(f"d={x['d']}:{x['status']}" for x in case["compressions"])
        print(f"id{case['id']} order={case['order']} {summary}")


if __name__ == "__main__":
    main()
