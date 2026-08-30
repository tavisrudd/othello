#!/usr/bin/env python3
"""Generate native CSS-distance inputs for published SCE lifted-product codes."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


R2_ELITE_01 = {
    "group": "Dic_11",
    "modulus": 22,
    "twist": 11,
    "reported_qdistrnd_upper": 20,
    "a": [
        [(8, 0), (1, 0), (15, 0)],
        [(7, 1), (2, 0), (18, 1)],
        [(4, 0), (1, 0), (0, 0)],
        [(3, 1), (3, 0), (2, 1)],
        [(1, 0), (3, 0), (5, 0)],
    ],
    "b": [
        [(11, 0), (0, 1), (9, 0)],
        [(12, 0), (0, 0), (11, 0)],
        [(10, 0), (3, 1), (16, 0)],
        [(10, 0), (3, 0), (18, 0)],
        [(9, 0), (6, 1), (1, 1)],
    ],
}

R2_ELITE_02 = {
    "group": "D_22",
    "modulus": 22,
    "twist": 0,
    "reported_qdistrnd_upper": 16,
    "a": [
        [(12, 0), (3, 1), (17, 0)],
        [(8, 0), (0, 1), (15, 0)],
        [(4, 1), (20, 1), (13, 1)],
        [(0, 0), (17, 1), (11, 0)],
        [(19, 0), (14, 0), (9, 0)],
    ],
    "b": [
        [(21, 0), (1, 0), (10, 0)],
        [(12, 0), (0, 0), (3, 0)],
        [(3, 0), (14, 0), (3, 0)],
        [(1, 1), (6, 1), (19, 0)],
        [(14, 0), (5, 0), (11, 0)],
    ],
}

CANDIDATES = {"r2elite01": R2_ELITE_01, "r2elite02": R2_ELITE_02}


def multiply(left: tuple[int, int], right: tuple[int, int], modulus: int, twist: int) -> tuple[int, int]:
    a, b = left
    c, d = right
    exponent = a + (-c if b else c) + (twist if b and d else 0)
    return exponent % modulus, b ^ d


def inverse(value: tuple[int, int], modulus: int, twist: int) -> tuple[int, int]:
    for candidate_b in range(2):
        for candidate_a in range(modulus):
            candidate = (candidate_a, candidate_b)
            if multiply(value, candidate, modulus, twist) == (0, 0):
                return candidate
    raise AssertionError("finite group element has no inverse")


def validate_group(elements: list[tuple[int, int]], modulus: int, twist: int) -> None:
    identity = (0, 0)
    element_set = set(elements)
    for left in elements:
        if multiply(identity, left, modulus, twist) != left or multiply(left, identity, modulus, twist) != left:
            raise RuntimeError("invalid group identity")
        if inverse(left, modulus, twist) not in element_set:
            raise RuntimeError("invalid group inverse")
        for right in elements:
            if multiply(left, right, modulus, twist) not in element_set:
                raise RuntimeError("group multiplication is not closed")
            for third in elements:
                lhs = multiply(multiply(left, right, modulus, twist), third, modulus, twist)
                rhs = multiply(left, multiply(right, third, modulus, twist), modulus, twist)
                if lhs != rhs:
                    raise RuntimeError("group multiplication is not associative")


def row_basis(rows: list[int]) -> list[int]:
    pivots: dict[int, int] = {}
    for original in rows:
        value = original
        while value:
            pivot = value.bit_length() - 1
            prior = pivots.get(pivot)
            if prior is None:
                pivots[pivot] = value
                break
            value ^= prior
    return [pivots[pivot] for pivot in sorted(pivots, reverse=True)]


def nullspace(rows: list[int], columns: int) -> list[int]:
    basis = row_basis(rows)
    pivots = {row.bit_length() - 1: row for row in basis}
    result: list[int] = []
    for free in range(columns):
        if free in pivots:
            continue
        value = 1 << free
        for pivot in sorted(pivots):
            if (pivots[pivot] & value).bit_count() & 1:
                value |= 1 << pivot
        result.append(value)
    return result


def quotient_basis(space: list[int], subspace: list[int]) -> list[int]:
    basis = row_basis(subspace)
    rank = len(basis)
    quotient: list[int] = []
    for row in space:
        extended = row_basis(basis + [row])
        if len(extended) != rank:
            quotient.append(row)
            basis = extended
            rank += 1
    return quotient


def sparse(rows: list[int]) -> list[list[int]]:
    output: list[list[int]] = []
    for source in rows:
        row: list[int] = []
        while source:
            bit = source & -source
            row.append(bit.bit_length() - 1)
            source ^= bit
        output.append(row)
    return output


def support_component_count(rows: list[int], columns: int) -> int:
    parent = list(range(columns))

    def root(value: int) -> int:
        while parent[value] != value:
            parent[value] = parent[parent[value]]
            value = parent[value]
        return value

    for row in rows:
        support = sparse([row])[0]
        if not support:
            continue
        leader = root(support[0])
        for coordinate in support[1:]:
            current = root(coordinate)
            if current != leader:
                parent[current] = leader
    return len({root(coordinate) for coordinate in range(columns)})


def build_checks(candidate: dict[str, object]) -> tuple[list[int], list[int], int, int]:
    a = candidate["a"]
    b = candidate["b"]
    assert isinstance(a, list) and isinstance(b, list)
    modulus = int(candidate["modulus"])
    twist = int(candidate["twist"])
    elements = [(exponent, reflection) for reflection in range(2) for exponent in range(modulus)]
    validate_group(elements, modulus, twist)
    index = {element: position for position, element in enumerate(elements)}
    order = len(elements)
    ma, na = len(a), len(a[0])
    mb, nb = len(b), len(b[0])
    assert all(len(row) == na for row in a)
    assert all(len(row) == nb for row in b)
    first_blocks = na * nb
    second_blocks = ma * mb
    columns = (first_blocks + second_blocks) * order
    hx = [0] * (ma * nb * order)
    hz = [0] * (na * mb * order)

    def first_coordinate(ja: int, jb: int, h: int) -> int:
        return ((ja * nb + jb) * order) + h

    def second_coordinate(ia: int, ib: int, h: int) -> int:
        return (first_blocks + ia * mb + ib) * order + h

    def hx_row(ia: int, jb: int, g: int) -> int:
        return (ia * nb + jb) * order + g

    def hz_row(ja: int, ib: int, g: int) -> int:
        return (ja * mb + ib) * order + g

    for ja in range(na):
        for jb in range(nb):
            for h_index, h in enumerate(elements):
                coordinate = first_coordinate(ja, jb, h_index)
                for ia in range(ma):
                    element = a[ia][ja]
                    g = multiply(element, h, modulus, twist)
                    hx[hx_row(ia, jb, index[g])] ^= 1 << coordinate
                for ib in range(mb):
                    element = b[ib][jb]
                    g = multiply(h, inverse(element, modulus, twist), modulus, twist)
                    hz[hz_row(ja, ib, index[g])] ^= 1 << coordinate

    for ia in range(ma):
        for ib in range(mb):
            for h_index, h in enumerate(elements):
                coordinate = second_coordinate(ia, ib, h_index)
                for jb in range(nb):
                    element = b[ib][jb]
                    g = multiply(h, element, modulus, twist)
                    hx[hx_row(ia, jb, index[g])] ^= 1 << coordinate
                for ja in range(na):
                    element = a[ia][ja]
                    g = multiply(inverse(element, modulus, twist), h, modulus, twist)
                    hz[hz_row(ja, ib, index[g])] ^= 1 << coordinate

    if any((left & right).bit_count() & 1 for left in hx for right in hz):
        raise RuntimeError("generated lifted-product CSS checks do not commute")
    if any(row.bit_count() != na + mb for row in hx):
        raise RuntimeError("unexpected X-check weight")
    if any(row.bit_count() != nb + ma for row in hz):
        raise RuntimeError("unexpected Z-check weight")
    return hx, hz, columns, order


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--candidate", choices=tuple(CANDIDATES), required=True)
    parser.add_argument("--direction", choices=("x", "z"), default="x")
    parser.add_argument("--maximum-weight", type=int, required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    candidate = CANDIDATES[args.candidate]
    hx, hz, columns, order = build_checks(candidate)
    physical, stabilizers = (hx, hz) if args.direction == "x" else (hz, hx)
    physical_basis = row_basis(physical)
    stabilizer_basis = row_basis(stabilizers)
    logical = quotient_basis(nullspace(stabilizer_basis, columns), physical_basis)
    dimension = columns - len(physical_basis) - len(stabilizer_basis)
    if len(logical) != dimension:
        raise RuntimeError("logical quotient basis has the wrong dimension")
    anchors = list(range(columns))
    component_count = support_component_count(hx + hz, columns)
    if component_count != 1:
        raise RuntimeError("combined X/Z support graph is decomposable")
    output = {
        "label": f"sce-{args.candidate}-{args.direction}",
        "coordinate_count": columns,
        "physical_checks": sparse(physical),
        "logical_observations": sparse(logical),
        "anchors": anchors,
        "maximum_weight": args.maximum_weight,
        "incumbent_support": [],
        "metadata": {
            "source_schema": "Liu-Marquardt-SCE-arXiv-2606.24808v1",
            "candidate": args.candidate,
            "group": candidate["group"],
            "group_order": order,
            "direction": args.direction,
            "physical_rank": len(physical_basis),
            "stabilizer_rank": len(stabilizer_basis),
            "logical_observation_rank": len(logical),
            "reported_qdistrnd_upper": candidate["reported_qdistrnd_upper"],
            "coordinate_orbits_claimed": columns,
            "anchor_policy": "all coordinates; no non-abelian orbit reduction assumed",
            "combined_support_components": component_count,
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
