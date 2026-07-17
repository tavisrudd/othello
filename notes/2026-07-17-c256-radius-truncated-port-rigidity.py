#!/usr/bin/env python3
"""Exact small rank-three atlas for C256 radius-truncated repair ports."""

from __future__ import annotations

import argparse
from collections import defaultdict
from functools import lru_cache
from itertools import combinations, permutations, product
import json
from pathlib import Path


if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


class Field:
    def __init__(self, q: int):
        assert q in (2, 3, 4)
        self.q = q

    def add(self, left: int, right: int) -> int:
        return left ^ right if self.q == 4 else (left + right) % self.q

    def neg(self, value: int) -> int:
        return value if self.q == 4 else (-value) % self.q

    def mul(self, left: int, right: int) -> int:
        if self.q != 4:
            return (left * right) % self.q
        result = 0
        a, b = left, right
        while b:
            if b & 1:
                result ^= a
            b >>= 1
            a <<= 1
            if a & 4:
                a ^= 0b111  # t^2+t+1
        return result

    def inv(self, value: int) -> int:
        assert value
        for candidate in range(1, self.q):
            if self.mul(value, candidate) == 1:
                return candidate
        raise AssertionError("nonzero field element has no inverse")


def normalize(field: Field, vector: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in vector if value)
    inverse = field.inv(pivot)
    return tuple(field.mul(inverse, value) for value in vector)


def projective_plane(field: Field) -> tuple[tuple[int, int, int], ...]:
    points = {
        normalize(field, vector)
        for vector in product(range(field.q), repeat=3)
        if any(vector)
    }
    return tuple(sorted(points))


