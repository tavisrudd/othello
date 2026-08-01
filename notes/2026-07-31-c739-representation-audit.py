#!/usr/bin/env python3
"""Exact low-degree character audit for C739 P1.

The computation uses the conjugacy classes of S_6.  It checks the class map
of the exceptional outer automorphism against power maps, constructs symmetric
power characters by Newton recursion, and takes exact character inner
products.  With --check it compares the canonical result to the tracked JSON.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-31-c739-representation-audit.json"

PARTITIONS = (
    (1, 1, 1, 1, 1, 1),
    (2, 1, 1, 1, 1),
    (2, 2, 1, 1),
    (2, 2, 2),
    (3, 1, 1, 1),
    (3, 2, 1),
    (3, 3),
    (4, 1, 1),
    (4, 2),
    (5, 1),
    (6,),
)

OUTER = {
    (1, 1, 1, 1, 1, 1): (1, 1, 1, 1, 1, 1),
    (2, 1, 1, 1, 1): (2, 2, 2),
    (2, 2, 1, 1): (2, 2, 1, 1),
    (2, 2, 2): (2, 1, 1, 1, 1),
    (3, 1, 1, 1): (3, 3),
    (3, 2, 1): (6,),
    (3, 3): (3, 1, 1, 1),
    (4, 1, 1): (4, 1, 1),
    (4, 2): (4, 2),
    (5, 1): (5, 1),
    (6,): (3, 2, 1),
}


def key(partition: tuple[int, ...]) -> str:
    return ".".join(map(str, partition))


def class_size(partition: tuple[int, ...]) -> int:
    counts = {r: partition.count(r) for r in set(partition)}
    centralizer = math.prod(r ** m * math.factorial(m) for r, m in counts.items())
    return math.factorial(6) // centralizer


def power_type(partition: tuple[int, ...], exponent: int) -> tuple[int, ...]:
    cycles: list[int] = []
    for r in partition:
        d = math.gcd(r, exponent)
        cycles.extend([r // d] * d)
    return tuple(sorted(cycles, reverse=True))


def sign(partition: tuple[int, ...]) -> int:
    return -1 if (6 - len(partition)) % 2 else 1


def standard(partition: tuple[int, ...]) -> int:
    return partition.count(1) - 1


def outer_standard(partition: tuple[int, ...]) -> int:
    return standard(OUTER[partition])


def signed_outer_standard(partition: tuple[int, ...]) -> int:
    return sign(partition) * outer_standard(partition)


def symmetric_power_character(base_character, partition, max_degree: int) -> list[int]:
    values = [1]
    for degree in range(1, max_degree + 1):
        numerator = sum(
            base_character(power_type(partition, exponent)) * values[degree - exponent]
            for exponent in range(1, degree + 1)
        )
        assert numerator % degree == 0
        values.append(numerator // degree)
    return values


def inner_product(character, target) -> int:
    value = sum(
        class_size(partition) * character(partition) * target(partition)
        for partition in PARTITIONS
    )
    quotient = Fraction(value, math.factorial(6))
    assert quotient.denominator == 1
    return quotient.numerator


def compute() -> dict:
    assert sum(class_size(partition) for partition in PARTITIONS) == math.factorial(6)
    assert set(OUTER) == set(PARTITIONS) == set(OUTER.values())
    for partition in PARTITIONS:
        assert OUTER[OUTER[partition]] == partition
        for exponent in range(1, 7):
            assert OUTER[power_type(partition, exponent)] == power_type(
                OUTER[partition], exponent
            )

    sym_axis = {
        partition: symmetric_power_character(standard, partition, 6)
        for partition in PARTITIONS
    }
    sym_signed_outer = {
        partition: symmetric_power_character(signed_outer_standard, partition, 6)
        for partition in PARTITIONS
    }

    def multiplicities(symmetry_table, target):
        return {
            str(degree): inner_product(
                lambda partition, d=degree: symmetry_table[partition][d], target
            )
            for degree in range(0, 7)
        }

    return {
        "schema": "c739-representation-audit-v1",
        "group_order": math.factorial(6),
        "outer_class_map": {key(p): key(OUTER[p]) for p in PARTITIONS},
        "multiplicities": {
            "Hom_S6(Sym^d(axis_augmentation),signed_outer_augmentation)": multiplicities(
                sym_axis, signed_outer_standard
            ),
            "Hom_S6(Sym^d(signed_outer_augmentation),trivial)": multiplicities(
                sym_signed_outer, lambda _partition: 1
            ),
            "Hom_S6(Sym^d(signed_outer_augmentation),sign)": multiplicities(
                sym_signed_outer, sign
            ),
            "Hom_S6(Sym^d(signed_outer_augmentation),outer_augmentation)": multiplicities(
                sym_signed_outer, outer_standard
            ),
            "Hom_S6(Sym^d(signed_outer_augmentation),signed_outer_augmentation)": multiplicities(
                sym_signed_outer, signed_outer_standard
            ),
        },
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(compute())
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != generated:
            raise SystemExit("tracked representation audit is stale")
        print("representation audit: OK")
    else:
        OUTPUT.write_bytes(generated)
        print(OUTPUT)


if __name__ == "__main__":
    main()
