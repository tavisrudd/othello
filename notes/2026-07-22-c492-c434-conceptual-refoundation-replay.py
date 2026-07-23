#!/usr/bin/env python3
"""Independent double-coset replay for the C492 certificate."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-22-c492-c434-conceptual-refoundation.json"


def mul(a, b):
    return tuple(a[b[i]] for i in range(len(a)))


def inv(a):
    return tuple(a.index(i) for i in range(len(a)))


def parity(a):
    return sum(a[i] > a[j] for i in range(len(a)) for j in range(i + 1, len(a))) % 2


def closure(gens):
    identity = tuple(range(len(gens[0])))
    out = {identity}
    while True:
        enlarged = out | {mul(g, h) for g in gens for h in out}
        if enlarged == out:
            return frozenset(out)
        out = enlarged


def normalizer(group, subgroup):
    return frozenset(
        g
        for g in group
        if {mul(mul(g, s), inv(g)) for s in subgroup} == set(subgroup)
    )


def double_coset_sizes(group, left, right):
    unseen = set(group)
    result = []
    while unseen:
        h = min(unseen)
        block = {mul(mul(k, h), s) for k in left for s in right}
        result.append(len(block) // len(right))
        unseen -= block
    return sorted(result)


def verify_case(group, own, types, expected):
    by_name = {x["K_type"]: x for x in expected["golden_pair_types"]}
    for name, k in types:
        other_name, other = next(x for x in types if x[0] != name)
        got = {
            "own": double_coset_sizes(group, k, own),
            "same": double_coset_sizes(group, k, k),
            "cross": double_coset_sizes(group, k, other),
        }
        row = by_name[name]
        assert got["own"] == row["own_leg_orbit_sizes"]
        assert got["same"] == row["same_type_orbit_sizes"]
        assert got["cross"] == row["cross_type_orbit_sizes"]
        assert len(got["own"]) == 2
        assert len(got["same"]) == 2
        assert len(got["cross"]) == 1
        assert {mul(k0, s0) for k0 in k for s0 in other} == set(group)
        assert len(k & other) == row["cross_intersection_order"] == 2
        assert other_name == row["cross_type"]


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    expected = {case["H"]: case for case in certificate["cases"]}

    s4 = frozenset(itertools.permutations(range(4)))
    s3_4 = frozenset(g for g in s4 if g[3] == 3)
    d8 = closure([(1, 2, 3, 0), (0, 3, 2, 1)])
    own4 = frozenset(g for g in s4 if {g[0], g[1]} == {0, 1})
    verify_case(s4, own4, [("D8", d8), ("S3", s3_4)], expected["S4"])

    a5 = frozenset(g for g in itertools.permutations(range(5)) if parity(g) == 0)
    a4 = frozenset(g for g in a5 if g[4] == 4)
    c5 = closure([(1, 2, 3, 4, 0)])
    d10 = normalizer(a5, c5)
    c3 = closure([(1, 2, 0, 3, 4)])
    s3_5 = normalizer(a5, c3)
    verify_case(a5, s3_5, [("A4", a4), ("D10", d10)], expected["A5"])
    print("PASS: independent double-coset replay agrees with C492 certificate")


if __name__ == "__main__":
    main()
