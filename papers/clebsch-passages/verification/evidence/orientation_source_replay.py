#!/usr/bin/env python3
"""Independent replay of the orientation-source involution and pair map."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("orientation_source.json")


def multiply(x, y):
    return x[0] * y[0] + x[1] * y[1], x[0] * y[1] + x[1] * y[0] + x[1] * y[1]


def scalar(value: int):
    return Fraction(value), Fraction(0)


def negate(x):
    return -x[0], -x[1]


def conjugate(x):
    return x[0] + x[1], -x[1]


def vector_scale(value, vector):
    return tuple(multiply(value, entry) for entry in vector)


def main() -> int:
    payload = json.loads(CERTIFICATE.read_text())
    conference = payload["conference"]
    permutation = payload["golden_exchanger"]["old_axis_to_conjugate_axis"]
    switches = payload["golden_exchanger"]["representative_switches"]
    zero, one, t = scalar(0), scalar(1), (Fraction(0), Fraction(1))
    axes = (
        (zero, t, one), (zero, t, negate(one)), (one, zero, t),
        (negate(one), zero, t), (t, negate(one), zero), (negate(t), negate(one), zero),
    )
    conjugates = tuple(tuple(conjugate(value) for value in axis) for axis in axes)

    def exchange(vector):
        return vector[0], negate(vector[2]), vector[1]

    for index, axis in enumerate(axes):
        factor = t if switches[index] == 1 else negate(t)
        assert exchange(axis) == vector_scale(factor, conjugates[permutation[index]])

    transported = [
        [switches[i] * switches[j] * conference[permutation[i]][permutation[j]] for j in range(6)]
        for i in range(6)
    ]
    assert transported == [[-entry for entry in row] for row in conference]
    for i, j, k in itertools.combinations(range(6), 3):
        old = conference[i][j] * conference[j][k] * conference[k][i]
        new = transported[i][j] * transported[j][k] * transported[k][i]
        assert new == -old

    labels = tuple(itertools.combinations(range(5), 2))
    for distinguished in range(4):
        y = [0] * 5
        y[distinguished], y[4] = 1, -1
        pair_sum = [y[i] + y[j] for i, j in labels]
        image = [
            sum(pair_sum[c] for c, other in enumerate(labels) if set(pair).isdisjoint(other))
            for pair in labels
        ]
        assert image == [-2 * value for value in pair_sum]
        assert sum(value * value for value in pair_sum) == 3 * sum(value * value for value in y)
        assert [
            sum(pair_sum[c] for c, pair in enumerate(labels) if i in pair) for i in range(5)
        ] == [3 * value for value in y]

    assert payload["incidence_pullback"]["equation"] == "z^2=80*sigma3^2"
    assert payload["harmonic_input"]["gaunt_scalar"] == "-784000/1247103"
    print("orientation-source independent replay: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
