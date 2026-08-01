#!/usr/bin/env python3
"""Exact S_6 incidence certificate for the C739 36-to-6 quotient."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-31-c739-cycle-audit.json"
X = tuple(range(6))
IDENTITY = X
GROUP = tuple(itertools.permutations(X))
EDGES = frozenset(itertools.combinations(X, 2))


def compose(left, right):
    return tuple(left[right[i]] for i in X)


def inverse(permutation):
    result = [0] * 6
    for i, image in enumerate(permutation):
        result[image] = i
    return tuple(result)


def power(permutation, exponent):
    result = IDENTITY
    for _ in range(exponent):
        result = compose(permutation, result)
    return result


def perfect_matchings(vertices):
    if not vertices:
        yield frozenset()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for tail in perfect_matchings(rest):
            yield tail | {tuple(sorted((first, second)))}


SYNTHEMES = tuple(sorted(set(perfect_matchings(X)), key=repr))
TOTALS = tuple(
    frozenset(chosen)
    for chosen in itertools.combinations(SYNTHEMES, 5)
    if frozenset().union(*chosen) == EDGES
    and sum(len(syntheme) for syntheme in chosen) == len(EDGES)
)


def act_edge(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def act_total(permutation, total):
    return frozenset(
        frozenset(act_edge(permutation, edge) for edge in syntheme)
        for syntheme in total
    )


def order(permutation):
    result = IDENTITY
    for exponent in range(1, 7):
        result = compose(permutation, result)
        if result == IDENTITY:
            return exponent
    raise AssertionError(permutation)


def cyclic_subgroup(generator):
    return frozenset(power(generator, exponent) for exponent in range(5))


SYLOW5 = tuple(
    sorted(
        {cyclic_subgroup(g) for g in GROUP if order(g) == 5},
        key=lambda subgroup: repr(sorted(subgroup)),
    )
)


def normalizes(permutation, subgroup):
    inv = inverse(permutation)
    return frozenset(compose(compose(permutation, h), inv) for h in subgroup) == subgroup


def fixed_axis(subgroup):
    fixed = [axis for axis in X if all(h[axis] == axis for h in subgroup)]
    assert len(fixed) == 1
    return fixed[0]


def fixed_outer_total(subgroup):
    fixed = [total for total in TOTALS if all(act_total(h, total) == total for h in subgroup)]
    assert len(fixed) == 1
    return TOTALS.index(fixed[0])


def compute():
    assert len(GROUP) == 720
    assert len(SYNTHEMES) == 15
    assert len(TOTALS) == 6
    assert len(SYLOW5) == 36
    normalizer_sizes = {
        sum(normalizes(g, subgroup) for g in GROUP) for subgroup in SYLOW5
    }
    pairs = [(fixed_axis(subgroup), fixed_outer_total(subgroup)) for subgroup in SYLOW5]
    assert normalizer_sizes == {20}
    assert len(set(pairs)) == 36
    assert set(pairs) == set(itertools.product(range(6), repeat=2))
    axis_fibres = [sum(axis == a for axis, _total in pairs) for a in range(6)]
    outer_fibres = [sum(total == t for _axis, total in pairs) for t in range(6)]
    return {
        "schema": "c739-cycle-audit-v1",
        "group_order": len(GROUP),
        "synthemes": len(SYNTHEMES),
        "synthematic_totals": len(TOTALS),
        "sylow_5_subgroups": len(SYLOW5),
        "normalizer_order": normalizer_sizes.pop(),
        "axis_projection_fibre_sizes": axis_fibres,
        "outer_projection_fibre_sizes": outer_fibres,
        "incidence_pairs": len(set(pairs)),
        "incidence_is_full_6_by_6_product": True,
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(compute())
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != generated:
            raise SystemExit("tracked cycle audit is stale")
        print("36-to-6 cycle audit: OK")
    else:
        OUTPUT.write_bytes(generated)
        print(OUTPUT)


if __name__ == "__main__":
    main()
