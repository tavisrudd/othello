#!/usr/bin/env python3
"""Generate transporters of the symmetric-square action on the internal points of the q=13 conic.

The normalized invertible two-by-two matrices act on the 78 internal points of the conic through
their symmetric square, and that action is transitive on the internal points and on each of the six
classes of ordered distinct pairs cut out by the normalized polar invariant.  This program emits, for
every internal point, the index of one matrix carrying the base point to it, and, for every ordered
pair of distinct internal points, the index of one matrix carrying the displayed representative of
its polar class to that pair.  It refuses to emit unless every emitted index transports as claimed
and unless both actions are verified transitive by exhaustive orbit computation in exact arithmetic
over the prime field.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from generate_minimum_word_orbits import act, internal_points, projective_matrices

Q = 13
POINTS = 78
POLAR_VALUES = (0, 1, 3, 9, 10, 12)

OUTPUT = Path(__file__).parent / "PassantCodeQ13" / "Equivariance" / "TransporterData.lean"


def polar_value(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    return (2 * first[1] * second[1] - first[0] * second[2] - first[2] * second[0]) % Q


def discriminant(point: tuple[int, int, int]) -> int:
    return (point[1] * point[1] - point[0] * point[2]) % Q


def rho(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    denominator = discriminant(first) * discriminant(second) % Q
    return polar_value(first, second) ** 2 * pow(denominator, Q - 2, Q) % Q


def point_index(points: list[tuple[int, int, int]]) -> dict[tuple[int, int, int], int]:
    return {point: index for index, point in enumerate(points)}


def point_transporters(points, matrices, index) -> list[int]:
    """One matrix index carrying internal point 0 to each internal point."""
    found: dict[int, int] = {}
    for position, matrix in enumerate(matrices):
        image = index[act(matrix, points[0])]
        found.setdefault(image, position)
    if len(found) != POINTS:
        raise SystemExit(
            f"the action is not transitive on the internal points: {len(found)} images")
    return [found[target] for target in range(POINTS)]


def pair_class(points, first: int, second: int) -> int:
    return rho(points[first], points[second])


def pair_representatives(points) -> dict[int, tuple[int, int]]:
    """The first ordered distinct pair realizing each polar class."""
    chosen: dict[int, tuple[int, int]] = {}
    for first in range(POINTS):
        for second in range(POINTS):
            if first == second:
                continue
            chosen.setdefault(pair_class(points, first, second), (first, second))
    if sorted(chosen) != sorted(POLAR_VALUES):
        raise SystemExit(f"the polar classes are {sorted(chosen)}, not {sorted(POLAR_VALUES)}")
    return chosen


def pair_transporters(points, matrices, index, representatives) -> list[int]:
    """One matrix index carrying the representative of each class to each ordered distinct pair.

    Entry `78 * first + second` holds the index; a pair with equal entries holds the length of the
    matrix list, which is the value the model's index lookup reports for an absent element.
    """
    absent = len(matrices)
    table = [absent] * (POINTS * POINTS)
    orbits: dict[tuple[int, int], int] = {}
    for position, matrix in enumerate(matrices):
        images = [index[act(matrix, point)] for point in points]
        for value, (first, second) in representatives.items():
            del value
            orbits.setdefault((images[first], images[second]), position)
    for first in range(POINTS):
        for second in range(POINTS):
            if first == second:
                continue
            if (first, second) not in orbits:
                raise SystemExit(
                    f"the pair ({first}, {second}) is not in the orbit of any representative")
            table[POINTS * first + second] = orbits[(first, second)]
    return table


def check(points, matrices, index, representatives, points_table, pairs_table) -> None:
    """Fail unless every emitted index transports as the tracked statements claim."""
    for target, position in enumerate(points_table):
        if index[act(matrices[position], points[0])] != target:
            raise SystemExit(f"the transporter of point {target} does not reach it")
    for first in range(POINTS):
        for second in range(POINTS):
            if first == second:
                continue
            position = pairs_table[POINTS * first + second]
            source = representatives[pair_class(points, first, second)]
            matrix = matrices[position]
            reached = (index[act(matrix, points[source[0]])],
                       index[act(matrix, points[source[1]])])
            if reached != (first, second):
                raise SystemExit(
                    f"the transporter of the pair ({first}, {second}) reaches {reached}")
    for value, (first, second) in representatives.items():
        if pair_class(points, first, second) != value:
            raise SystemExit(f"the representative of class {value} has the wrong polar invariant")


def render_naturals(name: str, docstring: str, values: list[int], per_line: int) -> str:
    lines = []
    for start in range(0, len(values), per_line):
        lines.append("  " + ", ".join(str(value) for value in values[start:start + per_line]) + ",")
    body = "\n".join(lines).rstrip(",")
    return f"/-- {docstring} -/\ndef {name} : List Nat := [\n{body}]\n"


def render_pairs(name: str, docstring: str, values: list[tuple[int, int]]) -> str:
    body = "\n".join(f"  ({first}, {second})," for first, second in values).rstrip(",")
    return f"/-- {docstring} -/\ndef {name} : List (Nat × Nat) := [\n{body}]\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="fail if the tracked module differs from the generated text")
    arguments = parser.parse_args()

    points = internal_points()
    matrices = projective_matrices()
    if len(points) != POINTS:
        raise SystemExit(f"expected {POINTS} internal points, computed {len(points)}")
    index = point_index(points)
    representatives = pair_representatives(points)
    points_table = point_transporters(points, matrices, index)
    pairs_table = pair_transporters(points, matrices, index, representatives)
    check(points, matrices, index, representatives, points_table, pairs_table)

    ordered = [representatives[value] for value in POLAR_VALUES]
    blocks = [
        render_naturals(
            "pointTransporterIndices",
            "Index in the normalized matrix list of a matrix carrying the internal point of index "
            "zero to the internal point of each index.",
            points_table, 8),
        render_pairs(
            "polarClassRepresentatives",
            "One ordered pair of distinct internal points for each value of the normalized polar "
            "invariant, in the order 0, 1, 3, 9, 10, 12.",
            ordered),
        render_naturals(
            "pairTransporterIndices",
            "Index in the normalized matrix list of a matrix carrying the representative of the "
            "polar class of an ordered pair to that pair.  Entry `78 * i + j` holds the index for "
            "the pair `(i, j)`; the diagonal entries hold the length of the matrix list.",
            pairs_table, 12),
    ]

    text = (
        "/-!\n"
        "# Generated transporters for the symmetric-square action on the internal points\n"
        "\n"
        "This file is generated by `generate_transporter_data.py`.  The normalized invertible\n"
        "two-by-two matrices act on the 78 internal points of the standard conic over `ZMod 13`\n"
        "through their symmetric square.  That action is transitive on the internal points and on\n"
        "each of the six classes of ordered distinct pairs cut out by the normalized polar\n"
        "invariant.  The lists below choose, for each point and for each ordered distinct pair, the\n"
        "index of one matrix realizing the corresponding transport from the base point or from the\n"
        "displayed representative of the class.  Lean checks each chosen index against the action\n"
        "it is claimed to realize; the lists carry no trust of their own, and a wrong entry makes\n"
        "the check fail rather than making a false statement provable.\n"
        "-/\n"
        "\n"
        "namespace PassantCodeQ13.Equivariance\n"
        "\n"
        + "\n".join(blocks)
        + "\nend PassantCodeQ13.Equivariance\n"
    )

    if arguments.check:
        if not OUTPUT.is_file() or OUTPUT.read_text() != text:
            raise SystemExit(f"{OUTPUT} differs from the generated text")
        print("q=13 transporter data: PASS")
        return
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(text)


if __name__ == "__main__":
    main()
