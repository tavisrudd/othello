#!/usr/bin/env python3
"""Independent arithmetic replay for the C812 union-profile certificate."""

from fractions import Fraction
from itertools import groupby
import json
import math
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("2026-08-02-c812-conference-cut-separation.json")
EXPECTED = {
    (1, 3, 6, 11): Fraction(5824547586, 687739675),
    (2,): Fraction(504439650, 27509587),
    (4, 5, 7, 9, 10, 12, 13, 15): Fraction(-489762702, 137547935),
    (8, 14): Fraction(-699456186, 137547935),
}


def inclusion_probability(union_size: int) -> Fraction:
    return Fraction(math.comb(26 - union_size, 13 - union_size), math.comb(26, 13))


def third_centered(graph: dict[str, object]) -> Fraction:
    pair = {int(k): v for k, v in graph["pair_profile"].items()}
    triple = {int(k): v for k, v in graph["triple_profile"].items()}
    mean = Fraction(3250) * inclusion_probability(4)
    factorial_two = sum(2 * count * inclusion_probability(size) for size, count in pair.items())
    factorial_three = sum(
        6 * count * inclusion_probability(size) for size, count in triple.items()
    )
    raw_two = factorial_two + mean
    raw_three = factorial_three + 3 * factorial_two + mean
    return raw_three - 3 * mean * raw_two + 2 * mean**3


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    graphs = data["graphs"]
    assert len(graphs) == 15
    assert len({json.dumps(g["pair_profile"], sort_keys=True) for g in graphs}) == 1
    ordered = sorted(graphs, key=lambda g: json.dumps(g["triple_profile"], sort_keys=True))
    observed = {}
    for _, group in groupby(ordered, key=lambda g: json.dumps(g["triple_profile"], sort_keys=True)):
        members = list(group)
        indices = tuple(sorted(g["index"] for g in members))
        moments = {third_centered(g) for g in members}
        assert len(moments) == 1
        observed[indices] = moments.pop()
    assert observed == EXPECTED
    assert len(set(observed.values())) == 4
    for indices, moment in sorted(observed.items()):
        print(f"indices={indices} third_centered_moment={moment}")


if __name__ == "__main__":
    main()