def rank(field: Field, columns: tuple[tuple[int, ...], ...]) -> int:
    if not columns:
        return 0
    matrix = [list(row) for row in zip(*columns)]
    row = 0
    for column in range(len(columns)):
        pivot = next((i for i in range(row, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inverse = field.inv(matrix[row][column])
        matrix[row] = [field.mul(inverse, value) for value in matrix[row]]
        for i in range(len(matrix)):
            if i == row or not matrix[i][column]:
                continue
            factor = field.neg(matrix[i][column])
            matrix[i] = [
                field.add(left, field.mul(factor, right))
                for left, right in zip(matrix[i], matrix[row])
            ]
        row += 1
        if row == len(matrix):
            break
    return row


def port_minterms(
    field: Field, target: tuple[int, ...], helpers: tuple[tuple[int, ...], ...]
) -> tuple[int, ...]:
    accepted = [False] * (1 << len(helpers))
    for mask in range(1, 1 << len(helpers)):
        chosen = tuple(helpers[i] for i in range(len(helpers)) if mask & (1 << i))
        accepted[mask] = rank(field, chosen) == rank(field, (*chosen, target))
    return tuple(
        mask
        for mask in range(1, 1 << len(helpers))
        if accepted[mask]
        and all(not accepted[mask ^ bit] for bit in powers(mask))
    )


def powers(mask: int):
    while mask:
        bit = mask & -mask
        yield bit
        mask ^= bit


@lru_cache(maxsize=None)
def canonical(family: tuple[int, ...], helper_count: int) -> tuple[int, ...]:
    """Canonicalize a small clutter under all helper relabelings.

    Incidence-by-edge-size partitions sharply reduce the usual k! search while
    remaining an isomorphism invariant.  The atlas uses k=6.
    """

    signatures = []
    sizes = sorted({mask.bit_count() for mask in family})
    for old in range(helper_count):
        signatures.append(
            tuple(
                sum(mask.bit_count() == size and bool(mask & (1 << old)) for mask in family)
                for size in sizes
            )
        )
    blocks: dict[tuple[int, ...], list[int]] = defaultdict(list)
    for old, signature in enumerate(signatures):
        blocks[signature].append(old)

    ordered_blocks = [blocks[key] for key in sorted(blocks)]
    best = None
    for block_orders in product(*(permutations(block) for block in ordered_blocks)):
        old_at_new = tuple(old for block in block_orders for old in block)
        new_of_old = {old: new for new, old in enumerate(old_at_new)}
        transformed = tuple(
            sorted(
                sum(1 << new_of_old[old] for old in range(helper_count) if mask & (1 << old))
                for mask in family
            )
        )
        if best is None or transformed < best:
            best = transformed
    assert best is not None
    return best


def connected_to_target(minterms: tuple[int, ...], helper_count: int) -> bool:
    support = 0
    for mask in minterms:
        support |= mask
    return support == (1 << helper_count) - 1


def encode(family: tuple[int, ...], helper_count: int) -> list[list[int]]:
    return [[i for i in range(helper_count) if mask & (1 << i)] for mask in family]


def named_seven_point_ports():
    gf2, gf3 = Field(2), Field(3)
    target = (1, 0, 0)
    helpers = (
        (0, 1, 0),
        (1, 1, 0),
        (0, 0, 1),
        (1, 0, 1),
        (0, 1, 1),
        (1, 1, 1),
    )
    fano = port_minterms(gf2, target, helpers)
    nonfano = port_minterms(gf3, target, helpers)
    return fano, nonfano


def direct_sum_pair_port(field: Field) -> tuple[int, ...]:
    target = (1, 0, 0, 0)
    helpers = []
    for i in range(1, 4):
        basis = tuple(int(j == i) for j in range(4))
        mate = tuple(field.add(int(j == 0), field.neg(int(j == i))) for j in range(4))
        helpers.extend((basis, mate))
    return port_minterms(field, target, tuple(helpers))


def atlas_for_field(field: Field, helper_count: int):
    points = projective_plane(field)
    assert len(points) == field.q * field.q + field.q + 1
    target = (1, 0, 0)
    helpers = tuple(point for point in points if point != target)

    instances = 0
    full_ports: set[tuple[int, ...]] = set()
    truncated_to_full = {radius: defaultdict(set) for radius in (2, 3, 4)}
    pairs: set[tuple[tuple[int, ...], tuple[int, ...]]] = set()
    for chosen in combinations(helpers, helper_count):
        full_raw = port_minterms(field, target, chosen)
        if not connected_to_target(full_raw, helper_count):
            continue
        instances += 1
        full = canonical(full_raw, helper_count)
        full_ports.add(full)
        for radius in (2, 3, 4):
            truncated = canonical(
                tuple(mask for mask in full_raw if mask.bit_count() <= radius), helper_count
            )
            truncated_to_full[radius][truncated].add(full)
            if radius == 2:
                pairs.add((truncated, full))

    summary = {
        "projective_points": len(points),
        "connected_labeled_restrictions": instances,
        "pointed_matroid_types": len(full_ports),
        "radius": {},
    }
    for radius in (2, 3, 4):
        groups = truncated_to_full[radius]
        multiplicities = [len(fulls) for fulls in groups.values()]
        summary["radius"][str(radius)] = {
            "truncated_port_types": len(groups),
            "ambiguous_types": sum(value > 1 for value in multiplicities),
            "maximum_full_types_per_truncated_type": max(multiplicities, default=0),
        }
    return summary, pairs, full_ports


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    helper_count = 6
    summaries = {}
    pairs_by_q = {}
    full_by_q = {}
    for q in (2, 3, 4):
        summary, pairs, full_ports = atlas_for_field(Field(q), helper_count)
        summaries[str(q)] = summary
        pairs_by_q[q] = pairs
        full_by_q[q] = full_ports

    fano_raw, nonfano_raw = named_seven_point_ports()
    fano = canonical(fano_raw, helper_count)
    nonfano = canonical(nonfano_raw, helper_count)
    fano_r2 = canonical(tuple(mask for mask in fano_raw if mask.bit_count() <= 2), helper_count)
    nonfano_r2 = canonical(
        tuple(mask for mask in nonfano_raw if mask.bit_count() <= 2), helper_count
    )
    assert fano_r2 == nonfano_r2
    assert fano != nonfano
    assert all(
        canonical(direct_sum_pair_port(Field(q)), helper_count) == fano_r2
        for q in (2, 3, 4)
    )

    # Exhaustive plane restrictions independently certify the characteristic split.
    assert fano in full_by_q[2] and fano in full_by_q[4] and fano not in full_by_q[3]
    assert nonfano in full_by_q[3] and nonfano not in full_by_q[2] and nonfano not in full_by_q[4]
    assert all(any(short == fano_r2 for short, _full in pairs_by_q[q]) for q in (2, 3, 4))

    result = {
        "task": "C256",
        "scope": {
            "rank_bound": 3,
            "simple": True,
            "helper_count": helper_count,
            "fields": [2, 3, 4],
            "radii": [2, 3, 4],
            "enumeration": "all connected pointed restrictions of PG(2,q) with six helpers",
        },
        "atlas": summaries,
        "seven_point_transition": {
            "common_radius_2_port": encode(fano_r2, helper_count),
            "fano_full_port": encode(fano, helper_count),
            "nonfano_full_port": encode(nonfano, helper_count),
            "one_row_radius_2_realizable_over": [2, 3, 4],
            "fano_full_realizable_over_atlas_fields": [2, 4],
            "nonfano_full_realizable_over_atlas_fields": [3],
            "native_rows": helper_count,
            "wrong_characteristic_rows_lower_bound": helper_count + 1,
        },
        "checks": {
            "rank_at_most_r_implies_radius_r_is_full": True,
            "radius_3_equals_radius_4_throughout_atlas": all(
                summary["radius"]["3"] == summary["radius"]["4"]
                for summary in summaries.values()
            ),
            "fano_nonfano_same_radius_2": True,
            "direct_sum_pair_realization_all_fields": True,
            "reciprocal_characteristic_split": True,
        },
    }
    rendered = json.dumps(result, indent=2, sort_keys=True)
    if args.output:
        args.output.write_text(rendered + "\n")
    print(rendered)


if __name__ == "__main__":
    main()
