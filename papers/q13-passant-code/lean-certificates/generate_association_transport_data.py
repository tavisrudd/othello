#!/usr/bin/env python3
"""Generate the row masks of the elliptic relation matrices and of the transposed orbit matrices."""

from __future__ import annotations

import argparse
from pathlib import Path

from generate_minimum_word_orbits import REPRESENTATIVES, internal_points, support_orbit


Q = 13
POINTS = 78
ORBIT = 91
RELATION_VALUES = {
    "relationRowsRhoZero": 0,
    "relationRowsRhoNine": 9,
    "relationRowsRhoTen": 10,
    "relationRowsRhoTwelve": 12,
}
ORBIT_COLUMNS = {
    "orbitSymmetricColumns": "orbitSymmetricSupports",
    "orbitDihedralAColumns": "orbitDihedralASupports",
    "orbitDihedralBColumns": "orbitDihedralBSupports",
    "orbitDihedralCColumns": "orbitDihedralCSupports",
}
ORBIT_GRAM = {
    "orbitSymmetricColumns": 9,
    "orbitDihedralAColumns": 9,
    "orbitDihedralBColumns": 12,
    "orbitDihedralCColumns": 10,
}

OUTPUT = Path(__file__).parent / "PassantCodeQ13" / "AssociationTransport" / "RelationData.lean"

DOCSTRINGS = {
    "relationRowsRhoZero":
        "Row masks of the elliptic relation whose normalized polar invariant is zero.",
    "relationRowsRhoNine":
        "Row masks of the elliptic relation whose normalized polar invariant is nine.",
    "relationRowsRhoTen":
        "Row masks of the elliptic relation whose normalized polar invariant is ten.",
    "relationRowsRhoTwelve":
        "Row masks of the elliptic relation whose normalized polar invariant is twelve.",
    "orbitSymmetricColumns":
        "Column masks of the orbit with stabilizer isomorphic to the symmetric group on four "
        "letters, whose Gram matrix is the elliptic relation of polar invariant nine: bit `k` of "
        "entry `i` records that the `k`-th support of the orbit contains the internal point of "
        "index `i`.",
    "orbitDihedralAColumns":
        "Column masks of the orbit with a dihedral stabilizer of order 24 whose Gram matrix is the "
        "elliptic relation of polar invariant nine.",
    "orbitDihedralBColumns":
        "Column masks of the orbit with a dihedral stabilizer of order 24 whose Gram matrix is the "
        "elliptic relation of polar invariant twelve.",
    "orbitDihedralCColumns":
        "Column masks of the orbit with a dihedral stabilizer of order 24 whose Gram matrix is the "
        "elliptic relation of polar invariant ten.",
}


def polar_value(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    return (2 * first[1] * second[1] - first[0] * second[2] - first[2] * second[0]) % Q


def discriminant(point: tuple[int, int, int]) -> int:
    return (point[1] * point[1] - point[0] * point[2]) % Q


def rho(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    denominator = discriminant(first) * discriminant(second) % Q
    return polar_value(first, second) ** 2 * pow(denominator, Q - 2, Q) % Q


def relation_rows(value: int) -> list[int]:
    points = internal_points()
    rows = []
    for first in range(POINTS):
        mask = 0
        for second in range(POINTS):
            if first != second and rho(points[first], points[second]) == value:
                mask |= 1 << second
        rows.append(mask)
    return rows


def column_masks(supports: list[int]) -> list[int]:
    return [
        sum(1 << position for position, support in enumerate(supports) if support >> point & 1)
        for point in range(POINTS)
    ]


def mask_product(left: list[int], right: list[int]) -> list[int]:
    product = []
    for row in left:
        value = 0
        for position, other in enumerate(right):
            if row >> position & 1:
                value ^= other
        product.append(value)
    return product


def mask_xor(left: list[int], right: list[int]) -> list[int]:
    return [a ^ b for a, b in zip(left, right)]


def identity_masks() -> list[int]:
    return [1 << index for index in range(POINTS)]


def check(relations: dict[int, list[int]], columns: dict[str, list[int]],
          supports: dict[str, list[int]]) -> None:
    """Fail unless every identity the tracked modules state holds of the emitted masks."""
    for source, target in ((9, 10), (10, 12), (12, 9)):
        if mask_product(relations[source], relations[source]) != relations[target]:
            raise SystemExit(f"the square of relation {source} is not relation {target}")
    expected = mask_xor(identity_masks(),
                        mask_xor(relations[9], mask_xor(relations[10], relations[12])))
    if mask_product(relations[0], relations[0]) != expected:
        raise SystemExit("the square of relation 0 is not I + A9 + A10 + A12")
    if mask_product(relations[10], relations[9]) != mask_xor(relations[12], relations[9]):
        raise SystemExit("the mixed product A10 A9 is not A12 + A9")
    for name, orbit in columns.items():
        rows = supports[ORBIT_COLUMNS[name]]
        if mask_product(orbit, rows) != relations[ORBIT_GRAM[name]]:
            raise SystemExit(f"{name}: the orbit Gram matrix is not the expected relation")
        if mask_product(relations[0], orbit) != [0] * POINTS:
            raise SystemExit(f"{name}: the orbit rows do not lie in the kernel of relation 0")


def render(name: str, masks: list[int]) -> str:
    lines = []
    for start in range(0, len(masks), 3):
        lines.append("  " + ", ".join(str(mask) for mask in masks[start:start + 3]) + ",")
    body = "\n".join(lines).rstrip(",")
    return f"/-- {DOCSTRINGS[name]} -/\ndef {name} : List Nat := [\n{body}]\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="fail if the tracked module differs from the generated text")
    arguments = parser.parse_args()

    relations = {value: relation_rows(value) for value in RELATION_VALUES.values()}
    supports = {name: support_orbit(representative)
                for name, representative in REPRESENTATIVES.items()}
    for name, orbit in supports.items():
        if len(orbit) != ORBIT:
            raise SystemExit(f"{name}: expected {ORBIT} supports, computed {len(orbit)}")
    columns = {name: column_masks(supports[source]) for name, source in ORBIT_COLUMNS.items()}
    check(relations, columns, supports)

    blocks = [render(name, relations[value]) for name, value in RELATION_VALUES.items()]
    blocks.extend(render(name, masks) for name, masks in columns.items())

    text = (
        "/-!\n"
        "# Generated row masks for the association and orbit certificates\n"
        "\n"
        "This file is generated by `generate_association_transport_data.py`.  A binary matrix is\n"
        "presented by the list of its rows, each row the natural number whose set bits are the\n"
        "columns carrying the entry one.  The first four lists are the 78-by-78 adjacency matrices\n"
        "of the elliptic relations with normalized polar invariants 0, 9, 10 and 12 on the ordered\n"
        "internal points; the last four are the transposes of the 91-by-78 support matrices of the\n"
        "four minimum-word orbits.  Lean checks every list against the semantic Boolean matrix it\n"
        "encodes; the lists carry no trust of their own.\n"
        "-/\n"
        "\n"
        "namespace PassantCodeQ13.AssociationTransport\n"
        "\n"
        + "\n".join(blocks)
        + "\nend PassantCodeQ13.AssociationTransport\n"
    )

    if arguments.check:
        if not OUTPUT.is_file() or OUTPUT.read_text() != text:
            raise SystemExit(f"{OUTPUT} differs from the generated text")
        print("q=13 association transport data: PASS")
        return
    OUTPUT.write_text(text)


if __name__ == "__main__":
    main()
