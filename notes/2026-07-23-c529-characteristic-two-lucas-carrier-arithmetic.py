#!/usr/bin/env python3
"""Generate the C529 Lucas-carrier arithmetic certificate."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path


def nucleus_indices(degree: int, order: int) -> list[int]:
    """Coordinate indices in the order-th NRC nucleus in characteristic two."""
    return [
        i
        for i in range(degree + 1)
        if all(math.comb(row, i) % 2 == 0 for row in range(order + 1, degree + 1))
    ]


def overlap_indices(degree: int, nucleus: list[int]) -> list[int]:
    """Indices in degree+1 whose two contractions lie in the given nucleus."""
    support = set(nucleus)
    return [
        i
        for i in range(degree + 2)
        if (i == degree + 1 or i in support) and (i == 0 or i - 1 in support)
    ]


def cycles_of_doubling(modulus: int) -> list[list[int]]:
    unseen = set(range(modulus))
    cycles: list[list[int]] = []
    while unseen:
        start = min(unseen)
        cycle: list[int] = []
        value = start
        while value not in cycle:
            cycle.append(value)
            unseen.remove(value)
            value = (2 * value) % modulus
        cycles.append(cycle)
    return cycles


def multiplicative_order_two(modulus: int) -> int:
    value = 2 % modulus
    order = 1
    while value != 1:
        value = (2 * value) % modulus
        order += 1
    return order


def build_certificate() -> dict[str, object]:
    nonzero: list[dict[str, object]] = []
    for degree in range(2, 9):
        for order in range(degree):
            nucleus = nucleus_indices(degree, order)
            carrier = overlap_indices(degree, nucleus)
            if carrier:
                nonzero.append(
                    {
                        "lower_degree": degree,
                        "nucleus_order": order,
                        "nucleus_indices": nucleus,
                        "upper_degree": degree + 1,
                        "carrier_indices": carrier,
                        "carrier_vector_rank": len(carrier),
                    }
                )

    family: list[dict[str, object]] = []
    for level in range(2, 5):
        degree = 1 << level
        nucleus = nucleus_indices(degree, degree - 1)
        carrier = overlap_indices(degree, nucleus)
        modulus = degree - 1
        family.append(
            {
                "level": level,
                "lower_degree": degree,
                "upper_degree": degree + 1,
                "top_nucleus_indices": nucleus,
                "carrier_indices": carrier,
                "carrier_vector_rank": len(carrier),
                "carrier_common_kernel_indices": [0, degree],
                "distinguished_syndrome_index": degree - 1,
                "distinguished_kernel_net_indices": [0, 1, degree],
                "generic_geometric_monodromy": f"AGL(1,{degree})",
                "minimal_constant_field": f"F_{degree}",
                "geometric_component_count_over_F2": level,
                "coefficient_frobenius_on_components": f"one {level}-cycle",
                "based_component_group": f"C{modulus}",
                "frobenius_on_group": "a -> 2a",
                "frobenius_cycles": cycles_of_doubling(modulus),
                "frobenius_order": multiplicative_order_two(modulus),
                "split_extension_condition": f"{level} divides m",
            }
        )

    expected_nonzero = [
        (4, 3, [2, 3]),
        (5, 3, [3]),
        (5, 4, [3]),
        (8, 7, [2, 3, 4, 5, 6, 7]),
    ]
    actual_nonzero = [
        (entry["lower_degree"], entry["nucleus_order"], entry["carrier_indices"])
        for entry in nonzero
    ]
    assert actual_nonzero == expected_nonzero
    assert family[0]["frobenius_cycles"] == [[0], [1, 2]]
    assert family[1]["frobenius_cycles"] == [[0], [1, 2, 4], [3, 6, 5]]
    assert all(entry["frobenius_order"] == entry["level"] for entry in family)

    return {
        "schema": "c529-characteristic-two-lucas-carrier-arithmetic-v1",
        "coordinate_convention": (
            "e_i is the divided-power coordinate of index i; contraction uses "
            "the two consecutive coordinate rows"
        ),
        "nucleus_rule": (
            "i lies in N_{degree,order} iff binom(r,i)=0 mod 2 for every "
            "order < r <= degree"
        ),
        "nonzero_overlap_kernels_through_lower_degree_8": nonzero,
        "power_two_top_nucleus_family": family,
        "controls": {
            "C498": {
                "lower_degree": 4,
                "carrier_indices": [2, 3],
                "kernel_equals_common_net": True,
                "component_group": "C3",
                "constant_component_cycle_length": 2,
                "frobenius_order": 2,
                "deep_exactly_when": "m is odd",
            },
            "C509": {
                "upper_degree": 6,
                "iterated_carrier_indices": [3],
                "kernel_indices": [0, 1, 4, 5],
                "deep_exactly_when": "m is odd",
            },
        },
        "first_obstruction": {
            "lower_degree": 8,
            "upper_degree": 9,
            "carrier_indices": [2, 3, 4, 5, 6, 7],
            "distinguished_syndrome_index": 7,
            "universal_split_member": "t^8+t",
            "component_group": "C7",
            "geometric_monodromy": "AGL(1,8)",
            "minimal_constant_field": "F_8",
            "constant_component_cycle_length": 3,
            "frobenius_cycles": [[0], [1, 2, 4], [3, 6, 5]],
            "frobenius_order": 3,
            "conclusion": (
                "the PGL2 orbit of e_7 is shallow when 3 divides m; extension "
                "parity alone cannot control this level"
            ),
        },
    }


def serialized_certificate() -> str:
    return json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    content = serialized_certificate()
    if args.output is not None:
        args.output.write_text(content, encoding="utf-8")
    if args.check is not None:
        tracked = args.check.read_text(encoding="utf-8")
        if tracked != content:
            raise SystemExit(f"certificate mismatch: {args.check}")
    if args.output is None and args.check is None:
        print(content, end="")


if __name__ == "__main__":
    main()
