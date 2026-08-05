#!/usr/bin/env python3
"""Why the E8 root-pair coordinates cannot carry a distance-five quantum code.

The Eisenstein structure gives E8/2E8 = F4^4 canonically, so the F4 alphabet the
Hermitian construction wants is free.  This checker shows the natural F4 codes on
the 120 root-pair coordinates are Hermitian self-orthogonal but still stall at dual
distance four, identifies the mechanism (every additive column map inherits the
32130 additive tetrads as weight-four dual words), tests the natural non-additive
enrichments and finds they only create weight-three dependencies, and records the
rank-three module structure that leaves no other invariant code to try.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from functools import reduce
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c868-eisenstein-hermitian-hunt.json"
LADDER_SOURCE = HERE / "2026-08-05-c867-ladder-record-attack.py"

ADD_TABLE = {
    (0, 0): 0, (0, 1): 1, (0, 2): 2, (0, 3): 3,
    (1, 1): 0, (1, 2): 3, (1, 3): 2,
    (2, 2): 0, (2, 3): 1,
    (3, 3): 0,
}
NONZERO = (1, 2, 3)


def field_add(left, right):
    return ADD_TABLE[(min(left, right), max(left, right))]


def field_mul(left, right):
    if left == 0 or right == 0:
        return 0
    return ((left - 1) + (right - 1)) % 3 + 1


def conjugate(value):
    return field_mul(value, value)


def vector_add(left, right):
    return tuple(field_add(a, b) for a, b in zip(left, right))


def vector_scale(scalar, vector):
    return tuple(field_mul(scalar, entry) for entry in vector)


def eisenstein_points():
    points = [
        vector
        for vector in itertools.product(range(4), repeat=4)
        if sum(1 for entry in vector if entry) % 2 == 1
    ]
    assert len(points) == 120
    return points


def columns(points, functions):
    return [tuple([1] + [function(point) for function in functions]) for point in points]


def hermitian_self_orthogonal(table):
    width = len(table[0])
    for left in range(width):
        for right in range(width):
            total = 0
            for column in table:
                total = field_add(
                    total, field_mul(column[left], conjugate(column[right]))
                )
            if total:
                return False
    return True


def minimum_dependent_columns(table):
    """Smallest number of F4-linearly dependent columns, searched up to four."""
    size = len(table)
    for i in range(size):
        for j in range(i + 1, size):
            for scalar in NONZERO:
                if vector_scale(scalar, table[j]) == table[i]:
                    return 2
    pairs = defaultdict(list)
    for i in range(size):
        for j in range(i + 1, size):
            for left in NONZERO:
                scaled = vector_scale(left, table[i])
                for right in NONZERO:
                    pairs[vector_add(scaled, vector_scale(right, table[j]))].append(
                        (i, j)
                    )
    for k in range(size):
        for scalar in NONZERO:
            for i, j in pairs.get(vector_scale(scalar, table[k]), ()):
                if k not in (i, j):
                    return 3
    for entries in pairs.values():
        if len(entries) < 2:
            continue
        for x in range(len(entries)):
            for y in range(x + 1, len(entries)):
                if not set(entries[x]) & set(entries[y]):
                    return 4
    return 5  # ">= 5"; the search is exact only up to four


def additive_tetrads(points):
    present = set(points)
    ordered = sorted(points)
    total = 0
    witness = None
    for i in range(len(ordered)):
        for j in range(i + 1, len(ordered)):
            partial = vector_add(ordered[i], ordered[j])
            for k in range(j + 1, len(ordered)):
                rest = vector_add(partial, ordered[k])
                if rest in present and rest > ordered[k]:
                    total += 1
                    if witness is None:
                        witness = (ordered[i], ordered[j], ordered[k], rest)
    return total, witness


# ------------------------------------------------- rank-three module structure


def parity(value):
    return value.bit_count() & 1


def binary_points():
    return [v for v in range(256) if parity((v & 15) & (v >> 4)) == 1]


def binary_bilinear(left, right):
    return parity((left & 15) & (right >> 4)) ^ parity((left >> 4) & (right & 15))


def matrix_rank(rows):
    pivots = {}
    rank = 0
    for row in rows:
        value = row
        for pivot in sorted(pivots, reverse=True):
            if (value >> pivot) & 1:
                value ^= pivots[pivot]
        if value:
            pivots[value.bit_length() - 1] = value
            rank += 1
    return rank


def module_structure():
    points = binary_points()
    size = len(points)
    index = {point: slot for slot, point in enumerate(points)}
    base = points[0]
    suborbits = Counter(
        (binary_bilinear(base, point), parity((base ^ point) & 15 & ((base ^ point) >> 4)))
        for point in points
        if point != base
    )
    adjacency = [
        sum(1 << index[other] for other in points if binary_bilinear(point, other) == 1)
        for point in points
    ]
    assert {row.bit_count() for row in adjacency} == {56}
    identity = [1 << slot for slot in range(size)]
    all_ones = [(1 << size) - 1] * size

    def combine(*matrices):
        return [
            reduce(lambda a, b: a ^ b, [matrix[slot] for matrix in matrices])
            for slot in range(size)
        ]

    return {
        "rank_three_suborbits": sorted([1] + sorted(suborbits.values(), reverse=True), reverse=True),
        "valency": 56,
        "rank_A": matrix_rank(adjacency),
        "rank_A_plus_I": matrix_rank(combine(adjacency, identity)),
        "rank_A_plus_J": matrix_rank(combine(adjacency, all_ones)),
        "rank_J": matrix_rank(all_ones),
    }


# ------------------------------------------------------------- certificate


def certificate():
    points = eisenstein_points()
    linear = [(lambda v, i=i: v[i]) for i in range(4)]
    hermitian = [(lambda v, i=i: conjugate(v[i])) for i in range(4)]
    products = [
        (lambda v, i=i, j=j: field_mul(v[i], v[j]))
        for i in range(4)
        for j in range(i + 1, 4)
    ]
    mixed = [
        (lambda v, i=i, j=j: field_mul(v[i], conjugate(v[j])))
        for i in range(4)
        for j in range(4)
        if i != j
    ]

    families = {
        "constants + F4-linear + Hermitian (additive)": linear + hermitian,
        "constants + F4-linear + products": linear + products,
        "constants + F4-linear + Hermitian + products": linear + hermitian + products,
        "constants + F4-linear + mixed products": linear + mixed,
        "constants + F4-linear + Hermitian + mixed products": linear + hermitian + mixed,
    }
    results = {}
    for name, functions in families.items():
        table = columns(points, functions)
        dimension = len(table[0])
        results[name] = {
            "f4_dimension": dimension,
            "hermitian_self_orthogonal": hermitian_self_orthogonal(table),
            "minimum_dependent_columns": minimum_dependent_columns(table),
            "quantum_parameters": [120, 120 - 2 * dimension],
        }
    principal = results["constants + F4-linear + Hermitian (additive)"]
    assert principal["f4_dimension"] == 9
    assert principal["hermitian_self_orthogonal"] is True
    assert principal["minimum_dependent_columns"] == 4
    assert principal["quantum_parameters"] == [120, 102]
    assert all(entry["hermitian_self_orthogonal"] for entry in results.values())
    assert min(entry["minimum_dependent_columns"] for entry in results.values()) == 3
    assert max(entry["minimum_dependent_columns"] for entry in results.values()) == 4

    tetrad_count, witness = additive_tetrads(points)
    assert tetrad_count == 32130
    assert vector_add(vector_add(witness[0], witness[1]), vector_add(witness[2], witness[3])) == (
        0, 0, 0, 0
    )

    return {
        "carrier": (
            "the 120 nonsingular vectors of E8/2E8 = F4^4, Q(v) the parity of the "
            "F4-weight; see 2026-08-05-c867-ladder-record-attack.py"
        ),
        "families": results,
        "additive_obstruction": {
            "tetrads": tetrad_count,
            "witness": [list(vector) for vector in witness],
            "statement": (
                "conjugation and every F4-linear functional are additive, so any code "
                "whose column map is additive plus a constant sends each of the 32130 "
                "tetrads u+v+w+x=0 to a weight-four dependency; its Hermitian dual "
                "distance is therefore exactly four, independently of the alphabet"
            ),
        },
        "module_structure": module_structure(),
        "verdict": (
            "the Eisenstein F4 alphabet does not by itself reach dual distance five; "
            "distance five on these coordinates requires a non-additive column map, "
            "and every natural equivariant non-additive enrichment tested here "
            "introduces weight-three dependencies instead"
        ),
        "input_sha256": {
            LADDER_SOURCE.name: hashlib.sha256(LADDER_SOURCE.read_bytes()).hexdigest()
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.write:
        OUTPUT.write_text(payload)
    if args.check:
        assert OUTPUT.read_text() == payload
    if not args.write and not args.check:
        print(payload, end="")


if __name__ == "__main__":
    main()
