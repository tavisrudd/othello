#!/usr/bin/env python3
"""Generate transparent accelerating classifiers for fixed-point exhaustion."""

from __future__ import annotations

import argparse
import itertools
from pathlib import Path

from generate_minimum_word_orbits import Q, internal_points, projective_triples


OUTPUT = Path(__file__).parent / "PassantCodeQ13" / "MinimumWords" / "ExhaustionFiveOneData.lean"


def incident(line: tuple[int, int, int], point: tuple[int, int, int]) -> bool:
    return sum(left * right for left, right in zip(line, point)) % Q == 0


def conic_value(point: tuple[int, int, int]) -> int:
    x, y, z = point
    return (x * z - y * y) % Q


def geometry() -> tuple[list[list[int]], list[int]]:
    points = internal_points()
    conic = [point for point in projective_triples() if conic_value(point) == 0]
    passants = [line for line in projective_triples()
                if not any(incident(line, point) for point in conic)]
    rows = [[index for index, point in enumerate(points) if incident(line, point)]
            for line in passants]
    fibres = [sorted(set(row) - {0}) for row in rows if 0 in row]
    syndromes = [sum(1 << line for line, row in enumerate(rows) if point in row)
                 for point in range(len(points))]
    if len(points) != 78 or len(rows) != 78 or len(fibres) != 7:
        raise SystemExit("unexpected q=13 fixed-point geometry")
    return fibres, syndromes


def xor_columns(points: tuple[int, ...], syndromes: list[int]) -> int:
    value = 0
    for point in points:
        value ^= syndromes[point]
    return value


def render_tree(values: list[int], indent: str = "  ") -> str:
    if not values:
        return ".reject"
    middle = len(values) // 2
    left = render_tree(values[:middle], indent + "  ")
    right = render_tree(values[middle + 1:], indent + "  ")
    return f".branch {values[middle]}\n{indent}  ({left})\n{indent}  ({right})"


def render() -> str:
    fibres, syndromes = geometry()
    remaining = list(range(1, 7))
    values = sorted({
        xor_columns(five + head, syndromes)
        for five in itertools.combinations(fibres[0], 5)
        for head in itertools.product(*(fibres[index] for index in remaining[:3]))
    })
    return (
        "import PassantCodeQ13.MinimumWords.ExhaustionClassifier\n\n"
        "/-! Generated balanced classifier for five-one exhaustion shard zero. -/\n\n"
        "set_option maxRecDepth 100000\n\n"
        "namespace PassantCodeQ13.MinimumWords\n\n"
        "/-- Exact-syndrome classifier for five-one shard zero. -/\n"
        "def fiveOneClassifier0 : SyndromeClassifier :=\n"
        f"  {render_tree(values)}\n\n"
        "end PassantCodeQ13.MinimumWords\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    text = render()
    if arguments.check:
        if not OUTPUT.is_file() or OUTPUT.read_text() != text:
            raise SystemExit(f"{OUTPUT} differs from deterministic regeneration")
        print("q=13 fixed-point exhaustion classifier shard zero: PASS")
    else:
        OUTPUT.write_text(text)


if __name__ == "__main__":
    main()
