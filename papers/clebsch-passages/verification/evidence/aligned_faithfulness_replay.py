#!/usr/bin/env python3
"""Independent replay of the aligned-design faithfulness enumeration.

The primary certificate builds two-graphs from switching-class representatives
and reads the triple function off the edge parity.  This replay never mentions
a graph.  It builds each two-graph directly from its descendant at the point
``0``: the triples through ``0`` are assigned freely, and the parity axiom on
``{0, a, b, c}`` then forces

    tau(abc) = tau(0ab) + tau(0ac) + tau(0bc)   (mod 2).

Every four-set of the resulting triple function is checked against the axiom
before it is used, so the enumeration is validated rather than assumed, and the
counts are compared against the committed certificate.
"""

from __future__ import annotations

import json
from itertools import combinations
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("aligned_faithfulness.json")


def build_from_descendant(points: int, star: dict[frozenset[int], int]) -> dict[frozenset[int], int]:
    values: dict[frozenset[int], int] = {}
    for triple in combinations(range(points), 3):
        key = frozenset(triple)
        if 0 in key:
            values[key] = star[key]
        else:
            a, b, c = sorted(key)
            values[key] = (
                star[frozenset((0, a, b))]
                + star[frozenset((0, a, c))]
                + star[frozenset((0, b, c))]
            ) % 2
    return values


def satisfies_axiom(points: int, values: dict[frozenset[int], int]) -> bool:
    for quad in combinations(range(points), 4):
        total = sum(values[frozenset(triple)] for triple in combinations(quad, 3))
        if total % 2:
            return False
    return True


def aligned_positions(points: int, values: dict[frozenset[int], int]) -> frozenset[int]:
    aligned = set()
    for position, quad in enumerate(combinations(range(points), 4)):
        marks = {values[frozenset(triple)] for triple in combinations(quad, 3)}
        if len(marks) == 1:
            aligned.add(position)
    return frozenset(aligned)


def enumerate_level(points: int) -> tuple[int, dict[frozenset[int], list[frozenset[int]]]]:
    """Return the two-graph count and the fibres of the alignment map."""
    star_triples = [frozenset((0, a, b)) for a, b in combinations(range(1, points), 2)]
    fibres: dict[frozenset[int], list[frozenset[int]]] = {}
    total = 0
    for mask in range(1 << len(star_triples)):
        star = {
            triple: (mask >> i) & 1 for i, triple in enumerate(star_triples)
        }
        values = build_from_descendant(points, star)
        assert satisfies_axiom(points, values)
        total += 1
        signature = frozenset(
            triple for triple, value in values.items() if value == 1
        )
        fibres.setdefault(aligned_positions(points, values), []).append(signature)
    return total, fibres


def complement_signature(points: int, signature: frozenset[frozenset[int]]) -> frozenset[frozenset[int]]:
    everything = {frozenset(triple) for triple in combinations(range(points), 3)}
    return frozenset(everything - set(signature))


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    by_points = {entry["points"]: entry for entry in certificate["levels"]}

    for points in (4, 5, 6, 7):
        expected = by_points[points]
        total, fibres = enumerate_level(points)
        sizes = sorted({len(members) for members in fibres.values()})

        assert total == expected["two_graphs"], (points, total)
        assert len(fibres) == expected["aligned_families"], (points, len(fibres))
        assert sizes == expected["class_sizes"], (points, sizes)

        faithful = sizes == [2] and all(
            complement_signature(points, members[0]) == members[1]
            for members in fibres.values()
        )
        assert faithful == expected["determines_up_to_complement"]

    witness = certificate["six_point_witness"]
    star_of = {}
    for name, edges in (("G", witness["graph_G"]), ("H", witness["graph_H"])):
        edge_set = {tuple(edge) for edge in edges}
        star_of[name] = {
            frozenset((0, a, b)): (
                1 if (a, b) in edge_set or (b, a) in edge_set else 0
            )
            for a, b in combinations(range(1, 6), 2)
        }
    g_values = build_from_descendant(6, star_of["G"])
    h_values = build_from_descendant(6, star_of["H"])

    quads = list(combinations(range(6), 4))
    shared = [list(quads[i]) for i in sorted(aligned_positions(6, g_values))]
    assert shared == witness["shared_aligned_family"]
    assert aligned_positions(6, g_values) == aligned_positions(6, h_values)
    assert g_values != h_values
    assert h_values != {key: 1 - value for key, value in g_values.items()}

    print(
        "independent aligned-faithfulness replay: OK "
        "(two-graphs rebuilt from descendants at one point; "
        "16384 aligned families on seven points, every fibre a complement pair; "
        "six-point witness reproduced)"
    )


if __name__ == "__main__":
    main()
