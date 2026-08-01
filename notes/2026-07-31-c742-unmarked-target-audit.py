#!/usr/bin/env python3
"""Exact C742 audit of the source-free six-cell product target."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


VERTICES = tuple(range(6))
EDGES = frozenset(itertools.combinations(VERTICES, 2))
OUTPUT = Path(__file__).with_name("2026-07-31-c742-unmarked-target-audit.json")


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


SYNTHEMES = tuple(sorted(set(perfect_matchings(VERTICES)), key=repr))
TOTALS = tuple(
    frozenset(chosen)
    for chosen in itertools.combinations(SYNTHEMES, 5)
    if frozenset().union(*chosen) == EDGES
    and sum(len(syntheme) for syntheme in chosen) == len(EDGES)
)
assert len(SYNTHEMES) == 15 and len(TOTALS) == 6


def compose(left, right):
    return tuple(left[right[i]] for i in VERTICES)


def parity(permutation):
    inversions = sum(
        permutation[i] > permutation[j]
        for i in VERTICES
        for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def act_edge(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def act_total(permutation, total):
    return frozenset(
        frozenset(act_edge(permutation, edge) for edge in syntheme)
        for syntheme in total
    )


def fixed_axes(permutation):
    return sum(permutation[i] == i for i in VERTICES)


def fixed_totals(permutation):
    return sum(act_total(permutation, total) == total for total in TOTALS)


def square(permutation):
    return compose(permutation, permutation)


def wedge_two_axis_character(permutation):
    fixed = fixed_axes(permutation)
    return (fixed * fixed - fixed_axes(square(permutation))) // 2


def inner_product(left, right):
    value = Fraction(
        sum(left(p) * right(p) for p in itertools.permutations(VERTICES)),
        math.factorial(6),
    )
    assert value.denominator == 1
    return value.numerator


def compute():
    axis_augmentation = lambda p: fixed_axes(p) - 1
    product_target = lambda p: fixed_totals(p) * wedge_two_axis_character(p)
    signed_product_target = lambda p: parity(p) * product_target(p)
    result = {
        "schema": "c742-unmarked-target-audit-v1",
        "group_order": math.factorial(6),
        "outer_cells": len(TOTALS),
        "skew_coordinates_per_cell": len(EDGES),
        "multiplicities": {
            "Hom_S6(axis_augmentation,product_target)": inner_product(
                axis_augmentation, product_target
            ),
            "Hom_S6(axis_augmentation,signed_product_target)": inner_product(
                axis_augmentation, signed_product_target
            ),
        },
        "unique_untwisted_lift": {
            "formula": "alpha_ij(x)=x_i-x_j, repeated in every outer cell",
            "matrix_rank_upper_bound": 2,
            "order_six_pfaffian": 0,
        },
        "interpretation": (
            "The source-free signed product target admits no synchronized "
            "linear lift.  The untwisted product target admits one, but its "
            "top Pfaffian vanishes."
        ),
    }
    assert result["multiplicities"] == {
        "Hom_S6(axis_augmentation,product_target)": 1,
        "Hom_S6(axis_augmentation,signed_product_target)": 0,
    }
    return result


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(compute())
    if args.check:
        assert OUTPUT.read_bytes() == payload
    else:
        OUTPUT.write_bytes(payload)
    print(
        "unmarked target audit: OK",
        hashlib.sha256(payload).hexdigest(),
        len(payload),
    )


if __name__ == "__main__":
    main()
